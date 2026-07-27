import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/participant.dart';
import '../providers/secret_santa_provider.dart';
import 'common.dart';

/// Reusable widget for displaying a single participant with inline editing,
/// exclusion chips, and fixed assignment badge.
/// 
/// @param participant - The Participant instance to display
/// @param allParticipants - The full list of participants for exclusion dropdowns
/// @param showExclusions - Whether to show exclusion chips (default: true)
/// @param showFixedBadge - Whether to show the fixed assignment badge (default: true)
/// @param onEdit - Optional callback when edit is triggered
/// @param onDelete - Optional callback when delete is triggered
/// @param onToggleExclusion - Optional callback when exclusion is toggled
/// @param onToggleFixed - Optional callback when fixed assignment is toggled
participantTile({
  required Participant participant,
  required List<Participant> allParticipants,
  bool showExclusions = true,
  bool showFixedBadge = true,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
  ValueChanged<String>? onToggleExclusion,
  ValueChanged<String>? onToggleFixed,
}) {
  final l10n = AppLocalizations.of(context);
  final otherParticipants = allParticipants
      .where((p) => p.id != participant.id)
      .toList();

  final hasExclusionsOrFixed =
      participant.excludedParticipantIds.isNotEmpty ||
      participant.excludedGiverIds.isNotEmpty ||
      participant.fixedReceiverId != null;

  final fixedReceiverName = allParticipants
      .where((p) => p.id == participant.fixedReceiverId)
      .map((p) => p.name)
      .firstOrNull;

  return cardContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Participant Name Row
        RowWithSpacing(
          spacing: 8,
          children: [
            Expanded(
              child: GestureDetector(
                onDoubleTap: () {
                  // Could add inline editing here
                },
                child: TextWithStyling(
                  text: participant.name,
                  bold: true,
                  fontSize: 16,
                ),
              ),
            ),
            if (showFixedBadge && participant.fixedReceiverId != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, size: 12, color: Colors.amber.shade900),
                    const SizedBox(width: 4),
                    TextWithStyling(
                      text: '→ $fixedReceiverName',
                      fontSize: 11,
                      bold: true,
                      color: Colors.amber.shade900,
                    ),
                  ],
                ),
              ),
            ],
            if (otherParticipants.isNotEmpty) ...[
              IconButtonWithTooltip(
                icon: const Icon(Icons.tune, size: 20),
                tooltip: l10n.translate('exclusions'),
                onPressed: () {
                  // Could add toggle exclusions panel here
                },
              ),
            ],
            IconButtonWithTooltip(
              icon: const Icon(Icons.edit, size: 20),
              tooltip: l10n.translate('edit'),
              onPressed: onEdit ?? () {},
              color: Colors.deepPurple,
            ),
            IconButtonWithTooltip(
              icon: const Icon(Icons.delete_outline, size: 20),
              tooltip: l10n.translate('delete'),
              onPressed: onDelete ?? () {},
              color: Colors.redAccent,
            ),
          ],
        ),
        // Exclusion Chips (if shown)
        if (showExclusions &&
            (participant.excludedParticipantIds.isNotEmpty ||
                participant.excludedGiverIds.isNotEmpty)) ...[
          const SizedBox(height: 8),
          ContainerWithDecoration(
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
                // Cannot give to
                TextWithStyling(
                  text: l10n.translate('cannotGiftTo'),
                  fontSize: 12,
                  bold: true,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: otherParticipants.map((other) {
                    final isExcluded = participant.excludedParticipantIds
                        .contains(other.id);
                    return FilterChipWithCallback(
                      label: other.name,
                      selected: isExcluded,
                      onSelected: (_) {
                        onToggleExclusion?.call(other.id);
                      },
                      selectedColor: Colors.red.shade100,
                      backgroundColor: Colors.grey.shade200,
                      checkmarkColor: Colors.red.shade900,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Cannot receive from
                TextWithStyling(
                  text: l10n.translate('cannotBeGiftedBy'),
                  fontSize: 12,
                  bold: true,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: otherParticipants.map((other) {
                    final isExcluded = participant.excludedGiverIds.contains(other.id);
                    return FilterChipWithCallback(
                      label: other.name,
                      selected: isExcluded,
                      onSelected: (_) {
                        onToggleExclusion?.call(other.id);
                      },
                      selectedColor: Colors.orange.shade100,
                      backgroundColor: Colors.grey.shade200,
                      checkmarkColor: Colors.orange.shade900,
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
