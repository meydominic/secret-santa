import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/participant.dart';
import '../providers/secret_santa_provider.dart';
import 'common.dart';
import 'participant_tile.dart'; // New reusable tile widget

/// Widget displaying the list of participants, inline editing, dropdown exclusions, and fixed assignments.
class ParticipantListWidget extends ConsumerStatefulWidget {
  /// Creates a new [ParticipantListWidget].
  const ParticipantListWidget({super.key});

  @override
  ConsumerState<ParticipantListWidget> createState() =>
      _ParticipantListWidgetState();
}

class _ParticipantListWidgetState extends ConsumerState<ParticipantListWidget> {
  final TextEditingController _addController = TextEditingController();
  final FocusNode _addFocusNode = FocusNode();

  @override
  void dispose() {
    _addController.dispose();
    _addFocusNode.dispose();
    super.dispose();
  }

  void _addParticipant() {
    final name = _addController.text;
    if (name.trim().isNotEmpty) {
      ref.read(secretSantaProvider.notifier).addParticipant(name);
      _addController.clear();
      _addFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(secretSantaProvider);
    final participants = state.participants;

    return cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon and Title
          RowWithSpacing(
            children: [
              const Icon(Icons.people, color: Colors.deepPurple),
              const SizedBox(width: 8),
              TextWithStyling(
                text: '${l10n.translate('participants')} (${participants.length})',
                bold: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add Participant Input
          RowWithSpacing(
            spacing: 8,
            children: [
              Expanded(
                child: TextFieldWithMaterial3(
                  controller: _addController,
                  focusNode: _addFocusNode,
                  decoration: InputDecoration(
                    hintText: l10n.translate('enterNameHint'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _addParticipant(),
                ),
              ),
              ElevatedButtonWithMaterial3(
                onPressed: _addParticipant,
                icon: const Icon(Icons.add),
                label: l10n.translate('add'),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Empty State or Participant List
          participants.isEmpty
              ? ContainerWithDecoration(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextWithStyling(
                    text: l10n.translate('noParticipantsYet'),
                    color: Colors.grey,
                  ),
                )
              : listWithSeparators(
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return participantTile(
                      participant: participant,
                      allParticipants: participants,
                    );
                  },
                  itemCount: participants.length,
                ),
        ],
      ),
    );
  }
}

class _ParticipantTile extends ConsumerStatefulWidget {
  final Participant participant;
  final List<Participant> allParticipants;

  const _ParticipantTile({
    required this.participant,
    required this.allParticipants,
  });

  @override
  ConsumerState<_ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends ConsumerState<_ParticipantTile> {
  late TextEditingController _editController;
  bool _isEditing = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.participant.name);
  }

  @override
  void didUpdateWidget(covariant _ParticipantTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participant.name != widget.participant.name && !_isEditing) {
      _editController.text = widget.participant.name;
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _saveEdit() {
    if (_editController.text.trim().isNotEmpty) {
      ref.read(secretSantaProvider.notifier).updateParticipantName(
            widget.participant.id,
            _editController.text.trim(),
          );
    } else {
      _editController.text = widget.participant.name;
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final otherParticipants = widget.allParticipants
        .where((p) => p.id != widget.participant.id)
        .toList();

    final hasExclusionsOrFixed =
        widget.participant.excludedParticipantIds.isNotEmpty ||
            widget.participant.excludedGiverIds.isNotEmpty ||
            widget.participant.fixedReceiverId != null;

    final fixedReceiverName = widget.allParticipants
        .where((p) => p.id == widget.participant.fixedReceiverId)
        .map((p) => p.name)
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _editController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        onSubmitted: (_) => _saveEdit(),
                      )
                    : GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              widget.participant.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.participant.fixedReceiverId != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber.shade700),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock,
                                        size: 12, color: Colors.amber.shade900),
                                    const SizedBox(width: 4),
                                    Text(
                                      '→ $fixedReceiverName',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              if (otherParticipants.isNotEmpty)
                IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.tune
                        : (hasExclusionsOrFixed
                            ? Icons.tune
                            : Icons.tune_outlined),
                    size: 20,
                    color: hasExclusionsOrFixed
                        ? Colors.deepPurple
                        : Colors.grey,
                  ),
                  tooltip: l10n.translate('exclusions'),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit,
                    size: 20, color: Colors.deepPurple),
                onPressed: () {
                  if (_isEditing) {
                    _saveEdit();
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
                tooltip:
                    _isEditing ? l10n.translate('save') : l10n.translate('edit'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: Colors.redAccent),
                onPressed: () {
                  ref
                      .read(secretSantaProvider.notifier)
                      .removeParticipant(widget.participant.id);
                },
                tooltip: l10n.translate('delete'),
              ),
            ],
          ),
          if (_isExpanded && otherParticipants.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed assignment dropdown
                  Text(
                    l10n.translate('fixedAssignment'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String?>(
                    initialValue: widget.participant.fixedReceiverId,
                    isDense: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(
                          l10n.translate('noFixedAssignment'),
                          style: const TextStyle(
                              fontSize: 13, fontStyle: FontStyle.italic),
                        ),
                      ),
                      ...otherParticipants.map((other) {
                        return DropdownMenuItem<String?>(
                          value: other.id,
                          child: Text(
                            other.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }),
                    ],
                    onChanged: (selectedId) {
                      ref
                          .read(secretSantaProvider.notifier)
                          .setFixedReceiver(widget.participant.id, selectedId);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Exclusion 1: Cannot gift to (Dropdown style popup/chips)
                  Text(
                    l10n.translate('cannotGiftTo'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: otherParticipants.map((other) {
                      final isExcluded = widget.participant.excludedParticipantIds
                          .contains(other.id);
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return FilterChip(
                        label: Text(
                          other.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: isExcluded
                                ? (isDark
                                    ? Colors.red.shade200
                                    : Colors.red.shade900)
                                : (isDark
                                    ? Colors.grey.shade300
                                    : Colors.black87),
                          ),
                        ),
                        selected: isExcluded,
                        selectedColor: isDark
                            ? Colors.red.shade900.withValues(alpha: 0.5)
                            : Colors.red.shade100,
                        backgroundColor:
                            isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        checkmarkColor:
                            isDark ? Colors.red.shade200 : Colors.red.shade900,
                        onSelected: (_) {
                          ref
                              .read(secretSantaProvider.notifier)
                              .toggleExclusionGiveTo(
                                widget.participant.id,
                                other.id,
                              );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Exclusion 2: Cannot be gifted by
                  Text(
                    l10n.translate('cannotBeGiftedBy'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: otherParticipants.map((other) {
                      final isExcluded =
                          widget.participant.excludedGiverIds.contains(other.id);
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return FilterChip(
                        label: Text(
                          other.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: isExcluded
                                ? (isDark
                                    ? Colors.orange.shade200
                                    : Colors.orange.shade900)
                                : (isDark
                                    ? Colors.grey.shade300
                                    : Colors.black87),
                          ),
                        ),
                        selected: isExcluded,
                        selectedColor: isDark
                            ? Colors.orange.shade900.withValues(alpha: 0.5)
                            : Colors.orange.shade100,
                        backgroundColor:
                            isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        checkmarkColor: isDark
                            ? Colors.orange.shade200
                            : Colors.orange.shade900,
                        onSelected: (_) {
                          ref
                              .read(secretSantaProvider.notifier)
                              .toggleExclusionReceiveFrom(
                                widget.participant.id,
                                other.id,
                              );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
