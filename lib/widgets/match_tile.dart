import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/participant.dart';
import '../models/secret_santa_history.dart';
import '../providers/secret_santa_provider.dart';
import 'common.dart';

/// Reusable widget for displaying a single match result with reveal/lock controls.
/// 
/// @param match - The MatchPair instance to display
/// @param isRevealed - Whether the match is revealed
/// @param isLocked - Whether the match is locked
/// @param onToggle - Callback when reveal is toggled
/// @param onToggleLock - Callback when lock is toggled
matchTile({
  required MatchPair match,
  required bool isRevealed,
  required bool isLocked,
  required VoidCallback onToggle,
  required VoidCallback onToggleLock,
}) {
  final l10n = AppLocalizations.of(context);

  return listWithSeparators(
    itemBuilder: (context, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RowWithSpacing(
          spacing: 12,
          children: [
            Expanded(
              flex: 2,
              child: TextWithStyling(
                text: match.giverName,
                bold: true,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isRevealed
                    ? ContainerWithDecoration(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.amber.shade50
                              : Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isLocked
                                ? Colors.amber.shade400
                                : Colors.deepPurple.shade200,
                          ),
                        ),
                        child: RowWithSpacing(
                          spacing: 8,
                          children: [
                            TextWithStyling(
                              text: match.receiverName,
                              bold: true,
                              color: isLocked
                                  ? Colors.amber.shade900
                                  : Colors.deepPurple,
                            ),
                            if (isLocked) ...[
                              const Icon(Icons.lock, size: 16),
                            ],
                          ],
                        ),
                      )
                    : ContainerWithDecoration(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextWithStyling(
                          text: l10n.translate('clickToReveal'),
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
            ),
            IconButtonWithTooltip(
              icon: Icon(
                isRevealed ? Icons.visibility_off : Icons.visibility,
                color: Colors.deepPurple,
              ),
              tooltip: isRevealed
                  ? l10n.translate('hide')
                  : l10n.translate('reveal'),
              onPressed: onToggle,
            ),
            IconButtonWithTooltip(
              icon: Icon(
                isLocked ? Icons.lock : Icons.lock_open_outlined,
                color: isLocked ? Colors.amber.shade800 : Colors.grey,
              ),
              tooltip: isLocked
                  ? l10n.translate('unlockAssignment')
                  : l10n.translate('lockAssignment'),
              onPressed: onToggleLock,
            ),
          ],
        ),
      );
    },
    itemCount: 1,
  );
}
