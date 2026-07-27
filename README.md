# Secret Santa Generator — Wichtel-O-Mat

A modern, responsive Flutter web application that generates Secret Santa pairings while respecting exclusion rules, fixed assignments, and historical data. Built with Flutter, Riverpod, and Material 3 design.

[![Flutter](https://img.shields.io/badge/Flutter-3.12.2-blue.svg)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-3.3.2-orange.svg)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🌍 Languages

| Language | Link |
|----------|------|
| 🇩🇪 Deutsch | [README_DE.md](README_DE.md) |
| 🇬🇧 English | [README_EN.md](README_EN.md) |

---

## 🚀 Quick Start (German)

### Voraussetzungen
- [Flutter SDK](https://flutter.dev) (3.12.2 oder höher)
- [Dart SDK](https://dart.dev)
- Einen modernen Webbrowser (Chrome, Firefox, Safari, Edge)

### Installation
```bash
# Abhängigkeiten installieren
flutter pub get

# Projekt analysieren (Fehler prüfen)
flutter analyze

# Entwicklungsserver starten
flutter run -d chrome

# Für Produktionsbuild
flutter build web
```

---

## 🚀 Quick Start (English)

### Prerequisites
- [Flutter SDK](https://flutter.dev) (3.12.2 or higher)
- [Dart SDK](https://dart.dev)
- A modern web browser (Chrome, Firefox, Safari, Edge)

### Installation
```bash
# Install dependencies
flutter pub get

# Analyze project (check for errors)
flutter analyze

# Start development server
flutter run -d chrome

# For production build
flutter build web
```

---

## 📁 Project Structure

```
secret-santa/
├── lib/
│   ├── l10n/
│   │   └── app_localizations.dart          # Bilingual localization (DE/EN)
│   ├── models/
│   │   ├── participant.dart                # Participant data model
│   │   └── secret_santa_history.dart       # Match pair & history models
│   ├── providers/
│   │   ├── secret_santa_provider.dart      # Main state management (Riverpod)
│   │   └── settings_provider.dart          # Theme & locale providers
│   ├── services/
│   │   ├── import_export_service.dart      # JSON import/export
│   │   ├── local_storage_service.dart      # SharedPreferences persistence
│   │   └── secret_santa_matcher.dart       # Matching algorithm & validation
│   ├── widgets/
│   │   ├── history_widget.dart             # Draw history display
│   │   ├── import_export_widget.dart       # Import/export actions
│   │   ├── match_results_widget.dart       # Match results with reveal/lock
│   │   └── participant_list_widget.dart    # Participant management
│   └── main.dart                           # App entry point
├── web/                                    # Web assets & index.html
├── pubspec.yaml                           # Dependencies & metadata
└── analysis_options.yaml                  # Linter configuration
```

---

## 🔧 Core Features

### 1. **Participant Management**
- Add, edit, and delete participants (double-tap to edit)
- Real-time validation with instant error feedback
- Responsive UI adapts to screen size

### 2. **Exclusion Rules**
- **Cannot give to:** Prevent specific recipients
- **Cannot receive from:** Prevent specific givers
- Toggle exclusions with visual chips

### 3. **Fixed Assignments (Locks)**
- Lock a participant to a specific receiver
- Visual lock indicator with amber badge
- Locks persist across sessions

### 4. **Matching Algorithm**
- Respects all exclusion rules
- Processes fixed assignments first
- Randomized fallback for remaining pairs
- Maximum 1000 attempts with clear error messages

### 5. **Match Results**
- Reveal/hide individual assignments
- Show/hide all at once
- Lock/unlock individual pairs
- Real-time status updates

### 6. **Draw History**
- Up to 100 saved draw sessions
- Expandable match previews
- Load previous draws instantly
- Clear history option

### 7. **Import / Export**
- **Export Full Config:** Saves participants, rules, and assignments
- **Export Matches Only:** Share just the pairing results
- **Import JSON:** Restore configurations and data

### 8. **Bilingual Support**
- German (DE) and English (EN)
- Language toggle in the app bar
- All UI elements fully translated

### 9. **Dark / Light Mode**
- System theme detection
- Manual toggle in app bar
- Preferences persist across sessions

---

## 🛠️ Technical Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Riverpod** | Reactive state management |
| **Material 3** | Modern, adaptive design system |
| **Dart** | Type-safe, high-performance language |
| **SharedPreferences** | Local data persistence |
| **Intl** | Bilingual localization support |

---

## 📖 How It Works

### Matching Algorithm (Step-by-Step)

1. **Validate Participants** — Ensures at least 2 participants and no impossible rules
2. **Process Fixed Assignments** — Locks are honored first (highest priority)
3. **Apply Exclusion Rules** — Respects "cannot give to" and "cannot receive from"
4. **Randomized Assignment** — Assigns remaining pairs randomly
5. **Validation Loop** — Up to 1000 attempts with clear error reporting

### Data Persistence
- **Participants & Rules:** Stored in `SharedPreferences`
- **History Entries:** Limited to 100 most recent draws
- **Auto-save:** Changes persist immediately

---

## 🎨 UI/UX Design

- **Material 3** — Modern, adaptive design
- **Responsive Layout** — Desktop (2-column grid) → Mobile (single column)
- **Color Scheme** — Deep purple primary, amber accents
- **Accessibility** — High contrast, semantic labels, keyboard navigation

---

## 🧪 Development & Testing

### Run Tests
```bash
flutter test
```

### Run Linter
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

---

## 📝 Code Quality Guidelines (per AGENTS.md)

- ✅ **Dart Doc Comments** — Every public API documented with `///`
- ✅ **No Deprecated APIs** — Only current, recommended Flutter/Dart APIs
- ✅ **Explicit Error Handling** — No swallowed exceptions
- ✅ **Strong Typing** — Full use of Dart's sound type system
- ✅ **Clean Code** — Small, single-purpose functions and widgets
- ✅ **No Dead Code** — Removed all commented-out and debug code

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

MIT License — see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) — The amazing UI toolkit
- [Riverpod](https://riverpod.dev) — Beautiful state management
- [Material 3](https://m3.material.io) — The design system

---

**Built with ❤️ using Flutter & Dart**

---

## 🌍 Deutsch (German Version)

### Kurzanleitung

### Voraussetzungen
- [Flutter SDK](https://flutter.dev) (3.12.2 oder höher)
- [Dart SDK](https://dart.dev)
- Einen modernen Webbrowser (Chrome, Firefox, Safari, Edge)

### Installation
```bash
# Abhängigkeiten installieren
flutter pub get

# Projekt analysieren (Fehler prüfen)
flutter analyze

# Entwicklungsserver starten
flutter run -d chrome

# Für Produktionsbuild
flutter build web
```

### Projektstruktur

```
secret-santa/
├── lib/
│   ├── l10n/
│   │   └── app_localizations.dart          # Bilingual localization (DE/EN)
│   ├── models/
│   │   ├── participant.dart                # Teilnehmerdatenmodell
│   │   └── secret_santa_history.dart       # Match-Paare & Historie
│   ├── providers/
│   │   ├── secret_santa_provider.dart      # Hauptstate-Management (Riverpod)
│   │   └── settings_provider.dart          # Theme & Locale-Provider
│   ├── services/
│   │   ├── import_export_service.dart      # JSON-Import/Export
│   │   ├── local_storage_service.dart      # SharedPreferences-Persistenz
│   │   └── secret_santa_matcher.dart       # Matching-Algorithmus & Validierung
│   ├── widgets/
│   │   ├── history_widget.dart             # Auslosungshistorie
│   │   ├── import_export_widget.dart       # Import/Export-Aktionen
│   │   ├── match_results_widget.dart       # Match-Ergebnisse mit Reveal/Lock
│   │   └── participant_list_widget.dart    # Teilnehmerverwaltung
│   └── main.dart                           # App-Einstiegspunkt
├── web/                                    # Web-Assets & index.html
├── pubspec.yaml                           # Abhängigkeiten & Metadaten
└── analysis_options.yaml                  # Linter-Konfiguration
```

### Kernfunktionen

#### 1. **Teilnehmerverwaltung**
- Hinzufügen, Bearbeiten und Löschen von Teilnehmern (Doppelklick zum Bearbeiten)
- Echtzeit-Validierung mit sofortigem Fehlerfeedback
- Responsive UI, die sich an Bildschirmgröße anpasst

#### 2. **Ausschlussregeln**
- **Nicht beschenken:** Verhindert bestimmte Empfänger
- **Nicht beschenkt werden:** Verhindert bestimmte Geschenke
- Ausschlüsse mit visuellen Chips umschalten

#### 3. **Feste Zuweisungen (Sperrungen)**
- Teilnehmer auf bestimmten Empfänger sperren
- Visuelle Sperre mit Amber-Abzeichen
- Sperrungen über Sessions hinweg bestehen

#### 4. **Matching-Algorithmus**
- Respektiert alle Ausschlussregeln
- Verarbeitet feste Zuweisungen zuerst (höchste Priorität)
- Zufällige Zuweisung für verbleibende Paare
- Maximale 1000 Versuche mit klaren Fehlermeldungen

#### 5. **Match-Ergebnisse**
- Einzelne Zuweisungen aufdecken/verbergen
- Alle auf einmal anzeigen/verbergen
- Einzelne Paare sperren/ent Sperren
- Echtzeit-Status-Updates

#### 6. **Auslosungshistorie**
- Bis zu 100 gespeicherte Auslosungen
- Erweitbare Match-Vorschauen
- Sofortiges Laden vorheriger Auslosungen
- Historie leeren

#### 7. **Import / Export**
- **Alles exportieren:** Speichert Teilnehmer, Regeln und Zuweisungen
- **Nur Ergebnisse exportieren:** Teilt nur die Match-Ergebnisse
- **JSON importieren:** Stellt Konfigurationen und Daten wieder her

#### 8. **Bilingualer Support**
- Deutsch (DE) und Englisch (EN)
- Sprachumschalter in der App-Leiste
- Alle UI-Elemente vollständig übersetzt

#### 9. **Dark / Light Mode**
- System-Theme-Erkennung
- Manuelles Umschalten in der App-Leiste
- Präferenzen über Sessions hinweg bestehen

---

### Technische Stack

| Technologie | Zweck |
|-------------|-------|
| **Flutter** | Cross-Platform UI-Framework |
| **Riverpod** | Reaktives State-Management |
| **Material 3** | Modernes, adaptives Design-System |
| **Dart** | Typsicher, hochperformante Sprache |
| **SharedPreferences** | Lokale Datenpersistenz |
| **Intl** | Bilingualer Lokalisierungs-Support |

---

### Wie es funktioniert

#### Matching-Algorithmus (Schritt-für-Schritt)

1. **Teilnehmer validieren** — Stellt sicher, dass mindestens 2 Teilnehmer und keine unmöglichen Regeln vorhanden sind
2. **Feste Zuweisungen verarbeiten** — Sperren werden zuerst berücksichtigt (höchste Priorität)
3. **Ausschlussregeln anwenden** — Respektiert "nicht beschenken" und "nicht beschenkt werden"
4. **Zufällige Zuweisung** — Zuweist verbleibende Paare zufällig
5. **Validierungsschleife** — Bis zu 1000 Versuche mit klaren Fehlerberichten

#### Datenpersistenz
- **Teilnehmer & Regeln:** Gespeichert in `SharedPreferences`
- **Historie-Einträge:** Begrenzt auf 100 jüngste Auslosungen
- **Auto-Save:** Änderungen persistieren sofort

---

### UI/UX-Design

- **Material 3** — Modernes, adaptives Design
- **Responsive Layout** — Desktop (2-Spalten-Raster) → Mobil (einspaltig)
- **Farbschema** — Tiefes Lila Primärfarbe, Amber-Akzente
- **Barrierefreiheit** — Hoher Kontrast, semantische Labels, Tastatur-Navigation

---

### Entwicklung & Testing

#### Tests ausführen
```bash
flutter test
```

#### Linter ausführen
```bash
flutter analyze
```

#### Code formatieren
```bash
flutter format .
```

---

### Code-Qualitätsrichtlinien (gemäß AGENTS.md)

- ✅ **Dart Doc Kommentare** — Jede öffentliche API mit `///` dokumentiert
- ✅ **Keine veralteten APIs** — Nur aktuelle, empfohlene Flutter/Dart APIs
- ✅ **Explizite Fehlerbehandlung** — Keine verschluckten Ausnahmen
- ✅ **Starke Typisierung** — Vollständige Nutzung des Dart-Sound-Typesystems
- ✅ **Clean Code** — Kleine, einzweckige Funktionen und Widgets
- ✅ **Kein toter Code** — Entfernt alle kommentierten und Debug-Codes

---

### Mitwirken

1. Repository forken
2. Feature-Branch erstellen (`git checkout -b feature/amazing-feature`)
3. Änderungen commiten (`git commit -m 'Add amazing feature'`)
4. Branch pushen (`git push origin feature/amazing-feature`)
5. Pull Request öffnen

---

### Lizenz

MIT-Lizenz — Details in der [LICENSE](LICENSE)-Datei.

---

**Mit ❤️ gebaut mit Flutter & Dart**

---

## 📄 License

MIT License — see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) — The amazing UI toolkit
- [Riverpod](https://riverpod.dev) — Beautiful state management
- [Material 3](https://m3.material.io) — The design system

---

**Built with ❤️ using Flutter & Dart**
