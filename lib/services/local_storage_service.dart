import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/participant.dart';
import '../models/secret_santa_history.dart';

/// Storage service for persisting participants and history in local storage.
class LocalStorageService {
  static const String _participantsKey = 'secret_santa_participants';
  static const String _historyKey = 'secret_santa_history';
  static const int maxHistoryLength = 100;

  /// Saves the list of [participants] to SharedPreferences.
  static Future<void> saveParticipants(List<Participant> participants) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = participants.map((p) => p.toJson()).toList();
    await prefs.setString(_participantsKey, jsonEncode(jsonList));
  }

  /// Loads the list of participants from SharedPreferences.
  static Future<List<Participant>> loadParticipants() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_participantsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Participant.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Saves a new history entry, keeping up to [maxHistoryLength] entries.
  static Future<void> saveHistoryEntry(SecretSantaHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHistory = await loadHistory();

    // Prepend new entry
    final updatedHistory = [entry, ...currentHistory];

    // Cap history length at maxHistoryLength (100)
    if (updatedHistory.length > maxHistoryLength) {
      updatedHistory.removeRange(maxHistoryLength, updatedHistory.length);
    }

    final jsonList = updatedHistory.map((e) => e.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  /// Loads all saved history entries from SharedPreferences.
  static Future<List<SecretSantaHistoryEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) =>
              SecretSantaHistoryEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Clears all stored history entries.
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
