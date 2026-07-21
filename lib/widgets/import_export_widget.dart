import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/secret_santa_provider.dart';

/// Widget providing UI actions for importing and exporting Secret Santa data and matches.
class ImportExportWidget extends ConsumerWidget {
  /// Creates a new [ImportExportWidget].
  const ImportExportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(secretSantaProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.swap_vert_circle_outlined,
                    color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  l10n.translate('exportImport'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Export Full Config Button
                ElevatedButton.icon(
                  onPressed: state.participants.isEmpty
                      ? null
                      : () {
                          ref
                              .read(secretSantaProvider.notifier)
                              .exportFullConfig();
                        },
                  icon: const Icon(Icons.file_download),
                  label: Text(l10n.translate('exportFull')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade50,
                    foregroundColor: Colors.deepPurple,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),

                // Export Matches Only Button
                ElevatedButton.icon(
                  onPressed: state.currentMatches.isEmpty
                      ? null
                      : () {
                          ref
                              .read(secretSantaProvider.notifier)
                              .exportMatchesOnly();
                        },
                  icon: const Icon(Icons.share),
                  label: Text(l10n.translate('exportMatchesOnly')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade50,
                    foregroundColor: Colors.deepPurple,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),

                // Import File Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final success = await ref
                        .read(secretSantaProvider.notifier)
                        .importFromFile();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? l10n.translate('importSuccess')
                                : l10n.translate('importError'),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.file_upload),
                  label: Text(l10n.translate('importFile')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade50,
                    foregroundColor: Colors.amber.shade900,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
