import 'dart:math';
import '../models/participant.dart';
import '../models/secret_santa_history.dart';

/// Exception thrown when a valid Secret Santa matching cannot be generated.
class MatchingException implements Exception {
  /// Localizations key or message string for the error.
  final String key;

  /// Creates a new [MatchingException].
  const MatchingException(this.key);

  @override
  String toString() => key;
}

/// Service class containing logic for generating Secret Santa assignments.
class SecretSantaMatcher {
  /// Validates whether the current set of [participants] can produce a valid matching.
  /// Returns `null` if valid, or an error key string if invalid/impossible.
  static String? validateParticipants(List<Participant> participants) {
    if (participants.isEmpty) return null;
    if (participants.length < 2) {
      return 'minTwoParticipantsError';
    }

    try {
      generateMatches(participants);
      return null;
    } on MatchingException catch (e) {
      return e.key;
    } catch (_) {
      return 'noValidMatchingError';
    }
  }

  /// Generates Secret Santa pairings based on [participants], fixed assignments, and exclusion rules.
  ///
  /// Priority rules:
  /// 1. If a participant has a [fixedReceiverId], they MUST be assigned that receiver (unless invalid).
  /// 2. Giver cannot be Receiver.
  /// 3. Receiver is not in Giver's `excludedParticipantIds`.
  /// 4. Giver is not in Receiver's `excludedGiverIds`.
  /// 5. A receiver can only receive one gift.
  ///
  /// Throws [MatchingException] if valid pairings cannot be generated.
  static List<MatchPair> generateMatches(List<Participant> participants) {
    if (participants.length < 2) {
      throw const MatchingException('minTwoParticipantsError');
    }

    final random = Random();
    const maxAttempts = 1000;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final availableReceivers = List<Participant>.from(participants);
      final matches = <MatchPair>[];
      var possible = true;

      // Map participant IDs for fast lookup
      final participantMap = {for (final p in participants) p.id: p};

      // 1. Process participants with fixed assignments first
      final fixedGivers = participants.where((p) => p.fixedReceiverId != null).toList();
      for (final giver in fixedGivers) {
        final targetId = giver.fixedReceiverId!;
        final receiver = participantMap[targetId];

        // Ensure target receiver exists, is not already taken, and not the giver
        if (receiver == null ||
            !availableReceivers.any((r) => r.id == targetId) ||
            giver.id == targetId) {
          possible = false;
          break;
        }

        // Check if fixed assignment violates explicit exclusion rules
        if (giver.excludedParticipantIds.contains(targetId) ||
            receiver.excludedGiverIds.contains(giver.id)) {
          possible = false;
          break;
        }

        availableReceivers.removeWhere((r) => r.id == targetId);
        matches.add(
          MatchPair(
            giverId: giver.id,
            giverName: giver.name,
            receiverId: receiver.id,
            receiverName: receiver.name,
          ),
        );
      }

      if (!possible) continue;

      // 2. Process remaining givers without fixed assignments
      final remainingGivers =
          participants.where((p) => p.fixedReceiverId == null).toList()
            ..shuffle(random);

      for (final giver in remainingGivers) {
        final validReceivers = availableReceivers.where((receiver) {
          if (receiver.id == giver.id) return false;
          if (giver.excludedParticipantIds.contains(receiver.id)) return false;
          if (receiver.excludedGiverIds.contains(giver.id)) return false;
          return true;
        }).toList();

        if (validReceivers.isEmpty) {
          possible = false;
          break;
        }

        final selectedReceiver =
            validReceivers[random.nextInt(validReceivers.length)];
        availableReceivers.removeWhere((r) => r.id == selectedReceiver.id);

        matches.add(
          MatchPair(
            giverId: giver.id,
            giverName: giver.name,
            receiverId: selectedReceiver.id,
            receiverName: selectedReceiver.name,
          ),
        );
      }

      if (possible && matches.length == participants.length) {
        return matches;
      }
    }

    throw const MatchingException('noValidMatchingError');
  }
}
