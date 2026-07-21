/// Model representing a participant in the Secret Santa pool.
class Participant {
  /// Unique identifier for the participant.
  final String id;

  /// Name of the participant.
  final String name;

  /// List of participant IDs that this person CANNOT give a gift to.
  final List<String> excludedParticipantIds;

  /// List of participant IDs that this person CANNOT receive a gift from.
  final List<String> excludedGiverIds;

  /// Optional fixed target participant ID that this person MUST be assigned to gift.
  final String? fixedReceiverId;

  /// Creates a new [Participant] instance.
  const Participant({
    required this.id,
    required this.name,
    this.excludedParticipantIds = const [],
    this.excludedGiverIds = const [],
    this.fixedReceiverId,
  });

  /// Creates a copy of this [Participant] with optional updated fields.
  Participant copyWith({
    String? id,
    String? name,
    List<String>? excludedParticipantIds,
    List<String>? excludedGiverIds,
    String? fixedReceiverId,
    bool clearFixedReceiver = false,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      excludedParticipantIds:
          excludedParticipantIds ?? this.excludedParticipantIds,
      excludedGiverIds: excludedGiverIds ?? this.excludedGiverIds,
      fixedReceiverId:
          clearFixedReceiver ? null : (fixedReceiverId ?? this.fixedReceiverId),
    );
  }

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'excludedParticipantIds': excludedParticipantIds,
      'excludedGiverIds': excludedGiverIds,
      'fixedReceiverId': fixedReceiverId,
    };
  }

  /// Creates a [Participant] from a JSON map.
  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as String,
      name: json['name'] as String,
      excludedParticipantIds: List<String>.from(
        (json['excludedParticipantIds'] as List? ?? []),
      ),
      excludedGiverIds: List<String>.from(
        (json['excludedGiverIds'] as List? ?? []),
      ),
      fixedReceiverId: json['fixedReceiverId'] as String?,
    );
  }
}
