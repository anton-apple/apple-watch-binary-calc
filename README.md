# Binary Calculator for Apple Watch

A standalone watchOS app (SwiftUI, no iPhone companion required) that converts
numbers between **decimal, binary, hexadecimal and octal** — built to work like
the number converter on
[matheretter.de](https://www.matheretter.de/rechner/zahlenkonverter): type a
number in one system, the others are computed instantly and the worked example
is shown underneath.

> The app's interface is in German, matching the reference page. Everything
> developer-facing — this README, code comments, identifiers — is in English.

## Features

- **Four notations at once** — decimal, binary, hexadecimal, octal, color-coded
  like the reference page.
- **Input in any system**: tap a field to get the matching keypad
  (binary `0/1`, octal `0–7`, decimal `0–9`, hexadecimal `0–F`).
- **± 1 via the Digital Crown** or the `−` / `+` buttons — the counterpart to
  the arrow keys on the web page.
- **Worked example**, same as the reference:
  - Overview: `F₁₆ = 15₁₀ = 17₈ = 1111₂`
  - Hexadecimal: `F₁₆ = F·16⁰ = 15₁₀·16⁰ = 15₁₀`
  - Octal: `17₈ = 1·8¹ + 7·8⁰ = 15₁₀`
  - Binary: `1111₂ = 1·2³ + 1·2² + 1·2¹ + 1·2⁰ = 15₁₀`
- **Binary grouped into nibbles** (`1111 1111`) so it stays readable on a small
  display.
- **Haptic feedback** on every key press, with a distinct pattern when a limit
  is reached.
- **The last value is persisted** and restored on the next launch.
- **VoiceOver labels** on every control.

Everything is computed in `UInt64`, so whole numbers from 0 up to
18,446,744,073,709,551,615 (64 bit). Input that would leave that range is
rejected instead of silently overflowing.

## Opening and running the project

```bash
open BinaerRechner.xcodeproj
```

1. Pick the **BinaerRechner** scheme.
2. Choose an Apple Watch simulator (e.g. "Apple Watch Series 10 (46mm)") or a
   real watch as the destination.
3. ⌘R.

To run on real hardware, set your team under *Signing & Capabilities* in Xcode
and change the bundle identifier `de.beispiel.BinaerRechner` to one of your own.

### Requirements

| | |
|---|---|
| Xcode | 16 or newer (project format `objectVersion = 77`) |
| Deployment target | watchOS 11.0 — also runs on watchOS 26/27 |
| Language version | Swift 5 (`SWIFT_VERSION = 5.0`) |
| Device family | Apple Watch only (`TARGETED_DEVICE_FAMILY = 4`) |

The project uses file system synchronized groups: new files inside
`BinaerRechner/` join the target automatically, no need to touch the project
file.

## Layout

```
BinaerRechner/
├── BinaerRechnerApp.swift           App entry point
├── Model/
│   ├── NumberBase.swift             Number systems: radix, color, digits, keypad
│   ├── NumberParser.swift           Reading/writing digits with overflow checks
│   ├── ConversionExplanation.swift  Overview + place-value worked example
│   ├── ConverterModel.swift         Shared value (@Observable) + input logic
│   └── UnicodeNotation.swift        Super-/subscript digits (2⁴, 15₁₀)
├── Support/Haptics.swift
└── Views/
    ├── ConverterView.swift          Main screen
    ├── ValueCard.swift              A single value field
    ├── KeypadEditorView.swift       Keypad + stepper + live preview
    └── ExplanationSection.swift     One section of the worked example
```

The core is deliberately small: there is **one** value, and the four number
systems are just different notations for it. Appending a digit is therefore
plain `value · radix + digit`, deleting one is `value / radix`. All conversion
logic lives in `Model/` and does not depend on SwiftUI, so it can be verified
independently of the interface.

## Controls

| Action | Effect |
|---|---|
| Tap a field | Open the keypad for that number system |
| Tap a digit | Append the digit |
| ⌫ | Delete the last digit |
| C | Reset to 0 |
| Digital Crown / `−` `+` | Change the value by 1 |
| ✓ or swipe right | Back to the overview |
