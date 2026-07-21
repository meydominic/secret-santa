import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/secret_santa_history.dart';
import '../providers/secret_santa_provider.dart';

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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.translate('history')} (${history.length}/100)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                if (history.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(secretSantaProvider.notifier).clearHistory();
                    },
                    icon: const Icon(Icons.delete_sweep, size: 18),
                    label: Text(l10n.translate('clearHistory')),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    l10n.translate('noHistoryYet'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: history.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    return _ExpandableHistoryTile(
                      entry: entry,
                      formattedDate: _formatDateTime(entry.timestamp),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
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
