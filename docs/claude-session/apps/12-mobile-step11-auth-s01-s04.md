# Claude Session Log — 12: Mobile-app step 11 — Auth: S01 Splash, S02 Onboarding, S03 Login, S04 OTP

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** First-launch flow — splash session-check, 3-slide onboarding, phone login, mock OTP verification. First presentation-feature step in the app (step 10 was foundations only).

## Initial prompt

Session 1: "i want to do docs/plan/mobile-app/11-xx, interviewme with detail if need" (hit the usage limit mid-build; plan file preserved the state).
Session 2: "do rest of work, session already reset / i prepare the exports png folder pencil again, but only load minimal png what we need for each task/plan we do for this and later session (don't want waste token much for png load, do hybrid markdown + png needed for the next plan)".
Session 3 (this one, follow-up): two small UI fixes, then "approve".

## Research performed

Session 1, three parallel Explore agents: (1) design step 13 file + session log (exact copy/states/components) plus PRD 04 S01–S04 and PRD 03 F1; (2) existing `core/presentation/components/` APIs (`TsTextField`, `TsButton`, `TsLogo`, `TsAppBar`), the router's current `Placeholder` wiring, `SessionRepository`/`SessionRepositoryImpl` signatures, the `auth_data_module.dart` provider, and confirmation that no presentation-layer screen folder existed yet in the repo (this is the first one); (3) build-flavor/`kDebugMode` usage (none existed) and every doc mention of the "Kode demo: 123456" gating requirement, finding it explicitly unresolved.

Session 2 re-read the plan file + step 11's own file to recover full context after the reset, then confirmed the design PNG exports the user had regenerated (`design/pencil/exports/step13/INDEX.md` mapping frame names to node-id filenames) and read them **one or two at a time per screen** while building each one, per the user's explicit request to keep token use down across this and future sessions (hybrid markdown-spec + targeted-PNG approach).

## Clarifying interview

Plan-mode `AskUserQuestion` round (session 1), 4 questions, all recommended options accepted:
1. Missing step13 PNG exports → build from the text spec (same precedent as step 10).
2. OTP 6-cell input → hand-rolled, not a package.
3. "Kode demo: 123456" gating → `kDebugMode` (no flavor infra existed).
4. S04 "Verifikasi" CTA → real disabled button + a static, always-visible reason line under it.

Full plan written to `~/.claude/plans/i-want-to-do-cached-wombat.md` and approved via `ExitPlanMode` before any code was written.

## Execution

**Data-layer gap (session 1):** `SessionRepositoryImpl.login()`/`verifyOtp()` never consumed `DemoModeController`'s one-shot armed-error flag (`consumeArmedError()` existed but was unused by any repository), so S03's mandatory network-error state had no real trigger. Wired `login()` to it, added `demoModeController` to its constructor + the `sessionRepositoryProvider` DI wiring, and fixed 4 other tests whose direct `SessionRepositoryImpl(...)` calls broke as a result (`booking`, `review`, `invoice`, `tracking` repository tests all construct one to seed a session).

**Screens (session 2):** all 4 built under `lib/auth/presentation/` following the `flutter-presentation-layer` skill exactly (page/view_model/state/components per screen, one `di/auth_presentation_module.dart`). New shared util `core/presentation/utils/phone_formatter.dart` (digit grouping `812-3456-7890` + masking `812-****-7890`, used by both login and OTP). Router's 4 `Placeholder()` entries replaced with the real pages.

**Two real bugs found while building, not specific to this step's own code:**
- `TsButton` (step 10, approved): always built its `CircularProgressIndicator` inside an `IndexedStack`, so the spinner's indeterminate ticker ran forever even offstage while `isLoading: false` — a perpetually-scheduled animation frame on *every* screen with a button, silently hanging `pumpAndSettle()` in tests. Fixed to swap the whole child instead of just the `IndexedStack` index.
- `SplashViewModel`: its `Future.delayed`-driven navigation wasn't cancellable, so leaving `/splash` didn't stop it — a late completion could redirect away from whatever screen the app was actually on. Rewrote with real `Timer`s cancelled via `ref.onDispose`; `splashViewModelProvider` is the only one of the 4 auth view models kept `.autoDispose` (the other 3 are plain `NotifierProvider`s, deliberately — see the code comment in `auth_presentation_module.dart`).

**Additive component change:** `TsTextField` (step 10) gained optional `focusNode`/`inputFormatters`/`onSubmitted`/`onEditingComplete` params, needed for the phone field's blur-validation and live digit-grouping.

**Tests:** 11 new tests across `test/auth/presentation/{splash,login,otp}/` + an `OtpInput` paste widget test. Two pre-existing test files needed fixing because routes now render real pages instead of `Placeholder()`: `test/app/navigation/router_test.dart` (needed the real `App()` widget with its theme, plus a `ManualTimerFactory` override for OTP's countdown so no real `Timer` leaks past the test) and `test/support/fake_session_repository.dart` (extended with configurable `loginResult`/`verifyOtpResult`, additive).

A significant fraction of session 2 went into diagnosing test-harness-only flakiness (not app bugs): `.autoDispose` notifiers racing an unrelated ancestor rebuild at `t≈0` in tests, and `container.read()` needing to happen between `tester.pump()` calls to flush Riverpod's scheduler for state mutations originating inside a bare `Timer` callback. Both are documented inline in the test files' own comments so a future step doesn't have to re-derive them.

## Review rounds

**Round 1:** shown the file list + 243/243 test summary (no on-device screenshots available in this environment). User asked for two changes before approving: keep the phone field's `+62` prefix always visible (Material's `prefixText` only shows once focused/non-empty — switched to `prefixIcon`, which has no such gating), and remove the ripple/ink effect on "Ganti nomor", "Kirim ulang kode", and the bottom nav bar tabs (`AuthLink` and `NavBar`'s tab item both swapped `InkWell` for a plain `GestureDetector`, matching `TsButton`'s own existing no-ripple pattern; explicit `Semantics` added to the nav tab since `InkWell` no longer supplies it). Re-verified analyze/format/full test suite after. Approved.

## Key decisions worth flagging to a reviewer

- The network-error state on S03 is now genuinely reachable (via `DemoModeController.armNextWriteError()`), not merely covered by a fake-repository test — but nothing in the presentation layer yet exposes a way to *arm* it from the running app (that's the demo-mode panel, S26, owned by a later step).
- `TsButton`'s spinner-ticker bug would have silently affected `pumpAndSettle()` on every future presentation step's widget tests, not just this one — worth a quick mention if another agent touches `TsButton` again.
- Onboarding body copy is still the design doc's own "(draft)" text, carried through as final per the approved plan; flag to the user later if they want it revisited.
- Manual on-device run was not possible in this environment (no emulator/simulator configured) — recommended before treating this step as fully verified end-to-end, same gap step 10 had.

## Output

Files touched: `lib/auth/presentation/**` (new, 4 screens), `lib/core/presentation/utils/phone_formatter.dart` (new), `lib/app/navigation/router.dart`, `lib/auth/data/{di,repository}/*.dart`, `lib/core/presentation/components/{ts_text_field,ts_button,nav_bar}.dart`, `test/auth/**` (new), `test/app/navigation/router_test.dart`, `test/support/fake_session_repository.dart`, `test/{booking,review,invoice,tracking}/data/repository/*_impl_test.dart`. Not committed — staged for the user's own commit. Next step: 12 — Home S05 + `AppShell` wiring.
