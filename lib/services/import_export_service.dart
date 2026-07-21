import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../models/participant.dart';
import '../models/secret_santa_history.dart';

/// Helper service for exporting and importing Secret Santa configuration & matches as JSON files.
class ImportExportService {
  /// Exports full configuration (participants with exclusion rules & fixed assignments, and current matches).
  static void exportFullConfig({
    required List<Participant> participants,
    required List<MatchPair> matches,
  }) {
    final data = {
      'version': 1,
      'type': 'full_config',
      'exportedAt': DateTime.now().toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'matches': matches.map((m) => m.toJson()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    _downloadFile(jsonString, 'secret_santa_full_config.json');
  }

  /// Exports only the current matches pairing list (giving -> receiving).
  static void exportMatchesOnly({
    required List<MatchPair> matches,
  }) {
    final data = {
      'version': 1,
      'type': 'matches_only',
      'exportedAt': DateTime.now().toIso8601String(),
      'matches': matches.map((m) => m.toJson()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    _downloadFile(jsonString, 'secret_santa_matches.json');
  }

  /// Triggers a web file download for [content] with [filename].
  static void _downloadFile(String content, String filename) {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final jsArray = bytes.toJS;
      final blob = web.Blob([jsArray].toJS);
      final url = web.URL.createObjectURL(blob);
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = filename;
      anchor.click();
      web.URL.revokeObjectURL(url);
    }
  }

  /// Pick and parse a JSON file for import using web HTML input.
  /// Returns a map with parsed 'participants' and/or 'matches', or `null` if cancelled/invalid.
  static Future<Map<String, dynamic>?> importJsonFile() async {
    if (!kIsWeb) return null;

    try {
      final input = web.HTMLInputElement()
        ..type = 'file'
        ..accept = '.json';

      input.click();

      await input.onChange.first;

      final files = input.files;
      if (files == null || files.length == 0) return null;

      final file = files.item(0);
      if (file == null) return null;

      final reader = web.FileReader();
      reader.readAsText(file);

      await reader.onLoadEnd.first;

      final jsonString = reader.result.toString();
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      final participantsJson = jsonMap['participants'] as List<dynamic>?;
      final matchesJson = jsonMap['matches'] as List<dynamic>?;

      List<Participant>? participants;
      if (participantsJson != null) {
        participants = participantsJson
            .map((p) => Participant.fromJson(p as Map<String, dynamic>))
            .toList();
      }

      List<MatchPair>? matches;
      if (matchesJson != null) {
        matches = matchesJson
            .map((m) => MatchPair.fromJson(m as Map<String, dynamic>))
            .toList();
      }

      return {
        'type': jsonMap['type'] ?? 'unknown',
        'participants': participants,
        'matches': matches,
      };
    } catch (_) {
      return null;
    }
  }
}
