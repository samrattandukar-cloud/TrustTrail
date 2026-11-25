# TrustTrail

Evidence-based vehicle history for Nepal's second-hand market. Owners record
services, insurance, road tax, repairs and inspections with receipts; buyers
browse marketplace-style demo listings that open a neutral report: history at a
glance, timeline, odometer trend, gap notes and a **completion meter — not a
trust score**.

Built for **CIS099-2 Mobile Application Development, Assessment 1 (Option 1)**.
Flutter app, offline-first SQLite, shareable branded PDF dossier.

## Run from VS Code

1. Install Flutter 3.47+ and the Dart/Flutter VS Code extensions.
2. Start an Android emulator or connect a phone with USB debugging.
3. Open this folder in VS Code.
4. Run **TrustTrail (Pixel 8a emulator)** from the Run and Debug panel, or
   **TrustTrail (pick device)** for a real phone.

From a terminal:

```bash
flutter pub get
flutter run -d emulator-5554
```

The emulator used during development is `Pixel_8a` (Android SDK at `D:\AndroidSdk`):

```bash
"D:/AndroidSdk/emulator/emulator.exe" -avd Pixel_8a -no-snapshot-load
```

### Real Android phone

1. Enable Developer options → USB debugging.
2. Connect the phone and accept the RSA prompt.
3. `flutter devices` → note the device id.
4. `flutter run -d <device-id>` (or `flutter build apk --release` and install
   `build/app/outputs/flutter-apk/app-release.apk`).
5. Grant camera/photos permission when attaching evidence or scanning a QR.

## Demo access

- Onboarding → language → role → **Use the demo account**.
- Demo owner: Sujan Bajracharya, `+977 9801234567`. Enter that number (with or
  without `+977`) and tap **Continue with phone**; the six-digit OTP step only
  appears when registering a new account (any six digits work).
- Seeded vehicles: Honda Shine 125 (7/10 complete), Hyundai Creta SX.
- Buyer tokens: `TT-SHIN-2026`, `TT-FZS-2026` (14-month gap), `TT-GRND-2026`
  (odometer decrease). The **Browse** tab (available in both owner and buyer
  mode) shows the same three as marketplace-style demo listings (fictitious
  prices, sellers and areas); the **Search** tab looks up a plate, token or QR,
  and in buyer mode **Saved** keeps reports for comparison.
- **Settings → Demo data → Reset demo data** wipes local rows and reseeds.

## What to demo (≤5 minutes)

1. Sign in with the demo account → garage with completeness rings and reminders.
2. Open Honda Shine → timeline, odometer chart, gap note, share report.
3. Add a service record, attach a receipt, watch completeness and evidence counts.
4. Generate report → preview → share PDF or show QR/copy token.
5. Open **Browse** (works in both modes) → open the Yamaha FZ-S listing →
   history hero, at-a-glance checks, odometer gap + filters → save it, then
   open a second listing, save it and compare the two side by side under
   **Saved** (buyer mode).
6. Settings → Nepali, dark mode; submit the SUS survey and export CSV.

## Architecture

```
Widgets → Riverpod controllers → repositories → SQLite (sqflite)
                ↓
      Pure domain functions (completeness, odometer, B.S. dates, tokens, SUS)
```

- `lib/app/` — `RootGate` (splash → onboarding/auth → shell), role-aware
  `HomeShell` with a centre action.
- `lib/core/` — theme tokens, localized strings (EN/NE), shared widgets,
  B.S. date and token utilities.
- `lib/data/` — models, local database, deterministic seed data, repositories.
- `lib/domain/` — testable business rules with no Flutter/SQL dependency.
- `lib/features/` — onboarding, auth, garage, vehicles, records, evidence,
  report/PDF/share, buyer, reminders, profile, settings, SUS feedback.

## Quality gates

```bash
flutter analyze          # 0 issues
dart format --set-exit-if-changed lib test
flutter test             # 55 unit/widget/data tests
flutter build apk --release
```

## Honest limitations

- Records are owner-entered and are **not** checked with the Department of
  Transport or insurers.
- The completion meter shows checklist coverage; it is not a trust score.
- QR codes and tokens resolve against the **local** database. Reports created on
  another phone cannot be opened there — ask the seller for the PDF.
- The SMS code is simulated; any six digits work.
- The shareable PDF and the OS share-sheet summary are generated in English;
  every in-app screen follows the chosen language.
- All demo people, vehicles, receipts and reports are fictitious.
- Premium/evidence gating is intentionally deferred.
