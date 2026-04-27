# GEMINI.md - Risto Widgets Development & Maintenance Guide

Questa guida stabilisce gli standard rigorosi per lo sviluppo, il testing e la documentazione della libreria `risto_widgets`. Ogni interazione dell'AI deve aderire a questi principi per garantire coerenza, modularità e qualità del codice.

## 1. Panoramica e Obiettivi
`risto_widgets` è la libreria core di componenti UI per l'ecosistema RistoCloud.
- **Obiettivo:** Fornire widget pronti all'uso, altamente personalizzabili e con un linguaggio di design unificato.
- **Principi Guida:** Semplicità di integrazione, minimizzazione delle dipendenze e performance ottimizzate.
- **Naming Convention:** Ogni nuova implementazione custom DEVE avere il prefisso `Risto` (es. `RistoTextField`, `RistoNoticeCard`). I nomi legacy sono mantenuti solo per retrocompatibilità.

## 2. Architettura e Struttura Directory
La libreria è organizzata in sottocategorie semantiche per facilitare la navigabilità:
- `lib/widgets/buttons/`: Pulsanti e azioni.
- `lib/widgets/expandable/`: Componenti con stati espandibili.
- `lib/widgets/feedback/`: Alert, toast e notifiche semantiche.
- `lib/widgets/indicators/`: Shimmer, loading e progress indicators.
- `lib/widgets/infinite_snap_list/`: Liste e caroselli con snapping e BLoC.
- `lib/widgets/input/`: Campi di testo e selettori numerici.
- `lib/widgets/layouts/`: Widget di struttura e styling core.
- `lib/widgets/navigation/`: Barre di navigazione e switcher.
- `lib/widgets/popup/`: Dialoghi (glassmorphism) e bottom sheet.

**Barrel File:** Ogni nuovo widget deve essere esportato in `lib/risto_widgets.dart`.

## 3. Regole di Riutilizzo Core (MOLTO IMPORTANTE)
È **vietato** reinventare la ruota usando primitive Flutter se esiste un widget core corrispondente.
- **RistoDecorator:** Motore di styling primario per sfondi, gradienti, bordi e ombre.
- **CustomActionButton:** Base per ogni nuova tipologia di pulsante.
- **RistoNoticeCard:** Base per ogni componente di feedback visivo.
- **RistoShimmer:** Standard per ogni stato di caricamento skeleton.
- **Evoluzione Retrocompatibile:** Se un widget core necessita di nuove feature, aggiungere parametri opzionali/nullable. È VIETATO creare cloni (es. `WidgetV2`) o alterare i comportamenti di default storici.

## 4. Design System, Layout & Performance
- **Theming Semantico:** I widget calcolano i default tramite helper (es. `_defaultsForKind`) interrogando `Theme.of(context).colorScheme`. Ogni widget deve esporre un parametro `accentColor` opzionale per l'override.
- **Layout Resiliente:** Nelle Row con elementi dinamici (es. `RistoTextField` con errori), i bottoni laterali devono essere wrappati in `SizedBox` ad altezza fissa e allineati con `CrossAxisAlignment.start` per evitare layout shift.
- **Eager Interaction:** I trigger di selezione (`onItemSelected`) devono essere immediati ("eager") all'invocazione programmatica, senza attendere la fine delle animazioni fisiche.
- **Ottimizzazione:** Usare `RepaintBoundary` per isolare il repaint di animazioni o sottowidget complessi.
- **State Management:** `StatefulWidget` + Controller per UI pura; `flutter_bloc` solo per componenti con logiche asincrone/rete (es. `InfiniteSnapList`).

## 5. Workflow Obbligatorio per Nuovi Widget (La Trinità)
Una Pull Request è valida solo se include tutti i 5 step:
1. **Sviluppo:** Implementazione in `lib/widgets/{categoria}/` con factory constructors semantici (`.success`, `.error`, `.search`).
2. **Export:** Aggiunta dell'export nel barrel file `lib/risto_widgets.dart`.
3. **Testing:** Creazione di `test/widget_name_test.dart` verificando rendering, interazioni eager e override cromatici.
4. **Example App:** Creazione della `_page.dart` in `example/` e integrazione nella lista `_routes` in `main.dart`.
5. **Documentazione Wiki:** Creazione del file `.md` nella Wiki (usando `"""` per i codeblock) e aggiornamento di `Home.md` e `_Sidebar.md`.

## 6. Versioning & Git
- **Semantic Versioning:** Seguire rigorosamente `MAJOR.MINOR.PATCH`.
- **Changelog:** Aggiornare `CHANGELOG.md` prima di ogni release (`Added`, `Fixed`, `Changed`).
- **Git Branching:** `feature/` (nuovi widget), `fix/` (bugfix), `refactoring/` (pulizia), `ehance/` (miglioramenti).
- **Commit:** Titolo riassuntivo e corpo descrittivo che spiega "cosa" e "come".

## 7. Comandi Essenziali
- **Test:** `flutter test` | **Format:** `dart format .` | **Analyze:** `flutter analyze`
- **Publish:** `dart pub publish --dry-run`

## 8. Anti-pattern e Divieti
- **NO** colori hardcoded senza possibilità di override; il fallback deve essere il tema.
- **NO** breaking changes senza bump della MAJOR version.
- **NO** nuove dipendenze esterne pesanti; preferire soluzioni vanilla ottimizzate.
- **NO** dimenticarsi di aggiornare la Wiki o l'app di esempio: un widget non documentato o non testato non esiste.
