import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'providers/secret_santa_provider.dart';
import 'providers/settings_provider.dart';
import 'widgets/history_widget.dart';
import 'widgets/import_export_widget.dart';
import 'widgets/match_results_widget.dart';
import 'widgets/participant_list_widget.dart';

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
        appBarTheme: const AppBarTheme(
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard),
            const SizedBox(width: 8),
            Text(
              l10n.translate('appTitle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Language toggle button
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 20),
                const SizedBox(width: 4),
                Text(
                  currentLocale.languageCode.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            tooltip: l10n.translate('languageTooltip'),
            onPressed: () {
              ref.read(localeProvider.notifier).toggleLanguage();
            },
          ),
          // Theme toggle button
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                  child: Column(
                    children: [
                      // Real-time or Action Error Display
                      if (activeErrorKey != null) ...[
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 20),
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
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: isDarkMode
                                      ? Colors.red.shade200
                                      : Colors.red.shade800),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.translate(activeErrorKey),
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.red.shade200
                                        : Colors.red.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Reroll / Generate Action Bar
                      Container(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.translate('readyForSecretSanta'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    l10n.translate('generateMatchesSubtitle'),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: (state.participants.length < 2 ||
                                      hasValidationError)
                                  ? null
                                  : () {
                                      ref
                                          .read(secretSantaProvider.notifier)
                                          .generateMatches(l10n);
                                    },
                              icon: const Icon(Icons.autorenew),
                              label: Text(l10n.translate('drawSecretSanta')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Import / Export Section Card
                      const ImportExportWidget(),
                      const SizedBox(height: 24),

                      // Responsive Grid: Desktop (2 columns), Mobile (1 column)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 800) {
                            return const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      ParticipantListWidget(),
                                      SizedBox(height: 24),
                                      HistoryWidget(),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: MatchResultsWidget(),
                                ),
                              ],
                            );
                          } else {
                            return const Column(
                              children: [
                                ParticipantListWidget(),
                                SizedBox(height: 24),
                                MatchResultsWidget(),
                                SizedBox(height: 24),
                                HistoryWidget(),
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
