import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/secret_santa_provider.dart';
import 'common.dart';

/// Widget providing UI actions for importing and exporting Secret Santa data and matches.
class ImportExportWidget extends ConsumerWidget {
  /// Creates a new [ImportExportWidget].
  const ImportExportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(secretSantaProvider);

    return cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon and Title
          RowWithSpacing(
            children: [
              const Icon(Icons.swap_vert_circle_outlined, color: Colors.deepPurple),
              const SizedBox(width: 8),
              TextWithStyling(
                text: l10n.translate('exportImport'),
                bold: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          WrapWithSpacing(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Export Full Config Button
              ElevatedButtonWithMaterial3(
                onPressed: state.participants.isEmpty
                    ? null
                    : () {
                        ref
                            .read(secretSantaProvider.notifier)
                            .exportFullConfig();
                      },
                icon: const Icon(Icons.file_download),
                label: l10n.translate('exportFull'),
              ),

              // Export Matches Only Button
              ElevatedButtonWithMaterial3(
                onPressed: state.currentMatches.isEmpty
                    ? null
                    : () {
                        ref
                            .read(secretSantaProvider.notifier)
                            .exportMatchesOnly();
                      },
                icon: const Icon(Icons.share),
                label: l10n.translate('exportMatchesOnly'),
              ),

              // Import File Button
              ElevatedButtonWithMaterial3(
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
                label: l10n.translate('importFile'),
                backgroundColor: Colors.amber.shade50,
                foregroundColor: Colors.amber.shade900,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Reusable widget for a Wrap with spacing and styling.
/// 
/// @param children - The list of children widgets
/// @param spacing - The horizontal spacing between children (default: 12)
/// @param runSpacing - The vertical spacing between rows (default: 12)
/// @param alignment - The alignment along the cross axis (default: Alignment.center)
/// @param verticalAlignment - The alignment along the vertical axis (default: VerticalAlignment.center)
WrapWithSpacing({
  required List<Widget> children,
  double spacing = 12,
  double runSpacing = 12,
  Alignment alignment = Alignment.center,
  VerticalAlignment verticalAlignment = VerticalAlignment.center,
}) {
  return Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    children: children,
    alignment: alignment,
    verticalAlignment: verticalAlignment,
  );
}

