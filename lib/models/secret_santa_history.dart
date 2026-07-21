/// Model representing a single Secret Santa match pairing (giver -> receiver).
class MatchPair {
  /// ID of the person giving the gift.
  final String giverId;

  /// Name of the person giving the gift.
  final String giverName;

  /// ID of the person receiving the gift.
  final String receiverId;

  /// Name of the person receiving the gift.
  final String receiverName;

  /// Creates a new [MatchPair] instance.
  const MatchPair({
    required this.giverId,
    required this.giverName,
    required this.receiverId,
    required this.receiverName,
  });

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'giverId': giverId,
      'giverName': giverName,
      'receiverId': receiverId,
      'receiverName': receiverName,
    };
  }

  /// Creates a [MatchPair] from a JSON map.
  factory MatchPair.fromJson(Map<String, dynamic> json) {
    return MatchPair(
      giverId: json['giverId'] as String,
      giverName: json['giverName'] as String,
      receiverId: json['receiverId'] as String,
      receiverName: json['receiverName'] as String,
    );
  }
}

/// Model representing a saved Secret Santa draw session/history entry.
class SecretSantaHistoryEntry {
  /// Unique identifier for the history entry.
  final String id;

  /// Timestamp when the draw was performed.
  final DateTime timestamp;

  /// List of matched pairs in this draw.
  final List<MatchPair> matches;

  /// Optional custom title/label for the draw session.
  final String title;

  /// Creates a new [SecretSantaHistoryEntry] instance.
  const SecretSantaHistoryEntry({
    required this.id,
    required this.timestamp,
    required this.matches,
    required this.title,
  });

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'matches': matches.map((m) => m.toJson()).toList(),
      'title': title,
    };
  }

  /// Creates a [SecretSantaHistoryEntry] from a JSON map.
  factory SecretSantaHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SecretSantaHistoryEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      matches: (json['matches'] as List<dynamic>)
          .map((m) => MatchPair.fromJson(m as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
    );
  }
}
