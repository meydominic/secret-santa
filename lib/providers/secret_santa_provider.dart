import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/participant.dart';
import '../models/secret_santa_history.dart';
import '../services/import_export_service.dart';
import '../services/local_storage_service.dart';
import '../services/secret_santa_matcher.dart';

/// State representation of the Secret Santa application.
class SecretSantaState {
  /// List of current participants.
  final List<Participant> participants;

  /// Current draw matches (if any).
  final List<MatchPair> currentMatches;

  /// Saved history entries (up to 100).
  final List<SecretSantaHistoryEntry> history;

  /// Error key to localize, if any.
  final String? errorKey;

  /// Real-time validation error key (if current configuration is impossible).
  final String? validationErrorKey;

  /// Indicates if data is currently loading.
  final bool isLoading;

  /// Creates a new [SecretSantaState] instance.
  const SecretSantaState({
    this.participants = const [],
    this.currentMatches = const [],
    this.history = const [],
    this.errorKey,
    this.validationErrorKey,
    this.isLoading = false,
  });

  /// Creates a copy of [SecretSantaState] with modified fields.
  SecretSantaState copyWith({
    List<Participant>? participants,
    List<MatchPair>? currentMatches,
    List<SecretSantaHistoryEntry>? history,
    String? errorKey,
    String? validationErrorKey,
    bool? isLoading,
    bool clearError = false,
    bool clearValidationError = false,
  }) {
    return SecretSantaState(
      participants: participants ?? this.participants,
      currentMatches: currentMatches ?? this.currentMatches,
      history: history ?? this.history,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
      validationErrorKey: clearValidationError
          ? null
          : (validationErrorKey ?? this.validationErrorKey),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Riverpod Notifier managing the state of the Secret Santa application.
class SecretSantaNotifier extends Notifier<SecretSantaState> {
  @override
  SecretSantaState build() {
    _loadInitialData();
    return const SecretSantaState(isLoading: true);
  }

  /// Loads initial state from local storage.
  Future<void> _loadInitialData() async {
    final participants = await LocalStorageService.loadParticipants();
    final history = await LocalStorageService.loadHistory();

    final validationError =
        SecretSantaMatcher.validateParticipants(participants);

    state = state.copyWith(
      participants: participants,
      history: history,
      validationErrorKey: validationError,
      clearValidationError: validationError == null,
      isLoading: false,
    );
  }

  /// Helper to update participants and trigger real-time validation.
  Future<void> _updateParticipantsAndValidate(
      List<Participant> updatedParticipants) async {
    final validationError =
        SecretSantaMatcher.validateParticipants(updatedParticipants);

    state = state.copyWith(
      participants: updatedParticipants,
      validationErrorKey: validationError,
      clearValidationError: validationError == null,
      clearError: true,
    );
    await LocalStorageService.saveParticipants(updatedParticipants);
  }

  /// Exports full configuration (participants with exclusion rules & fixed assignments, plus matches).
  void exportFullConfig() {
    ImportExportService.exportFullConfig(
      participants: state.participants,
      matches: state.currentMatches,
    );
  }

  /// Exports only the current matches pairing list.
  void exportMatchesOnly() {
    ImportExportService.exportMatchesOnly(
      matches: state.currentMatches,
    );
  }

  /// Imports data from a JSON file selected by the user.
  /// Returns `true` on success, `false` on failure or cancellation.
  Future<bool> importFromFile() async {
    final imported = await ImportExportService.importJsonFile();
    if (imported == null) return false;

    final importedParticipants =
        imported['participants'] as List<Participant>?;
    final importedMatches = imported['matches'] as List<MatchPair>?;

    if (importedParticipants != null && importedParticipants.isNotEmpty) {
      await _updateParticipantsAndValidate(importedParticipants);
    }

    if (importedMatches != null && importedMatches.isNotEmpty) {
      state = state.copyWith(
        currentMatches: importedMatches,
        clearError: true,
      );
    }

    return true;
  }

  /// Adds a new participant with [name].
  Future<void> addParticipant(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final newParticipant = Participant(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmed,
    );

    final updated = [...state.participants, newParticipant];
    await _updateParticipantsAndValidate(updated);
  }

  /// Updates the name of participant with [id] to [newName].
  Future<void> updateParticipantName(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    final updated = state.participants.map((p) {
      if (p.id == id) {
        return p.copyWith(name: trimmed);
      }
      return p;
    }).toList();

    await _updateParticipantsAndValidate(updated);
  }

  /// Sets or clears a fixed receiver for participant [giverId].
  Future<void> setFixedReceiver(String giverId, String? targetReceiverId) async {
    final updated = state.participants.map((p) {
      if (p.id == giverId) {
        if (targetReceiverId == null) {
          return p.copyWith(clearFixedReceiver: true);
        } else {
          return p.copyWith(fixedReceiverId: targetReceiverId);
        }
      }
      return p;
    }).toList();

    await _updateParticipantsAndValidate(updated);
  }

  /// Locks or unlocks a match pair [giverId] -> [receiverId].
  Future<void> toggleLockMatch(String giverId, String receiverId) async {
    final participant = state.participants.firstWhere(
      (p) => p.id == giverId,
      orElse: () => const Participant(id: '', name: ''),
    );

    if (participant.id.isEmpty) return;

    if (participant.fixedReceiverId == receiverId) {
      await setFixedReceiver(giverId, null);
    } else {
      await setFixedReceiver(giverId, receiverId);
    }
  }

  /// Removes the participant with [id] and cleans up exclusions & locks referencing this ID.
  Future<void> removeParticipant(String id) async {
    final updated = state.participants
        .where((p) => p.id != id)
        .map((p) => p.copyWith(
              excludedParticipantIds: p.excludedParticipantIds
                  .where((excludedId) => excludedId != id)
                  .toList(),
              excludedGiverIds: p.excludedGiverIds
                  .where((excludedId) => excludedId != id)
                  .toList(),
              clearFixedReceiver: p.fixedReceiverId == id,
            ))
        .toList();

    await _updateParticipantsAndValidate(updated);
  }

  /// Toggles an exclusion for [participantId] giving to [targetId].
  Future<void> toggleExclusionGiveTo(String participantId, String targetId) async {
    final updated = state.participants.map((p) {
      if (p.id == participantId) {
        final currentExclusions = List<String>.from(p.excludedParticipantIds);
        if (currentExclusions.contains(targetId)) {
          currentExclusions.remove(targetId);
        } else {
          currentExclusions.add(targetId);
        }
        return p.copyWith(excludedParticipantIds: currentExclusions);
      }
      return p;
    }).toList();

    await _updateParticipantsAndValidate(updated);
  }

  /// Toggles an exclusion for [participantId] receiving from [targetId].
  Future<void> toggleExclusionReceiveFrom(
      String participantId, String targetId) async {
    final updated = state.participants.map((p) {
      if (p.id == participantId) {
        final currentExclusions = List<String>.from(p.excludedGiverIds);
        if (currentExclusions.contains(targetId)) {
          currentExclusions.remove(targetId);
        } else {
          currentExclusions.add(targetId);
        }
        return p.copyWith(excludedGiverIds: currentExclusions);
      }
      return p;
    }).toList();

    await _updateParticipantsAndValidate(updated);
  }

  /// Triggers a reroll/draw of Secret Santa pairs.
  Future<void> generateMatches(AppLocalizations l10n) async {
    try {
      final matches = SecretSantaMatcher.generateMatches(state.participants);

      final titlePrefix = l10n.translate('drawTitlePrefix');
      final newHistoryEntry = SecretSantaHistoryEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        matches: matches,
        title: '$titlePrefix${state.history.length + 1}',
      );

      await LocalStorageService.saveHistoryEntry(newHistoryEntry);
      final updatedHistory = await LocalStorageService.loadHistory();

      state = state.copyWith(
        currentMatches: matches,
        history: updatedHistory,
        clearError: true,
      );
    } on MatchingException catch (e) {
      state = state.copyWith(errorKey: e.key);
    } catch (_) {
      state = state.copyWith(errorKey: 'unexpectedError');
    }
  }

  /// Loads matches from a [historyEntry].
  void loadHistoryEntry(SecretSantaHistoryEntry historyEntry) {
    state = state.copyWith(
      currentMatches: historyEntry.matches,
      clearError: true,
    );
  }

  /// Clears the history log.
  Future<void> clearHistory() async {
    await LocalStorageService.clearHistory();
    state = state.copyWith(history: []);
  }
}

/// Global Riverpod provider for Secret Santa state.
final secretSantaProvider =
    NotifierProvider<SecretSantaNotifier, SecretSantaState>(
  SecretSantaNotifier.new,
);
