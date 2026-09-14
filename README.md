# Binär-Rechner für die Apple Watch

Eine eigenständige watchOS-App (SwiftUI, kein iPhone-Begleiter nötig), die Zahlen
zwischen **Dezimal, Binär, Hexadezimal und Oktal** umrechnet – aufgebaut wie der
Zahlenkonverter von [matheretter.de](https://www.matheretter.de/rechner/zahlenkonverter):
Zahl in einem System eingeben, alle anderen werden sofort berechnet und der
Rechenweg dazu angezeigt.

## Funktionen

- **Vier Schreibweisen gleichzeitig** – Dezimal, Binär, Hexadezimal, Oktal,
  farblich unterschieden wie auf der Vorlage.
- **Eingabe in jedem System**: Feld antippen → passendes Ziffernfeld
  (Binär `0/1`, Oktal `0–7`, Dezimal `0–9`, Hexadezimal `0–F`).
- **± 1 über die Digital Crown** bzw. die Tasten `−` / `+` – das Gegenstück zu den
  Pfeiltasten der Webseite.
- **Rechenweg** wie in der Vorlage:
  - Übersicht: `F₁₆ = 15₁₀ = 17₈ = 1111₂`
  - Hexadezimal: `F₁₆ = F·16⁰ = 15₁₀·16⁰ = 15₁₀`
  - Oktal: `17₈ = 1·8¹ + 7·8⁰ = 15₁₀`
  - Binär: `1111₂ = 1·2³ + 1·2² + 1·2¹ + 1·2⁰ = 15₁₀`
- **Binärzahlen in Vierergruppen** (`1111 1111`), damit sie auf dem kleinen
  Display lesbar bleiben.
- **Haptisches Feedback** bei jedem Tastendruck, eigenes Muster beim Erreichen
  einer Grenze.
- **Letzter Wert wird gesichert** und beim nächsten Start wiederhergestellt.
- **VoiceOver-Beschriftungen** für alle Bedienelemente.

Gerechnet wird mit `UInt64`, also mit ganzen Zahlen von 0 bis
18.446.744.073.709.551.615 (64 Bit). Eingaben, die den Bereich sprengen würden,
werden abgelehnt statt still überzulaufen.

## Projekt öffnen und starten

```bash
open BinaerRechner.xcodeproj
```

1. Schema **BinaerRechner** wählen.
2. Ziel: ein Apple-Watch-Simulator (z. B. „Apple Watch Series 10 (46mm)“) oder
   eine echte Uhr.
3. ⌘R.

Für den Lauf auf echter Hardware in Xcode unter *Signing & Capabilities* das
eigene Team eintragen und ggf. die Bundle-ID
`de.beispiel.BinaerRechner` auf eine eigene ändern.

### Anforderungen

| | |
|---|---|
| Xcode | 16 oder neuer (Projektformat `objectVersion = 77`) |
| Deployment-Target | watchOS 11.0 – läuft auch auf watchOS 26/27 |
| Sprachversion | Swift 5 (`SWIFT_VERSION = 5.0`) |
| Gerätefamilie | nur Apple Watch (`TARGETED_DEVICE_FAMILY = 4`) |

Das Projekt nutzt *file system synchronized groups*: neue Dateien im Ordner
`BinaerRechner/` landen automatisch im Target, die Projektdatei muss dafür nicht
angefasst werden.

## Aufbau

```
BinaerRechner/
├── BinaerRechnerApp.swift        App-Einstieg
├── Model/
│   ├── NumberBase.swift          Zahlensysteme: Basis, Farbe, Ziffern, Tastenfeld
│   ├── NumberParser.swift        Einlesen/Ausgeben mit Überlaufschutz
│   ├── ConversionExplanation.swift  Übersicht + Stellenwert-Rechenweg
│   ├── ConverterModel.swift      gemeinsamer Wert (@Observable) + Eingabelogik
│   └── UnicodeNotation.swift     hoch-/tiefgestellte Ziffern (2⁴, 15₁₀)
├── Support/Haptics.swift
└── Views/
    ├── ConverterView.swift       Hauptbildschirm
    ├── ValueCard.swift           ein Zahlenfeld
    ├── KeypadEditorView.swift    Ziffernfeld + Stepper + Sofortvorschau
    └── ExplanationSection.swift  ein Abschnitt des Rechenwegs
```

Der Kern ist bewusst klein gehalten: Es gibt **einen** Wert, und die vier
Zahlensysteme sind nur unterschiedliche Schreibweisen davon. Eine Ziffer
anzuhängen ist deshalb schlicht `Wert · Basis + Ziffer`, eine Stelle zu löschen
`Wert / Basis`. Die Umrechnungslogik steckt komplett in `Model/` und hängt nicht
an SwiftUI – sie lässt sich damit unabhängig von der Oberfläche prüfen.

## Bedienung

| Aktion | Wirkung |
|---|---|
| Feld antippen | Ziffernfeld für dieses Zahlensystem öffnen |
| Ziffer tippen | Ziffer hinten anhängen |
| ⌫ | letzte Stelle löschen |
| C | auf 0 zurücksetzen |
| Digital Crown / `−` `+` | Wert um 1 verändern |
| ✓ oder Wischen nach rechts | zurück zur Übersicht |
