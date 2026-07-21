import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/participant.dart';
import '../models/secret_santa_history.dart';
import '../providers/secret_santa_provider.dart';

/// Widget displaying the active Secret Santa match results with reveal & lock toggle.
class MatchResultsWidget extends ConsumerStatefulWidget {
  /// Creates a new [MatchResultsWidget].
  const MatchResultsWidget({super.key});

  @override
  ConsumerState<MatchResultsWidget> createState() => _MatchResultsWidgetState();
}

class _MatchResultsWidgetState extends ConsumerState<MatchResultsWidget> {
  final Set<String> _revealedGiverIds = {};

  void _toggleReveal(String giverId) {
    setState(() {
      if (_revealedGiverIds.contains(giverId)) {
        _revealedGiverIds.remove(giverId);
      } else {
        _revealedGiverIds.add(giverId);
      }
    });
  }

  void _revealAll() {
    final matches = ref.read(secretSantaProvider).currentMatches;
    setState(() {
      _revealedGiverIds.addAll(matches.map((m) => m.giverId));
    });
  }

  void _hideAll() {
    setState(() {
      _revealedGiverIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(secretSantaProvider);
    final matches = state.currentMatches;

    if (matches.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  l10n.translate('noDrawYet'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate('noDrawSubtext'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                    const Icon(Icons.card_giftcard, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.translate('results')} (${matches.length} ${l10n.translate('pairs')})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _revealAll,
                      icon: const Icon(Icons.visibility, size: 18),
                      label: Text(l10n.translate('showAll')),
                    ),
                    TextButton.icon(
                      onPressed: _hideAll,
                      icon: const Icon(Icons.visibility_off, size: 18),
                      label: Text(l10n.translate('hideAll')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final match = matches[index];
                final isRevealed = _revealedGiverIds.contains(match.giverId);
                final participant = state.participants.firstWhere(
                  (p) => p.id == match.giverId,
                  orElse: () => const Participant(id: '', name: ''),
                );

                final isLocked =
                    participant.fixedReceiverId == match.receiverId;

                return _MatchTile(
                  match: match,
                  isRevealed: isRevealed,
                  isLocked: isLocked,
                  onToggle: () => _toggleReveal(match.giverId),
                  onToggleLock: () {
                    ref
                        .read(secretSantaProvider.notifier)
                        .toggleLockMatch(match.giverId, match.receiverId);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final MatchPair match;
  final bool isRevealed;
  final bool isLocked;
  final VoidCallback onToggle;
  final VoidCallback onToggleLock;

  const _MatchTile({
    required this.match,
    required this.isRevealed,
    required this.isLocked,
    required this.onToggle,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              match.giverName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isRevealed
                  ? Container(
                      key: ValueKey('revealed_${match.receiverId}'),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            match.receiverName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isLocked
                                  ? Colors.amber.shade900
                                  : Colors.deepPurple,
                            ),
                          ),
                          if (isLocked)
                            Icon(Icons.lock,
                                size: 16, color: Colors.amber.shade900),
                        ],
                      ),
                    )
                  : Container(
                      key: const ValueKey('hidden'),
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
                      child: Text(
                        l10n.translate('clickToReveal'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
            ),
          ),
          IconButton(
            icon: Icon(
              isRevealed ? Icons.visibility_off : Icons.visibility,
              color: Colors.deepPurple,
            ),
            onPressed: onToggle,
            tooltip: isRevealed
                ? l10n.translate('hide')
                : l10n.translate('reveal'),
          ),
          IconButton(
            icon: Icon(
              isLocked ? Icons.lock : Icons.lock_open_outlined,
              color: isLocked ? Colors.amber.shade800 : Colors.grey,
            ),
            onPressed: onToggleLock,
            tooltip: isLocked
                ? l10n.translate('unlockAssignment')
                : l10n.translate('lockAssignment'),
          ),
        ],
      ),
    );
  }
}
