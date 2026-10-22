# STYVA logo assets — still required

The brand reference supplied for STYVA is a presentation board (wordmark
variations, app icon and mock-ups on textured backgrounds). It is not a clean
logo asset, so nothing has been cropped or traced from it. Until the files
below are supplied, the app shows an interim typographic wordmark
(`lib/shared/widgets/styva_wordmark.dart`, set in Cormorant Garamond) and the
platform launcher icons and native launch screens are unchanged.

| File | Use | Format |
| --- | --- | --- |
| `styva_wordmark_dark.svg` (+ `@2x`/`@3x` PNG if SVG isn't used) | Charcoal wordmark on light backgrounds (app bars, auth screens) | SVG, or transparent PNG at 3x (e.g. 600 × 120) |
| `styva_wordmark_light.svg` (+ PNG) | Ivory/white wordmark on charcoal (splash screen) | SVG, or transparent PNG at 3x |
| `styva_app_icon.png` | Launcher icon (the "SV" monogram) — Android, iOS, web | 1024 × 1024 PNG, no transparency (iOS requires opaque), full-bleed charcoal background |
| `styva_app_icon_foreground.png` | Android adaptive-icon foreground (monogram only) | 1024 × 1024 transparent PNG, artwork inside the central 66% safe zone |
| `styva_splash_logo.png` | Native launch screen (before Flutter starts) | Transparent PNG, ~288 × 288 @1x with 2x/3x variants |

## When the files arrive

1. Put them in this folder and add `- assets/brand/` under `flutter: assets:` in `pubspec.yaml`.
2. Swap the `Text` in `StyvaWordmark` for the wordmark image (every screen already uses that widget).
3. Generate launcher icons and native splash from `styva_app_icon*` and `styva_splash_logo`
   (e.g. with `flutter_launcher_icons` / `flutter_native_splash`, added as dev dependencies at that point).

Brand colours to match: Ivory `#F6F3EE`, Charcoal `#222222`, Warm Sand `#B7A58A`.
