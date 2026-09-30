# Tumbas Servis

*"Servis banyak motor, sekali booking."* — a Flutter app that books motorcycle service for **1–5 motors in a single transaction**: each motor gets its own service type, parts and complaint notes, while the whole fleet shares one workshop and (by default) one arrival slot. The result is one ticket with per-unit status tracking.

Technical & UI/UX assessment for PT Karya Putra Wardjito (Servisin Aja). All data is mocked locally (`assets/mock/*.json`) — there is no backend. Demo login OTP: `123456`.

## Submission links

| Item | Link |
|---|---|
| Figma (public) | **TODO(you): paste the public Figma link** — design steps 20–21 are still deferred (`docs/plan/design/`) |
| GitHub repo | https://github.com/galahseno/TumbasServis  |
| APK download | [Releases → latest](https://github.com/galahseno/TumbasServis/releases/latest)  |
| AI chat / log | Claude Code session logs in [`docs/claude-session/`](docs/claude-session/)  |

## Download

Grab the latest build from [**Releases**](https://github.com/galahseno/TumbasServis/releases/latest):

| Platform | File | Notes |
|---|---|---|
| Android | `TumbasServis-vX.Y.Z.apk` | Allow "install unknown apps" for your browser/file manager, then open the APK. |
| macOS | `TumbasServis-vX.Y.Z-macos.dmg` | Not notarized (see below). |

`SHA256SUMS.txt` is attached to every release: `shasum -a 256 -c SHA256SUMS.txt`.

### Opening the macOS build

The app is ad-hoc signed, not notarized (no paid Apple Developer account), so Gatekeeper blocks the first launch. Drag **Tumbas Service** to `/Applications`, then either:

- System Settings → Privacy & Security → scroll to the blocked-app notice → **Open Anyway**, or
- `xattr -dr com.apple.quarantine "/Applications/Tumbas Service.app"`

## Features

**Core (multi-vehicle booking flow)** — Pilih Motor → Detail Servis → Bengkel & Jadwal → Ringkasan → Tiket:

- Book 1–5 motors in one transaction; per-unit service, parts/oil and complaint notes; "Salin dari" copies a unit's setup to another (incompatible parts are dropped and reported).
- One workshop and one shared slot, or split slots per unit; capacity-aware slot chips.
- Live estimate of total cost and fleet duration, voucher eligibility with the "kurang Rp…" shortfall message.
- Multi-unit ticket (QR + per-unit rows) and per-unit status timeline.

**Bonus screens** — garage (add/edit/delete motors with photo), part/oil catalog, workshop list + detail, booking history + detail, per-unit tracking (mechanic, ETA, reschedule/cancel), invoice, workshop review, notifications, profile, and a **demo mode** that advances unit status on demand.

### Assessment bonus criteria

| Bonus | Where |
|---|---|
| Completeness of services & screens | 26 screens S01–S26 (`prd/04-screens.md`): tracking, part/oil picker, invoice, workshop rating and more |
| Brand identity | **Custom TumbasServis brand** (orange-led, Exo 2, light + dark) instead of the literal Servisin Aja palette |
| Dummy data & state management | 11 mock JSON files (5 workshops, 16 motor models, 14 parts, 6 mechanics, seeded bookings/notifications…) behind repository interfaces; Riverpod throughout |
| Responsive & safe layout | Phone + tablet portrait/landscape; layout tests at the 8 sizes in `prd/06-responsive-layout.md`, also at ×1.3 text scale |
| Clean architecture | Feature-first data / domain / presentation layers with an enforced dependency direction (see Architecture) |

## Prerequisites

| Tool | Version | Needed for |
|---|---|---|
| [Flutter](https://docs.flutter.dev/get-started/install) | 3.44.0 stable (Dart ^3.12, bundled) | everything |
| Android SDK + emulator/device | Android Studio or command-line tools | running / building the APK |
| JDK | 17 | Android Gradle build |
| Xcode + CocoaPods | current stable | macOS build only |

Run `flutter doctor` and fix anything it flags for the platform you target. iOS is not configured.

## Run from source

Generated files (`*.freezed.dart`, `*.g.dart`) are committed, so nothing needs generating first.

```sh
git clone https://github.com/galahseno/TumbasServis.git
cd TumbasServis
flutter pub get
flutter run                      # pick an emulator/device, or -d macos
flutter analyze && flutter test  # 0 issues, all tests green
```

Only if you change a `@freezed` / `@JsonSerializable` class:

```sh
dart run build_runner build --delete-conflicting-outputs
```

`flutter run --release` works without any signing setup (falls back to the debug key). To build the APK yourself: `flutter build apk --release`.

## Tech stack

| Package | Used for |
|---|---|
| `flutter_riverpod` | State management (Notifier view models) and dependency injection |
| `go_router` | Routing, redirects, deep links from notifications |
| `freezed`, `json_serializable`, `build_runner` | Immutable models / UI state and JSON mapping |
| `hive_ce`, `shared_preferences`, `path_provider` | Local persistence of drafts, garage, settings |
| `intl` | Indonesian (`id_ID`) dates and currency |
| `qr_flutter` | Ticket QR code |
| `image_picker` | Motor photo |
| `url_launcher` | Opening the workshop in the maps app |
| `flutter_launcher_icons` | Launcher icons (Android + macOS) |

Font: Exo 2 (variable, bundled in `assets/fonts/`).

## Architecture

Feature-first clean architecture — `lib/<feature>/{data,presentation}` with shared `lib/core/{domain,data,presentation}`; Riverpod view models, freezed UI state, go_router. Domain code is pure Dart (no Flutter imports); presentation reaches repositories only through DI providers typed by the domain interfaces. Layer rules and folder conventions: [`docs/plan/mobile-app/00-index.md`](docs/plan/mobile-app/00-index.md); product spec: [`prd/`](prd/00-index.md).

Phone portrait is the primary target; tablet portrait + landscape layouts are included as a bonus.

## Releasing

Releases are built by [`.github/workflows/release.yml`](.github/workflows/release.yml) when a version tag is pushed:

```sh
git tag v1.0.0
git push origin v1.0.0     # v1.0.0-rc1 → published as a prerelease
```

The workflow runs `flutter analyze` + `flutter test`, builds the signed APK and the macOS DMG, and publishes a GitHub Release with checksums. The tag must be on `main`. Running the workflow manually (Actions → Release → *Run workflow*) is a dry run: it builds and uploads workflow artifacts but publishes nothing.

### Android signing (maintainers)

Real signing values live in `android/key.properties` (gitignored; template in `android/key.properties.example`) with the keystore at `android/app/upload-keystore.jks` (gitignored). CI reads the same values from GitHub repository secrets:

| Secret | Content |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64` of `upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_PASSWORD` | key password (same as keystore password for PKCS12) |
| `ANDROID_KEY_ALIAS` | key alias (`tumbas`) |

macOS needs no secrets.

## Known limitations

- Mock data only; no backend, payments or real notifications. Time-based demo content is seeded on first launch.
- macOS build is unsigned by Apple (Gatekeeper prompt on first launch); iOS is not built.
