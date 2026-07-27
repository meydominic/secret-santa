import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/secret_santa_history.dart';
import '../providers/secret_santa_provider.dart';
import 'common.dart';

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
