import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'providers/secret_santa_provider.dart';
import 'providers/settings_provider.dart';
import 'widgets/common.dart';
import 'widgets/history_widget.dart';
import 'widgets/import_export_widget.dart';
import 'widgets/match_results_widget.dart';
import 'widgets/participant_list_widget.dart';
import 'widgets/wrap_with_spacing.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SecretSantaApp(),
    ),
  );
}

/// Main Application Root Widget for Secret Santa.
class SecretSantaApp extends ConsumerWidget {
  /// Creates a new [SecretSantaApp].
  const SecretSantaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Secret Santa Generator',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
        ),
      ),
      locale: locale,
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SecretSantaHomePage(),
    );
  }
}

/// Home Page supporting responsive layout for web (mobile & desktop).
class SecretSantaHomePage extends ConsumerWidget {
  /// Creates a new [SecretSantaHomePage].
  const SecretSantaHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(secretSantaProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    final isDarkMode = currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final activeErrorKey = state.errorKey ?? state.validationErrorKey;
    final hasValidationError = state.validationErrorKey != null;

    return Scaffold(
      appBar: AppBar(
        title: RowWithSpacing(
          spacing: 8,
          children: [
            const Icon(Icons.card_giftcard),
            TextWithStyling(
              text: l10n.translate('appTitle'),
              bold: true,
            ),
          ],
        ),
        actions: [
          // Language toggle button
          IconButtonWithTooltip(
            icon: RowWithSpacing(
              spacing: 4,
              children: [
                const Icon(Icons.language, size: 20),
                TextWithStyling(
                  text: currentLocale.languageCode.toUpperCase(),
                  fontSize: 12,
                  bold: true,
                ),
              ],
            ),
            tooltip: l10n.translate('languageTooltip'),
            onPressed: () {
              ref.read(localeProvider.notifier).toggleLanguage();
            },
          ),
          // Theme toggle button
          IconButtonWithTooltip(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: l10n.translate('themeTooltip'),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: ColumnWithSpacing(
                    spacing: 24,
                    children: [
                      // Real-time or Action Error Display
                      if (activeErrorKey != null) ...[
                        ContainerWithDecoration(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.red.shade900.withValues(alpha: 0.4)
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.red.shade700
                                  : Colors.red.shade400,
                            ),
                          ),
                          child: RowWithSpacing(
                            spacing: 12,
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: isDarkMode
                                      ? Colors.red.shade200
                                      : Colors.red.shade800),
                              Expanded(
                                child: TextWithStyling(
                                  text: l10n.translate(activeErrorKey),
                                  bold: true,
                                  color: isDarkMode
                                      ? Colors.red.shade200
                                      : Colors.red.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Reroll / Generate Action Bar
                      ContainerWithDecoration(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade700,
                              Colors.deepPurple.shade500,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: RowWithSpacing(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: ColumnWithSpacing(
                                spacing: 4,
                                children: [
                                  TextWithStyling(
                                    text: l10n.translate('readyForSecretSanta'),
                                    bold: true,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  TextWithStyling(
                                    text: l10n.translate('generateMatchesSubtitle'),
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButtonWithMaterial3(
                              onPressed: (state.participants.length < 2 ||
                                      hasValidationError)
                                  ? null
                                  : () {
                                      ref
                                          .read(secretSantaProvider.notifier)
                                          .generateMatches(l10n);
                                    },
                              icon: const Icon(Icons.autorenew),
                              label: l10n.translate('drawSecretSanta'),
                              backgroundColor: Colors.amber.shade700,
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      // Import / Export Section Card
                      const ImportExportWidget(),

                      // Responsive Grid: Desktop (2 columns), Mobile (1 column)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 800) {
                            return RowWithSpacing(
                              spacing: 24,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ColumnWithSpacing(
                                    spacing: 24,
                                    children: [
                                      const ParticipantListWidget(),
                                      const HistoryWidget(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: const MatchResultsWidget(),
                                ),
                              ],
                            );
                          } else {
                            return ColumnWithSpacing(
                              spacing: 24,
                              children: [
                                const ParticipantListWidget(),
                                const MatchResultsWidget(),
                                const HistoryWidget(),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
