# GamerPower Giveaways (Flutter)

Individual assignment: a Flutter app that reads https://www.gamerpower.com/api/giveaways
and shows the giveaways in a GridView.

| # | Requirement | Where |
|---|---|---|
| 1 | Bottom navigation bar | `lib/screens/home_shell.dart` (Games / Settings) |
| 2 | Game screen (GridView) | `lib/screens/games_screen.dart`, `lib/widgets/game_card.dart` |
| 3 | Detail screen | `lib/screens/detail_screen.dart` |
| 4 | Settings screen | `lib/screens/settings_screen.dart` |
| 4.1 | Dark mode switching | Dark mode switch → `ThemeController.setDark` |
| 4.2 | Color theme switching | Purple / Teal / Orange / Blue → `ThemeController.setSeed` |

Extras: filter chips (All / Game / DLC / Early Access), search, pull-to-refresh,
Hero image animation, settings saved on the device (`shared_preferences`),
responsive grid (2 columns on phones, more on tablet/web).

Design (Figma): https://www.figma.com/design/4j4ODLQpw9HhO5RTrGEFH9

## Project structure

```
lib/
  main.dart                  # App + theme wiring
  models/giveaway.dart       # API data model
  services/giveaway_api.dart # HTTP call to GamerPower
  theme/                     # Light/dark themes + ThemeController
  screens/                   # home_shell, games, detail, settings
  widgets/                   # game_card, giveaway_image
  utils/format.dart          # date / number formatting
test/widget_test.dart        # unit tests for model + formatting
```

## Run locally

```bash
# 1. Generate the platform folders (android/ios/web) once — keeps lib/ untouched
flutter create . --platforms=android,ios,web --project-name gamerpower_giveaways

# 2. Install packages and run
flutter pub get
flutter run            # phone/emulator
flutter run -d chrome  # web
```

**Android:** after step 1, open `android/app/src/main/AndroidManifest.xml` and add,
above `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

(Internet permission so release builds can call the API; `queries` so the
"Get Giveaway" button can open the browser.)

## Deploy the demo (GitHub Pages)

1. Create a new **public** GitHub repo and push this folder to the `main` branch.
2. In the repo: **Settings → Pages → Source: GitHub Actions**.
3. The workflow in `.github/workflows/deploy.yml` builds the web app and publishes it.
   Your demo link will be `https://<your-username>.github.io/<repo-name>/`.

Note: on the web, if the browser blocks the direct API call (CORS), the app retries
through the public proxy `corsproxy.io`. Phone builds call the API directly.

## Submit

- Demo: `https://<your-username>.github.io/<repo-name>/`
- Source code: `https://github.com/<your-username>/<repo-name>`
