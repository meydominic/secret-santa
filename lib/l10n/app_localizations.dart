import 'package:flutter/material.dart';

/// Class containing localized strings for German ('de') and English ('en').
class AppLocalizations {
  /// The current locale.
  final Locale locale;

  /// Creates a new [AppLocalizations] for the given [locale].
  AppLocalizations(this.locale);

  /// Localized values map.
  static const Map<String, Map<String, String>> _localizedValues = {
    'de': {
      'appTitle': 'Wichtel-O-Mat',
      'readyForSecretSanta': 'Bereit fürs Wichteln?',
      'generateMatchesSubtitle':
          'Generiere neue Zufallszuordnungen unter Beachtung aller Regeln & festen Zuweisungen',
      'drawSecretSanta': 'Wichteln auslosen',
      'participants': 'Teilnehmer',
      'enterNameHint': 'Neuen Namen eingeben...',
      'add': 'Hinzufügen',
      'noParticipantsYet': 'Noch keine Teilnehmer hinzugefügt.',
      'save': 'Speichern',
      'edit': 'Bearbeiten',
      'delete': 'Löschen',
      'cannotGiftTo': 'Darf nicht beschenken:',
      'cannotBeGiftedBy': 'Darf nicht beschenkt werden von:',
      'fixedAssignment': 'Feste Zuweisung (Beschenkt):',
      'noFixedAssignment': '-- Keine feste Zuweisung --',
      'lockAssignment': 'Als feste Zuweisung sperren',
      'unlockAssignment': 'Feste Zuweisung aufheben',
      'results': 'Ergebnis',
      'pairs': 'Paare',
      'showAll': 'Alle zeigen',
      'hideAll': 'Alle verbergen',
      'noDrawYet': 'Noch kein Wichteln gestartet.',
      'noDrawSubtext':
          'Füge mindestens 2 Personen hinzu und klicke auf "Wichteln auslosen".',
      'clickToReveal': '•••••••• (Klicken zum Aufdecken)',
      'reveal': 'Aufdecken',
      'hide': 'Verbergen',
      'history': 'Historie',
      'clearHistory': 'Verlauf leeren',
      'noHistoryYet': 'Noch keine Auslosungen gespeichert.',
      'load': 'Laden',
      'drawLoaded': 'wurde geladen.',
      'drawTitlePrefix': 'Auslosung #',
      'minTwoParticipantsError':
          'Mindestens 2 Teilnehmer werden für ein Wichteln benötigt.',
      'noValidMatchingError':
          'Keine gültige Zuordnung möglich. Bitte überprüfe die Ausschlusskriterien und festen Zuweisungen.',
      'unexpectedError': 'Ein unerwarteter Fehler ist aufgetreten:',
      'themeTooltip': 'Design anpassen (Dark/Light Mode)',
      'languageTooltip': 'Sprache wechseln',
      'exclusions': 'Ausschlüsse',
      'noneSelected': 'Keine ausgewählt',
      'lockSuccess': 'Zuweisung wurde in den Teilnehmerregeln gesperrt.',
      'exportImport': 'Export / Import',
      'exportFull': 'Alles exportieren (inkl. Regeln & Zuweisungen)',
      'exportMatchesOnly': 'Nur Ergebnisse (Paare) exportieren',
      'importFile': 'Datei importieren',
      'importSuccess': 'Daten erfolgreich importiert!',
      'importError': 'Fehler beim Importieren der Datei.',
    },
    'en': {
      'appTitle': 'Secret Santa Generator',
      'readyForSecretSanta': 'Ready for Secret Santa?',
      'generateMatchesSubtitle':
          'Generate new random assignments adhering to all exclusion rules & fixed locks',
      'drawSecretSanta': 'Draw Secret Santa',
      'participants': 'Participants',
      'enterNameHint': 'Enter new name...',
      'add': 'Add',
      'noParticipantsYet': 'No participants added yet.',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'cannotGiftTo': 'Cannot give gift to:',
      'cannotBeGiftedBy': 'Cannot receive gift from:',
      'fixedAssignment': 'Fixed Assignment (Gifts to):',
      'noFixedAssignment': '-- No fixed assignment --',
      'lockAssignment': 'Lock as fixed assignment',
      'unlockAssignment': 'Unlock fixed assignment',
      'results': 'Results',
      'pairs': 'pairs',
      'showAll': 'Show all',
      'hideAll': 'Hide all',
      'noDrawYet': 'No draw started yet.',
      'noDrawSubtext':
          'Add at least 2 people and click "Draw Secret Santa".',
      'clickToReveal': '•••••••• (Click to reveal)',
      'reveal': 'Reveal',
      'hide': 'Hide',
      'history': 'History',
      'clearHistory': 'Clear history',
      'noHistoryYet': 'No saved draws yet.',
      'load': 'Load',
      'drawLoaded': 'was loaded.',
      'drawTitlePrefix': 'Draw #',
      'minTwoParticipantsError':
          'At least 2 participants are required for Secret Santa.',
      'noValidMatchingError':
          'No valid assignment possible. Please check exclusion rules and fixed locks.',
      'unexpectedError': 'An unexpected error occurred:',
      'themeTooltip': 'Toggle Theme (Dark/Light)',
      'languageTooltip': 'Switch Language',
      'exclusions': 'Exclusions',
      'noneSelected': 'None selected',
      'lockSuccess': 'Assignment locked in participant rules.',
      'exportImport': 'Export / Import',
      'exportFull': 'Export all (incl. rules & assignments)',
      'exportMatchesOnly': 'Export results only (pairs)',
      'importFile': 'Import file',
      'importSuccess': 'Data imported successfully!',
      'importError': 'Error importing file.',
    },
  };

  /// Returns the localized string for [key].
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  /// Gets the current [AppLocalizations] instance from context.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('de'));
  }
}

/// LocalizationsDelegate for [AppLocalizations].
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// Creates a new [AppLocalizationsDelegate].
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['de', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
