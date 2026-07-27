import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/secret_santa_history.dart';
import '../providers/secret_santa_provider.dart';
import 'common.dart';
import 'history_tile.dart'; // New reusable tile widget

/// Widget displaying draw history (up to 100 entries) with expandable match preview and load option.
class HistoryWidget extends ConsumerWidget {
  /// Creates a new [HistoryWidget].
  const HistoryWidget({super.key});

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(secretSantaProvider.select((s) => s.history));

    return cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon and Title
          RowWithSpacing(
            children: [
              const Icon(Icons.history, color: Colors.deepPurple),
              const SizedBox(width: 8),
              TextWithStyling(
                text: '${l10n.translate('history')} (${history.length}/100)',
                bold: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Clear History Button
          if (history.isNotEmpty) ...[
            TextButtonWithMaterial3(
              onPressed: () {
                ref.read(secretSantaProvider.notifier).clearHistory();
              },
              icon: const Icon(Icons.delete_sweep, size: 18),
              label: l10n.translate('clearHistory'),
              color: Colors.redAccent,
            ),
          ],
          const SizedBox(height: 16),
          // Empty State or History List
          history.isEmpty
              ? ContainerWithDecoration(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextWithStyling(
                    text: l10n.translate('noHistoryYet'),
                    color: Colors.grey,
                  ),
                )
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: listWithSeparators(
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      return historyTile(
                        entry: entry,
                        formattedDate: _formatDateTime(entry.timestamp),
                      );
                    },
                    itemCount: history.length,
                  ),
                ),
        ],
      ),
    );
  }
}

/// Reusable widget for displaying a single history entry with expandable match preview and load option.
/// 
/// @param entry - The SecretSantaHistoryEntry instance to display
/// @param formattedDate - The formatted date string
/// @param onExpand - Optional callback when tile is expanded
/// @param onLoad - Optional callback when load button is pressed
historyTile({
  required SecretSantaHistoryEntry entry,
  required String formattedDate,
  VoidCallback? onExpand,
  VoidCallback? onLoad,
}) {
  final l10n = AppLocalizations.of(context);

  return listWithSeparators(
    itemBuilder: (context, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            // ListTile for the history entry
            ListTileWithSpacing(
              title: TextWithStyling(
                text: entry.title,
                bold: true,
              ),
              subtitle: TextWithStyling(
                text: '${formattedDate} • ${entry.matches.length} ${l10n.translate('pairs')}',
                fontSize: 12,
                color: Colors.grey,
              ),
              trailing: RowWithSpacing(
                spacing: 8,
                children: [
                  IconButtonWithTooltip(
                    icon: Icon(Icons.keyboard_arrow_down),
                    tooltip: 'Expand',
                    onPressed: onExpand ?? () {},
                  ),
                  ElevatedButtonWithMaterial3(
                    onPressed: onLoad ?? () {},
                    label: l10n.translate('load'),
                    backgroundColor: Colors.deepPurple.shade50,
                    foregroundColor: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
    itemCount: 1,
  );
}

/// Reusable widget for a ListTile with spacing and styling.
/// 
/// @param title - The title widget
/// @param subtitle - The subtitle widget
/// @param trailing - The trailing widget
/// @param leading - Optional leading widget
/// @param onTap - Optional tap callback
/// @param padding - Optional padding
ListTileWithSpacing({
  required Widget title,
  required Widget subtitle,
  required Widget trailing,
  Widget? leading,
  VoidCallback? onTap,
  EdgeInsets? padding,
}) {
  return ListTile(
    leading: leading,
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    onTap: onTap,
    contentPadding: padding,
  );
}


class _ExpandableHistoryTile extends ConsumerStatefulWidget {
  final SecretSantaHistoryEntry entry;
  final String formattedDate;

  const _ExpandableHistoryTile({
    required this.entry,
    required this.formattedDate,
  });

  @override
  ConsumerState<_ExpandableHistoryTile> createState() =>
      _ExpandableHistoryTileState();
}

class _ExpandableHistoryTileState
    extends ConsumerState<_ExpandableHistoryTile> {
  bool _isExpanded = false;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            widget.entry.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${widget.formattedDate} • ${widget.entry.matches.length} ${l10n.translate('pairs')}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                tooltip: _isExpanded ? 'Einklappen' : 'Ergebnisse aufklappen',
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(secretSantaProvider.notifier)
                      .loadHistoryEntry(widget.entry);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${widget.entry.title} ${l10n.translate('drawLoaded')}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.download, size: 16),
                label: Text(l10n.translate('load')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade50,
                  foregroundColor: Colors.deepPurple,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ergebnisse:',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      icon: Icon(
                        _showDetails ? Icons.visibility_off : Icons.visibility,
                        size: 14,
                      ),
                      label: Text(
                        _showDetails
                            ? l10n.translate('hideAll')
                            : l10n.translate('showAll'),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...widget.entry.matches.map((match) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            match.giverName,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            size: 14, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _showDetails ? match.receiverName : '••••••••',
                            style: TextStyle(
                              fontSize: 13,
                              color: _showDetails
                                  ? Colors.deepPurple
                                  : Colors.grey,
                              fontWeight: _showDetails
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
