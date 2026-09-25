# TumbasServis — Design Plan (Pencil → Figma)

## Purpose

Step-by-step execution plan for the UI/UX design of **TumbasServis**, built from the PRD in [`../../../prd/`](../../../prd/00-index.md). Designs are authored in **Pencil (pencil.dev MCP)** in one file, `design/pencil/TumbasServis.pen`, then brought into **Figma** via **Route B**: `html-css` export → the [html2figma](https://html2figma.com/) plugin (approved in step 01, test-imported after step 04; the P0 test import planned for step 12 was deferred, and the full import in step 20 now runs **after the Flutter app build**; assessment deliverable M1: public Figma link, Home → Booking Success).

Every step follows the same loop: **build → self-check → `/better-interface` pass → user review gate → session log**, and after the user approves it writes a `docs/claude-session/` file. Nothing is committed by Claude; git is handled by the user.

Primary PRD inputs: [02 brand & design system](../../../prd/02-brand-design-system.md), [03 flows & rules](../../../prd/03-user-flows.md), [04 screens](../../../prd/04-screens.md), [06 responsive layout](../../../prd/06-responsive-layout.md).

## How to run a step

Start a session with: *"Run design step NN — follow `docs/plan/design/NN-<name>.md` and the workflow in `00-index.md`."* One step per session keeps context small and the session log clean. Steps run in order; each lists its dependencies.

## Decision log

Locked in the planning interview (2026-09-23):

| Topic | Decision |
|---|---|
| Step granularity | Feature groups; P0 booking flow ≈ one screen per step; P1 grouped → 14 design steps + setup + 2 audit/checkpoint + 2 Figma = 21 steps |
| Coverage per step | Phone 360×800 + tablet portrait 800×1280 + tablet landscape 1280×800, light + dark (see frame matrix rule) |
| Order | Priority: setup → foundations → components → P0 Home→Success → P1 → audit → Figma |
| Pencil file | Single `design/pencil/TumbasServis.pen` (user does *Save As*; amended 2026-09-23 from `tumbasservis.pen`); canvas sections Cover / Foundations / Components / Flows; the Figma pages are assigned by frame name in step 20b, not by canvas section (step 19 merged the Phone and Tablet stacks into one band per screen) |
| `/better-interface` | Run after the draft; auto-apply HIGH + MEDIUM fixes in Pencil; list LOW for the user |
| States | P0 screens: every state in `prd/04`. P1 screens: default + empty + one loading/error |
| Figma path | Amended 2026-09-23: plugin **Pen.dev to Figma · FREE** (community id `1601664618009066049`) imports the `.pen` into Figma. Fallbacks if the step 01 spike fails: [.pen to Figma — Pencil.dev Importer](https://www.figma.com/community/plugin/1619112150017437644/pen-to-figma-pencil-dev-importer), then [Pen to Figma Importer](https://www.figma.com/community/plugin/1620424308020292063/pen-to-figma-importer) (open source); last resort = manual rebuild from Pencil spec + PNG exports. Plugin claims (components, theme-mode variables, icons) are unverified until step 01. **Round 2 (2026-09-23):** the user reports the `.pen`-importer plugins unreliable (a second one behaved the same), so **Route B — `html-css` export → [html2figma](https://html2figma.com/blog/pen-dev-to-figma/)** (free; takes a local `.html` file by drag-and-drop) was tested and **approved by the user at step 01 close** ("this perfect like we want, approve"). It is now the primary path; the `.pen`-importer plugins above are dropped. Known gaps handled by hand in step 20: components (rebuilt + *Combine as variants*) and variables/styles (rebuilt from `GetVariables()`). Route C (a Figma development plugin that reads a Pencil JSON manifest) stays an option if the manual rebuild proves too heavy |
| Figma plan | Starter (free). Team files cap at 3 pages/file; **Drafts** have unlimited files and pages. Variable modes are documented only for Education/Pro/Org/Enterprise, so PRD 02's Light/Dark modes likely fail. **Decided at step 01 close (2026-09-23):** the deliverable lives in a **Draft**; Light/Dark variables, when built by hand, are two collections (`Semantic Light` / `Semantic Dark`) unless the account supports modes. Route B imports no variables anyway. Variable modes and the Draft's public link are **not yet verified** on the account → step 20 (the step 12 test import was deferred) |
| Figma MCP | None (Starter allows ≈ 6 MCP reads/month). The user performs every Figma action; Claude supplies per-step checklists and judges the user's screenshots against the Pencil PNG exports |
| Figma import cadence | Spike in step 01 → test import after step 04 (**Booking sheets only**; decided at the step 04 kickoff, step 02–03 sheets are not re-exported) → ~~test import at step 12 (P0 flow)~~ **dropped at the step 12 kickoff (2026-09-24)** → full import + cleanup + prototype in steps 20–21, which run **after all design steps and the Flutter app build** |
| Window classes | Confirmed 2026-09-23: device type by `shortestSide ≥ 600`; layout class by **width** (360 compact / 800 medium / 1024 expanded / 1280 large). `prd/06` wording fixed in step 01 |
| Reference research | None (no Mobbin) — design from the PRD |
| Icons | Material Symbols Rounded (closes the PRD 02 open choice) via Pencil `icon` nodes, weight 100–700 |
| Imagery | Flat geometric vectors in orange/sand. Pencil forbids hand-built path art → `Generate(frame, "svg", prompt)` with palette hexes, each result turned into a reusable component. Budget ≈ 11: 5 empty/error/success, 3 onboarding, 3 motor silhouettes. Photo slots = aspect-ratio gradient placeholders |
| Git | No commits by Claude |
| Doc layout | This index + one file per step |
| Booking-flow chrome | Decided at the step 06 kickoff (2026-09-24): the booking flow **S10–S18 shows no `NavBar` / `NavRail`** on any breakpoint (focused flow; back / close in the app bar, sticky footer or bar at the bottom). Tablet = full-width app bar + stepper, content centered at the PRD 06 max-width, so S11 / S15 / S16 multi-pane layouts get the full width. The tab shell (`AppShell`) is used only by S05, S07, S19, S25. Exit rule: the exit-booking dialog appears only when the draft holds ≥ 1 selection; its actions are "Simpan & keluar" / "Lanjutkan booking" (non-destructive) |
| S11 Detail Servis (step 07 kickoff, 2026-09-24) | Two sessions: **07a** phone, **07b** tablet, one review gate after 07b. Booking-flow app bar from S11 on = **back leading + close trailing** (back → previous step, close → the exit dialog under the same ≥ 1-selection rule). Active unit chip = selected style **keeping** its ✓ / ○ / error glyph. Keluhan = collapsed optional row, auto-open + required with Perbaikan/Keluhan. "Salin dari" = named single-source row, sheet only with 2+ sources, undo snackbar. Estimate = everything selected so far, live. Tablet-L 1 unit = form + `EstimatePane`. Remove-unit control = icon in `UnitHeader`. Details in [07](07-s11-detail-servis.md) |
| S11 tablet (step 07b kickoff, 2026-09-24) | Tablet frames are **fixed viewports** (no status / gesture bar); Tablet-L 3-pane = rail 252 · form 572 · `EstimatePane` 360, 1 unit = centered form 720 + pane 360; Expanded = rail 252 + form 700 + glass pill at the form-column width; Tablet-P pill 720. `EstimatePane` = static per-unit lines + total + duration + Lanjut (no voucher). Wide stepper centered 720, badge stays in it. Parts stay stacked. +1 stress frame (Tablet-L ×1.3) → 39 S11 frames. **07a correction:** Lanjut is disabled (with the reason line) whenever a unit chip is not ✓, so phone Multi Unit / Remove Unit Dialog were fixed. Details in [07](07-s11-detail-servis.md) |
| S13 / S14 (step 08 kickoff, 2026-09-24) | One session, 36 frames. S14 has **two variants**: in-flow (back + close, no stepper, CTA "Pilih bengkel ini" → S15) and standalone (back only, CTA "Booking di sini" → S10, workshop carried, S13 skipped; entry from the S18 / S20 workshop row, annotation only). S13 has no footer; previewed card = `border-accent`, chosen workshop = "Dipilih" tag (S14 CTA "Lanjut ke jadwal" when already chosen). Card shows bays + "Estimasi 2 jam untuk 3 motor" (makespan over that workshop's bays; S11's duration is annotated "asumsi bengkel 2 bay"). A closed-now workshop stays bookable ("Tutup · buka 08.00", helper on the S14 CTA). Token-bound `StaticMap` and `WorkshopPhoto` (no `Generate`). Filters: "Buka sekarang" toggle + exclusive sorts (default Terdekat). Tablet-L list 440 + pane 768; Expanded list 400 + pane 552; +Expanded and Text ×1.3 frames. Details in [08](08-s13-s14-bengkel.md) |
| S15 Pilih Jadwal (step 09 kickoff, 2026-09-24) | One session, 27 frames. Tablet-L = **2-week calendar grid** (7 × 3) + slot grid side by side; phone / Tablet-P keep the horizontal strip. Split mode = `UnitSlotSection` **accordion** (phone, Tablet-P) and **unit rail + grid + slots** (Tablet-L). New compact `WorkshopSummaryRow` on top; flat `SelectionFooter` with slot recap. Capacity banner **derived** from the day's chips, escalating info → warning (no slot fits N) with action "Pisah jadwal". **Split counts sibling picks** (deviates from PRD 03 "independent"); toggling modes is non-destructive. Chip caption "Sisa n motor". `short` > `limited` > `available` (for 3 units `limited` cannot show in shared mode). D+0 slots before now + 2 h = disabled "Lewat". `TsSwitch` moved here from step 18. Details in [09](09-s15-jadwal.md) |
| S16 / S17 (step 10 kickoff, 2026-09-24) | One session, 39 frames. S17 = **full page** (`/booking/summary/voucher`, back-only bar, radio list + flat footer "Pakai voucher" with a saving preview; no code field). S16 units: `UnitSummaryAccordion` = detail + line prices, the estimate block = **static per-unit lines** (amends step 04 decision 7); title "Estimasi biaya", total "Total estimasi"; makespan explained by an inline caption. **Flat** confirm bar (total row + full-width "Konfirmasi booking", 0 glass). `SummaryCard` = Bengkel row + Jadwal row with separate Ubah, split slots listed inside the Jadwal row. `VoucherRow` applied = name + "Hemat …" + "Hapus". Confirm error = inline banner + "Coba lagi". Tablet-L / Expanded = two-pane (720 · 360 centered; 592 · 360) with the voucher row in the pane. + S16 Expanded and S17 single-motor frames. Details in [10](10-s16-s17-ringkasan.md) |
| S18 Booking Berhasil (step 11 kickoff, 2026-09-24) | One session, 18 frames. **No app bar** (exit = the two CTAs; system back = Beranda). Check badge + "Booking berhasil!" (no `Generate`); the booking code appears **once, on the ticket**, with a "Salin" icon button (amends `TicketCard`). **Real scannable QR** of the code drawn by a loop of rectangles (`QrCode`, primitives → dark-on-light in both themes; verified by decoding the exported PNG). Flat sticky footer `TicketActions` "Lacak status" + "Kembali ke beranda" (sentence case). Split mode = Slot Line per unit row + Schedule row "jam berbeda tiap motor". Tablet-L = header + ticket 480 left, status panel 400 + CTAs right (no Expanded frame). Loading = real header + skeleton ticket. One P2 variant (share + calendar) and a copied-code snackbar frame; 360×640 stress = 5-unit specimen. Details in [11](11-s18-tiket.md) |
| P0 checkpoint (step 12 kickoff, 2026-09-24) | **Pencil-only; all Figma work deferred** — no P0 test import, HTML export or plugin check; steps 20–21 run **after all design steps and the Flutter app build** (html2figma, Starter Draft / variable modes and the public link stay unverified until step 20). `P0 Flow Board` = live copies of the default phone light frames, numbered arrows, entry-point notes. HIGH + MEDIUM fixes applied across approved screens and logged in the owning steps; systemic LOWs from steps 05–11 fixed now, single-frame LOWs left for step 19. **`Label Small` raised 11 → 12** (`type-label-sm-*`: 12 / 1.3333 / 0.3, same 16 px line; text-size rule "nothing under 12"). Exports: flow board + edited P0 frames to `exports/step12/`, full set at step 19. Details in [12](12-p0-checkpoint.md) |
| Auth S01–S04 (step 13 kickoff, 2026-09-24) | One session, 33 frames. Onboarding art = **component vignettes** on a tonal `accent-soft` panel (silhouettes + ticket, motor cards + service pills, status timeline + `FleetProgress`), theme-aware by construction; the planned 3 × `Generate(svg)` returned nothing (4 attempts, ~20 calls) so the user chose the fallback during the build (illustration budget stays at 8 of ≈ 11). Splash = mark-only default + 1 wordmark end-state phone frame (light + dark). S02 phone = art band on top (~55 %) + title / body / `PageIndicator` / CTA; Tab-P card 560; Tab-L split. S03 / S04 phone = top-aligned left text, terms pinned at the bottom; Tab-P `AuthCard` 480; Tab-L form + `AuthHero` (reuses slide-1 art, no 4th generation). S03 CTA always enabled, error on submit / blur ("Nomor tidak valid. Contoh: 812-3456-7890"). S04: visible "Kode demo: 123456", "Verifikasi" only (no auto-submit), "Ganti nomor". + keyboard-open S03 and S04 frames; loading / network error / stress stay annotations. Voice "kamu". Details in [13](13-auth-s01-s04.md) |
| Garage S07–S09 (step 14 kickoff, 2026-09-25) | One session, 33 frames. Demo moment = **after booking** (S05-consistent): S07 = Vario / Beat / PCX with in-service badges + Supra X free; S09 default = **Beat 110 in service** (CTA "Booking motor ini" disabled + reason + "Lacak servis" → S20; history = active row + 3 past rows + "Lihat semua" → S19 filtered), free-motor frame = Supra X 125 (CTA enabled, history empty). S07 add = **one action only** (amended at review): header "+", hidden while the garage is empty (title-only bar) so the empty-state CTA is then the only add action; no in-list add card, no FAB; tablet grid **reuses** the horizontal `VehicleSelectCard / Mode=Display` (new master `State=In Service`). S08: photo = silhouette tile + "Tambah foto" + helper "Opsional. …" (chooser / permission annotation only); model picker = bottom sheet (phone) / centered modal 560 (tablet) with brand groups + search; plate auto-format + duplicate error; year numeric; nickname cap 20 with counter (closes the step 06 LOW); flat sticky "Simpan" always enabled, validate on submit, dirty-cancel dialog non-destructive. S09: edit in the app bar, `MotorDetails` card (List / Grid), "Hapus motor" = danger ghost at the very bottom (blocked dialog when in service; on Tab-L it is pinned at the foot of the hero column so it stays in the 800 dp viewport; the Tab-P frame is a full-scroll capture). + S08 keyboard-open / saving / save-error frames. Details in [14](14-garage-s07-s09.md) |
| S12 Katalog (step 15 kickoff, 2026-09-25) | One session, 17 frames. **Full-screen page at every size**, pushed over S11 (no `NavBar` / `NavRail`): select mode (S11 "Lihat semua", app bar close, unit header "Untuk: Beat 110") and browse mode (S05 quick link, back arrow, no unit context / checkbox / cart). Phone 1-col list, Tab-P 2-col grid (720), Tab-L 4-col grid; detail = bottom sheet (phone) / centered modal 560 (tablet). Row "Hanya yang cocok untuk Beat 110" with `TsSwitch`, default ON; OFF shows incompatible tiles disabled with a category + cc reason (icon + text). **Staged selection**: "Selesai" commits to S11's active unit; close with changes → "Buang perubahan?" (non-destructive). Tile: leading checkbox toggles, body opens detail (CTA "Tambah ke booking" / "Hapus dari booking"). Flat `SelectedPartsBar` (S11 keeps the only glass bar). Detail compat block = rule line + garage rows ✓ Cocok / ✕ Tidak cocok. Catalog = 14 parts, chips Semua · Oli · Kampas rem · Busi · Aki · Ban · Filter udara; Beat 110 fits 7 of 14. + browse-mode detail, dirty dialog, search keyboard-open; no ×1.3 / Expanded frame. Details in [15](15-catalog-s12.md) |
| S23 Invoice / S24 Beri Ulasan (step 17 kickoff, 2026-09-25) | One session, 27 frames, run **in parallel with step 16** (own lane: components sheet at x 40424, frames in a new "Step 17" lane below the component sheets, no existing node moved; step 19 re-homes). **S23:** "Tandai Lunas" confirm dialog (non-destructive, "Simulasi, tidak ada pembayaran sungguhan"); Paid = success-soft `PaidBanner` + `PaymentStatusTag` (icon + text) and the flat footer swaps to "Beri Ulasan"; per-unit lines all expanded (`PriceBreakdown / Variant=Invoice`), Tab-L = breakdown 720 + `InvoiceSummaryCard` 360; P2 "Bagikan" = one variant frame. **S24:** whole-star input (5 × 48 dp, word label + "4 dari 5", half stars only in display), `RatingStars` star = token-bound `path` (Material geometry; half = clipped frame), 2 optional mechanic rows (Mas Rudi · Beat 110, Pak Anto · Vario 125 + PCX 160; section hidden for 1 mechanic), optional 300-char comment, validate on submit, submitted = same-screen `ReviewRecap`; Tab-L right pane = live recap preview. **S24 is hard-gated:** S20 "Beri ulasan" disabled with reason until paid (handoff to step 16). +keyboard-open, single-mechanic, Tandai Lunas error; no ×1.3 / Expanded frame. Details in [17](17-invoice-rating-s23-s24.md) |
| S19–S22 Tracking (step 16 kickoff + rescue, 2026-09-25) | First built by another model without a log or review; **audited and repaired in place** after the user reported misplacement and misalignment (node ids kept, dark frames re-copied). Phone rows under `Flows – Phone` after S12 (y 71,500), the `Flows – Tablet` block shifted **+11,000** (anchor y 83,500), tablet rows at the block bottom (y 144,400+). S19 = `TsAppBar / Type=Title` + **scrolling underline tabs** (`HistoryTab` masters; both states semibold, active = accent label + 3 dp indicator); S20 workshop row = chevron row → S14 standalone (no "Ubah"), `UnitStatusRow` = flat rows with the badge on the name row, Selesai = **Belum Lunas** (`Beri ulasan` disabled, reason "Tandai lunas di invoice dulu") + **Lunas**; S21 Tab-L right column = ETA + `MechanicCard` + `DemoModeShortcut` (no map); S22 sheets bottom-anchored (24 dp gesture inset inside the sheet), Tab-P = centered modal 560 (`Title Row`, radius-xl, shadow, no handle), Batalkan = `TsDialog`-style with wrapping reason chips (312 phone / 400 tablet). 43 frames. Details in [16](16-tracking-s19-s22.md) |
| S06 Notifikasi / S25 Profil / S26 Mode Demo (step 18 kickoff, 2026-09-25) | One session, 31 frames, own **"Step 18" lane** (x 37,000, y ≥ 36,000; components sheet x 41832; nothing existing moves, step 19 re-homes with the Step 17 lane). **S06** = pushed page (no `NavBar` / `NavRail`), moment = S05 (Sel 29 Sep ≈ 10.30, **2 unread** = the bell); unread = dot + semibold + hidden label; "Tandai semua dibaca" in the app bar; deep links: unit status → S21, booking → S20, invoice → S23, promo → **S10 with the voucher carried** (PRD 04 "S17 or Home" outdated), reminder → S10 with the motor preselected. **S25** in `AppShell` (Profil); one master Notifikasi switch; Tab-L = menu + **"Pratinjau tema"** (forced-theme mock); **logout = neutral confirm** (session only, data kept; danger styling only for "Reset semua data"); Tentang = version + demo note + "Dibuat oleh Galah" (sheet phone, modal Tab-P). **S26** pushed page; speed = **segmented "Mati / 15 dtk / 5 dtk"** (`TsSlider` dropped, amends PRD 04); per-unit rows (-A / -B / -C, Majukan + Reset) + booking-level "Majukan semua / Reset semua"; error sim = **one-shot, auto-disarm**, armed banner on S26 only; "Reset semua data" = seed data, session / theme / demo settings kept, back to Home; identity = `DemoModeShortcut` language ("MODE DEMO" label, inset surface, no dashes, no banner). Extras: S26 no-booking / Selesai, S06 all-read, ×1.3 stress on all three. **Build changes accepted at the review gate:** "Tandai semua dibaca" sits in the first group's header row (the ×1.3 stress frame showed the app-bar title wrapping); the S26 caption appears once at the top, the "MODE DEMO" label on every panel; promo / reminder tile discs are neutral (no info / warning ramps); selected unit row = card + accent border + "Dipratinjau" tag; notification text wraps with no line clamp; Tab-L S26 = left Kecepatan + Status, right preview + Simulasi galat + Data demo. Details in [18](18-notif-profile-demo.md) |
| Step 19 kickoff + canvas re-layout (2026-09-25) | **Canvas:** one band per screen S01 → S26 (Phone → Tablet-P → Expanded → Tablet-L, light + dark side by side, 480 dp cluster gaps); `Section / 03 Flows` replaces the Phone / Tablet anchors; `SectionHeader` gets a `surface-card` panel so headers read on a dark canvas (layout table in Conventions). **Audit:** 12 scripted tracks + `/better-interface` runs A – F; systemic / token-owned LOWs fixed once at the owning master, single-frame LOWs listed. **Tokens:** `focus-ring` light → `orange-600`, new `rating-star`. **Submit rule:** text forms (S03, S08) validate on submit; count-gated steps (S04 six digits, S10 / S11 / S15 / S16) may disable only with a visible reason line — decided at the gate: S04 gets the line "Masukkan 6 digit kode" (frames edited). **PRD edits:** one diff list grouped by file, approved per group before `prd/` changes. **Figma:** convert everything as built, but step 19 only prepares the manifest (`19-conversion-manifest.md`); no export or import. **No PNG export** this step (the user asks when needed). **Closed 2026-09-25:** audit 12 tracks + runs A – F, 15 fixes (header panel, S16 ×1.3 voucher row, loading reason lines, `focus-ring` orange-600, `rating-star`, weights, strokes, copy, motion notes, S04 reason line), PRD `00` – `07` updated (garage seed 4 motors, Ninja 250 → 16 models), spacing / radius / size literals stay a file convention, conversion manifest prepared, no export. Details in [19](19-full-app-audit.md) |

## Conventions

Grounded in the Pencil skill docs (`pen-schema`, `execute`, `guide/components`, `guide/mobile-app`).

### Canvas layout
- Pencil has no pages; the document root holds only screen frames, reusable component frames and section containers. Never place loose text/shapes at root.
- Top rows (unchanged since steps 02 – 18, apart from the anchors moving up 40 dp in step 19): `00 Cover` (0, 0) and Demo Content (1360, 0); `P0 Flow Board` (4200 × 2260, root `abxMC`) at (0, −2420) above the Cover. Foundations anchor y 1440, light boards y 1620, dark boards y 5028 under their own anchor (y 4840). Components anchor y 8360 (the `SectionHeader` master sits at x 720, y 8400); one horizontal row of light sheets at y 8760 (x 0, 1360, … 6800 core; step 04 x 8160 – 14960; shells x 17760 / 19448 / 21248; Home 24008; S10 25368; S11 26728 / 28088; S13 / S14 29448; S15 30808; Summary 32168; Ticket 33528; Auth 34888; Garage 36248; Catalog 37608; Tracking 39016; Invoice & Review 40424; Notification & Settings 41832) and their dark copies below at y 12380, dark anchor y 12200 (a taller sheet pushes its dark copy lower: S13 / S14 y 14200, Summary y 12900, Garage y 13270; the Home, S11 and S13 / S14 sheets still overlap their dark copies, known since steps 05 – 08).
- **Flows = one band per screen (step 19, 2026-09-25).** Replaces the old Flows – Phone / Flows – Tablet stacks and the x 37,000 lanes of steps 16 – 18 (they no longer exist; every frame kept its node id, name and overrides). Anchor `Section / 03 Flows` at y 15,960; bands start at y 16,500 at x 0, ordered S01 → S26, 640 dp apart. A band is **one horizontal line of clusters**: Phone light → 240 → Phone dark → 480 → Tablet-Portrait (light + dark side by side) → 480 → Expanded 1024×768 (S11, S13, S15, S16 only) → 480 → Tablet-Landscape (light + dark). Each cluster keeps its row header (`Row Header / S## Name · Phone | Phone · Dark | Tablet-Portrait | Expanded | Tablet-Landscape`) at the band top; the frames start 40 dp below the tallest header of the band; `Handoff Notes` wrappers and Fold Markers travel with their cluster (Fold Markers at x −220, 800 dp below the phone frame tops of S05 / S10 / S11). New screens or states go into their band, extending the cluster to the right; cluster x offsets below are the frame origins.

  | Screen | Band top y | Band width | Phone | Phone · Dark | Tablet-P | Expanded | Tablet-L |
  |---|---|---|---|---|---|---|---|
  | S01 | 16,500 | 7,984 | 0 | 1,904 | 3,184 | – | 5,344 |
  | S02 | 18,628 | 8,184 | 0 | 2,344 | 3,384 | – | 5,544 |
  | S03 | 20,734 | 8,184 | 0 | 2,344 | 3,384 | – | 5,544 |
  | S04 | 22,840 | 8,624 | 0 | 2,784 | 3,824 | – | 5,984 |
  | S05 | 24,968 | 16,392 | 0 | 4,472 | 6,192 | – | 10,572 |
  | S06 | 27,383 | 9,040 | 0 | 3,200 | 4,240 | – | 6,400 |
  | S07 | 29,898 | 10,884 | 0 | 2,344 | 3,384 | – | 6,424 |
  | S08 | 32,026 | 12,128 | 0 | 4,948 | 5,988 | – | 9,028 |
  | S09 | 34,154 | 9,084 | 0 | 2,784 | 3,824 | – | 5,984 |
  | S10 | 36,432 | 20,352 | 0 | 5,352 | 8,392 | – | 14,532 |
  | S11 | 38,560 | 34,424 | 0 | 7,600 | 12,400 | 21,180 | 23,144 |
  | S12 | 41,244 | 13,248 | 0 | 5,828 | 7,108 | – | 10,148 |
  | S13 | 43,891 | 16,964 | 0 | 2,640 | 4,680 | 8,660 | 10,164 |
  | S14 | 46,296 | 11,800 | 0 | 3,040 | 4,680 | – | 7,760 |
  | S15 | 48,446 | 24,280 | 0 | 7,076 | 9,676 | 15,036 | 17,000 |
  | S16 | 50,596 | 24,884 | 0 | 7,040 | 10,960 | 17,100 | 19,064 |
  | S17 | 53,262 | 10,188 | 0 | 3,188 | 4,468 | – | 7,088 |
  | S18 | 55,390 | 15,876 | 0 | 5,756 | 7,916 | – | 11,416 |
  | S19 | 57,528 | 10,424 | 0 | 3,260 | 4,300 | – | 6,920 |
  | S20 | 60,574 | 10,280 | 0 | 3,300 | 5,020 | – | 7,180 |
  | S21 | 63,358 | 8,960 | 0 | 2,420 | 3,700 | – | 5,860 |
  | S22 | 65,836 | 6,280 | 0 | 2,860 | 4,140 | – | – |
  | S23 | 68,476 | 10,400 | 0 | 3,440 | 4,720 | – | 7,760 |
  | S24 | 70,696 | 12,240 | 0 | 3,440 | 4,720 | – | 6,880 |
  | S25 | 72,938 | 9,920 | 0 | 3,200 | 4,240 | – | 7,280 |
  | S26 | 75,066 | 9,440 | 0 | 3,600 | 4,640 | – | 6,800 |

- **Row header legibility (step 19).** `SectionHeader` (`kcsFb`) now has a `surface-card` panel (stroke `border-subtle`, `radius-lg`, padding 20), so its dark `text-heading` / `text-body` read on a dark or a light canvas; the three Fold Markers got the same pill fill. Before, the headers had no fill and their tokens (resolved in the root's light theme) were dark on a dark canvas. Step 19 also moved the stray `S06 Notifikasi / All Read / Phone` (`WiPuS`, was at y 0) into its phone cluster.
- Use `FindEmptySpace` for placement; never overlap root objects.

### Variables & themes
- Theme axis `mode: light | dark`. Primitives = plain color variables (`orange-500` …). Semantic tokens = themed variables named exactly like the PRD 02 table (`bg-page`, `surface-card`, `accent`, …). Number variables for spacing/radius/font size; string variable `font-family` = `Exo 2`.
- A dark frame is a `Copy` of the light frame with `theme: {mode: "dark"}` — never re-styled by hand.
- Only variables and components: **no raw hex** in fills/strokes/effects, no detached instances.

### Screen frames
- Fixed width per breakpoint (360 / 800 / 1280); height `fit_content(<device height>)`; `clip: true`; `placeholder: true` while building, cleared as soon as the frame is done.
- Android system chrome: status bar 24dp + gesture-nav inset 24dp (deliberately replaces the Pencil mobile guide's iOS 62px — **confirmed 2026-09-23, step 02**; built as reusable `System / Status Bar` and `System / Gesture Bar` in the step 02 Spacing & Layout board).
- Frame naming (PRD 02 + theme suffix): `S11 Detail Servis / Default / Phone`, `S11 Detail Servis / Default / Phone · Dark`, `… / Tablet-Portrait`, `… / Tablet-Landscape`. Every node has a human name; no "Frame 12".

### Window size classes
- PRD 06 originally said breakpoints are evaluated on `shortestSide`, but its layout table gives tablet-landscape different layouts than tablet-portrait — impossible if both have shortestSide 800. **Decided 2026-09-23 (`prd/06` updated in step 01):** *device type* (phone vs tablet, orientation lock) uses `shortestSide ≥ 600`; *layout class* uses **width** (Material 3). So 360 = compact, 800 = medium, 1024 = expanded, 1280 = large.

### Frame matrix rule
- Light: every required state × 3 breakpoints, except where PRD 06 says the layout is identical across breakpoints (dialogs, sheets, centered forms) — then one tablet frame suffices; the step's matrix marks these explicitly.
- Dark: every P0 state on phone + the default state on both tablets. P1 dark: default state on each breakpoint.
- Stress frames (P0 dense screens only): 360×640 small phone and text scale ×1.3, per PRD 06.

### Components & variants
- Names use the `Ts` prefix = Flutter widget name (PRD 02: one Figma component ↔ one Flutter widget).
- Pencil has no variant properties. Convention: every variant combination that a screen uses is its own reusable frame named `TsButton / Type=Primary, State=Default` (Figma "Property=Value" style, so step 20 can regroup into component sets). Spec-only states (pressed, focused…) may be `ref` overrides on the component sheet — the step's Open questions confirm this per component family.
- Pencil has no text styles: the type scale is built as reusable text nodes on the Type board (`Type / Headline Large` …) plus number variables, so step 20 can create Figma text styles from them.
- Icons are `icon` nodes, `library: "Material Symbols Rounded"`, 24dp default, weight 400; filled variant for selected state where the library supports it.
- **Late additions:** a component or variant discovered inside a screen step is built in that step, placed in the `02 Components` row, listed in the step's *Components built here* table, and appended to *Inventory additions* below. It is never redrawn inline.

### Annotations
- `note` nodes beside frames for motion (150 / 250 / 300 ms, reduce-motion behavior), interaction, sticky/scroll behavior, keyboard behavior, and semantics labels for icon-only controls — handoff for Flutter and for the Figma prototype.

### Automated checks (run inside `execute` every step)
- Clipping: `Get(screen, (n,c) => c.problems && Print(n.name, c.problems))` → zero rows. Run it in a **separate `execute` call** from the inserts: bounds read in the same call are stale and report false "clipped" rows (seen on Cover and Demo Content). Nodes named `Decor …` (intentional bleed) and generated-illustration paths (raw palette hexes) are exempt from the clipping and raw-hex audits.
- Raw-hex audit: any fill/stroke/effect color not starting with `$` → zero rows.
- `TakeScreenshot` per finished section as review evidence.

### Exports
- After approval: `Export(frames, "png", "./design/pencil/exports/stepNN")` — review record and later Flutter pixel-diff source (assessment M2).
- **Verified in step 01:** the output path resolves from the **project root** (not the `.pen` folder), so it must include `./design/pencil/`; files are named `<nodeId>.png` (not the frame name) at scale 2 by default. Every export folder therefore also gets an `INDEX.md` (`nodeId | frame name`) so drift checks and the Figma comparison can match by name.

### Pencil facts (verified in step 01 smoke tests, 2026-09-23)
- **Type units:** `letterSpacing` is in **px** → `px = em × fontSize` (PRD `−0.025em` at 22 → `−0.55`; `+0.025em` at 14 → `0.35`). `lineHeight` is a **multiplier of fontSize** → `lineHeight = PRD line-height px ÷ fontSize` (44/36 → `1.2222`); Exo 2's built-in default ≈ 1.35.
- **Fonts:** Exo 2 renders at weights 400 / 600 / 800 (distinct widths). `fontWeight` is a string (`"600"`).
- **Themes:** `SetVariables` themed values accept variable references (`"$sand-50"`) and hex with alpha; a `Copy` with `theme:{mode:"dark"}` re-resolves every bound fill and text. Semantic tokens bind to primitives, so a primitive change flows through both themes.
- **Icons:** Material Symbols Rounded works (`home`, `history`, `two_wheeler`, `person`, `notifications`, `arrow_back`, `arrow_forward`, `check`); `weight` 100–700 changes stroke. **No filled variant** (no FILL axis) → selected/active state = weight 700 + `accent` color (+ indicator pill), never filled-vs-outlined.
- **`note` nodes:** take no `fill` and ignore `fontFamily`; they render as a yellow monospace sticky. Fine as handoff annotations, not part of the visual design.
- **Effects:** two-layer outer shadow with negative spread renders as specified; `background_blur` 14 + white 42% tint gives an acceptable frost (no `saturate` — documented gap). Effect colors are alpha-hex; `glass-tint` / `glass-border` become themed variables in step 02.
- **Components:** `reusable` frames + `ref` instances; overrides by unique child name or id; a nested override uses `instanceChildId/innerChildId` (verified). A `Copy` of a reusable node makes an instance, so a second variant is built as its own component.
- **Generated SVG:** `Generate(frame,"svg",prompt)` finished in a few minutes and returns ~30 vector children with **raw palette hexes** — not theme-aware (its beige backdrop stays light in dark mode). Screens that show it in dark mode need a light tile behind it or a dark-safe variant; decided in step 03. After every generation, snap all fills/strokes to the nearest palette token (script proven on the step 01 sample: 32 nodes, max RGB shift 28) — the generator ignores palette hexes in the prompt (20 raw hexes, none in the palette).
- **Effects and variables (schema):** `effect` fields (`radius`, `blur`, `spread`, `offset`, `color`) accept variable references (`NumberOrVariable` / `ColorOrVariable`), so shadows and glass are token-bound; step 02 builds `shadow-*` and `glass-*` variables (blur radius `glass-blur` = 28 for PRD `blur(14px)`).
- **Verified in step 02 (2026-09-23/24):**
  - **Inner shadows are not honored.** `effect: {type:"shadow", shadowType:"inner"}` is stored and drawn as `outer` (checked by reading it back and by render). Emulate a 1px inset highlight with a 1px `rectangle` child (`layoutPosition:"absolute"`) instead; the glass sheen uses this.
  - **Variables bind** to `fill`, `stroke`, `cornerRadius`, `gap`, `padding`, `fontSize`, `lineHeight`, `letterSpacing`, `fontWeight`, and to shadow `color` / `blur` / `spread` / `offset.y` and `background_blur.radius`. **`width` / `height` do not accept a variable** (`"$spacing-4"` is coerced to 0): use literal sizes, or `fill_container`.
  - **Reusable text nodes work** (`reusable: true` on a `text`), so the type roles are `Type / <Role>` components. Reading them back elides defaults (weight 400 and tracking 0 are omitted).
  - **Icon names:** `Insert` prints an `issues detected` list for names missing from the set. `expand_more`, `expand_less` and `local_offer` do not exist; use `keyboard_arrow_down`, `keyboard_arrow_up`, `sell`.
  - **Copying a board that holds reusable children** creates instances (`ref`) of the originals, not duplicate masters, but the refs come back **unnamed**; name them after the master (`<master> (instance)`). A `Copy` with `theme:{mode:"dark"}` re-resolves the whole board.
  - **Screenshots of large nodes are downscaled** (~400 px); screenshot a small sub-node (a row, a chip group) to inspect detail. Same-call bounds are stale, so run clipping checks in a later call.
  - **`Get(id, visit, {resolveVariables:true, resolveInstances:true})`** returns resolved colors inside instances and themed frames, which makes a per-node contrast audit possible (step 02: 1,089 text nodes).
  - `Decor …` bleed shapes (e.g. the Glass backdrop blobs) are exempt from the clipping audit by name.
- **Script gotcha:** globals created by destructuring (`[a,b]=fn()`) do not persist between `execute` calls; capture ids with plain assignments. **Step 03 found that even plain-assigned globals were undefined in the next call** (`ReferenceError: 'sheetBtn' is not defined`): read the ids from the previous `Created nodes` list and pass them as literals.
- **Verified in step 03 (2026-09-24):**
  - **Absolute `fill_container` children collapse a hug parent** ("circular sizing"): an overlay layer (`layoutPosition:"absolute"`, `width/height:"fill_container"`) inside a `fit_content` button zeroes the button. Use literal sizes for absolute layers, or avoid them (pressed = a fill token, loading = a fixed-width master).
  - **Disabled (`enabled:false`) nodes report `fully clipped`** in the clipping check: ignore any node whose ancestor chain has `enabled:false`.
  - **`note` nodes size themselves from their text but their row does not reflow after an edit**: set an explicit `height` (read from bounds) on the note.
  - **A row overflows its sheet silently when a cell is added**: re-read the row width against the 1104 dp content width and split into a second row.
  - **Screenshots of sub-nodes have no backdrop**, so translucent dark tokens (16 % orange) look light in a dark copy; verify by reading the resolved value.
  - **`Get(root, visit, {resolveInstances:true})` ids are `instanceId/childId` paths** that `Update` accepts, which is how per-instance copy overrides are edited (update masters first, then the leftover paths).
  - Text-field-like variants work as separate masters plus `enabled` slots (`Prefix`, `Leading Icon`, `Suffix Icon`, `Helper`, `Error Row`, `Counter`); a slot's `descendants` key is the node name, unique inside the master.
- **Verified in step 04 (2026-09-24):**
  - **Screenshots taken in the same `execute` as the inserts come back blank (or stale)**; take them in a later call. Same for `ctx.problems`: a clipping check run right after a big insert reported 133 false rows and was clean one call later.
  - **`fill_container` text inside a hug parent is flagged "circular"** when the parent's only definite size comes from an instance (`Card Cell Long Name`): give the parent an explicit `width`.
  - **Gradient stops accept variables, alpha does not**: a fade to transparent needs its own alpha token (`bg-page-clear`). `rotation: 270` runs a linear gradient left → right.
  - **`Move` keeps ids**, so instance overrides keyed by name or id survive re-parenting a node (used to move disabled reason badges into their own row); a ref accepts root-level overrides (`stroke`, `width`, `opacity`), and nested overrides use `instanceChildId/innerChildId`.
  - **A generated SVG is a flat pile of unnamed `path` / `ellipse` nodes** (3 for matic, 31 bebek, 71 sport) with fixed grays and a `#ffffffb3` backing rectangle: delete the rectangle, snap every fill by luminance to two or three tokens, and scale `x / y / width / height` to derive a smaller size.
  - **No stroke dash**: a dashed line is a row of small rectangles with `space_between`. **`event`, `group_off`, `sell`, `oil_barrel`, `qr_code_2` exist** in Material Symbols Rounded; `expand_more` still does not.
  - **Note nodes are not exported to `html-css`**, so handoff notes never reach html2figma (the HTML is about 400 – 600 px shorter than the sheet).
  - **`Copy` of a sheet holding reusable children again yields unnamed refs**; rename them after their master right after the copy. Deleting and re-copying the dark sheets is the reliable way to refresh them after light-sheet edits that add or move nodes (master edits flow through by themselves).
- **Verified in step 05 (2026-09-24):**
  - **Slots work for screens.** A reusable frame with `slot: []` is filled with `Replace(instance + "/<slotId>", {type:"frame", …})` and `Insert` into the returned id; the instance `height` is overridden and an absolute child moves with `Update(instance + "/<childId>", {y})`. Absolute children cannot anchor to the bottom, so a taller screen needs that `y` override. Pencil keeps warning "fill_container … not inside a flexbox layout" on the slot; it is spurious (render and bounds are right).
  - **"Collapsed size / circular" warnings on a hug parent with one `fill_container` child are false positives** when a sibling has a definite or hug size (equal-height card rows, quick links): bounds read back correct (`Get(..., c.bounds)`). Avoid it only if every child fills.
  - **A hard-stop gradient (two stops at the same position) draws a crisp boundary**, so a progress fill needs no pixel width (`FleetProgress`).
  - **`Update(ref, {descendants})` merges** with the existing overrides. `Replace` on a nested ref inside a master threw (`reading 'type'`); `Delete` + `Insert` into the parent works when the node is the last child.
  - **Emoji in a text node renders as a monochrome glyph** (the text `fill` applies); it is not tofu.
  - **`note` height:** after a content edit the auto height changes but an earlier explicit `height` may stay stale; re-read the bounds and set it again. A `Copy` made before a note edit keeps the old text: delete and re-copy the dark sheet.
  - **Copying an instance keeps slot content and names**; a dark `Copy` re-resolves everything. A text ×1.3 stress copy = `Get(copy, visit, {resolveInstances:true, resolveVariables:true})` + `Update(id, {fontSize})` per text node (47 nodes), then re-measure the body.
  - **Root listing:** `Get(document, (n, c) => c.depth === 0 && …)` lists root nodes; `Get(document, {depth:1})` without a visitor is refused.
- **Verified in step 06 (2026-09-24):**
  - **New token `scrim`** (light `#1A171666`, dark `#000000A6`): the dim layer behind a modal. A dialog-in-context frame = a `Copy` of the screen + an absolute `Dialog Overlay` (`fill: $scrim`, **literal** width and height, the dialog centered). The overlay height must be updated whenever the frame height changes.
  - **Swapping a component's sub-instance in an override:** `descendants: { <child id>: {type:"ref", ref:<other master>, name:"…"} }` replaces the `Silhouette` in a `VehicleSelectCard` instance (keep `opacity` on disabled cards); text by the master child ids; a nested path such as `"dK9ED/zZjKm"` reaches a button label inside an `EmptyState`.
  - **Equal-height card rows:** give the shorter card `height: fill_container` and leave the taller one hug; Pencil's "circular size" warning is a false positive (bounds read back correct). Both `fill_container` would collapse.
  - **`note` nodes must sit inside a frame**, never at the document root (wrap them; set an explicit height after reading the bounds).
  - **Text ×1.3 stress copy on a frame that holds refs:** `Get(copy, visit, {resolveInstances:true, resolveVariables:true})` + `Update(id, {fontSize})` per text node scaled every text (31 nodes) in one call, including text inside instances.
  - The checkbox `check` icon is `enabled:false` in unchecked states and reads as a contrast failure (1.0 : 1) unless the audit skips nodes whose own `enabled` is false.
- **Verified in step 07a (2026-09-24):**
  - **`execute` globals do not persist, not even a function assigned without `const`** (`typeof scr` is `undefined` in the next call): a frame builder is pasted into every call that needs it, and every screen state of that call is built in one go.
  - **`descendants` accept unique node names as keys** (`"Service Name"`, `"Estimate Total"`, `"Reason Label"`), so screen builders need no per-master child ids; nested overrides use `instanceId/innerInstanceId/leafId` (`DwnMr/Aoz0Z/UwQph` edits the text inside a text field inside a section instance).
  - **A scrolled viewport** = a clipped `layout: "none"` frame with a child frame at a negative `y` (keyboard state) or negative `x` (unit tab row). The clipping audit reports the child as "partially clipped": exempt by name (`Chips Track`, `Scrolled Content`).
  - **Overlays on full-scroll captures:** a `scrim` rectangle covering the whole capture, with the sheet / dialog placed in the top 800 dp viewport; transient snackbars float 8 dp above the sticky bar.
  - **Icon names:** `remove_circle`, `remove_circle_outline`, `delete_outline`, `brake_alert` are **not** in Material Symbols Rounded and render "?" without an `issues detected` warning when set through a `descendants` override; `do_not_disturb_on`, `person_remove`, `content_copy`, `chevron_right`, `keyboard_capslock`, `backspace`, `keyboard_return`, `album`, `bolt`, `build`, `tire_repair`, `edit_note` exist.
  - **Primitives are not theme-aware** (`sand-200` stays light in a dark copy): only semantic tokens go on surfaces, including design-only blocks such as the keyboard.
  - **`Replace` on a ref inside a `Copy`** works (used to swap `ComplaintSection` for the Typing variant in the Long Content frame); a fixed-height text field grows with `height: "fit_content"` as an instance override.
  - **Contrast audit script** (walk `ctx.parentCtx`, composite fills from the outside in, WCAG ratio on resolved values, skip `enabled: false` chains, glass bar, skeletons and scrim-covered content): 783 text + icon nodes over the 21 S11 phone frames, 0 failures.
  - **Dark copy of a sheet holding masters** again yields 18 unnamed refs; renamed with a loop (`<master name> (instance)`).
- **Verified in step 07b (2026-09-24):**
  - **`TakeScreenshot` and `Export` take arrays** (`TakeScreenshot(["id"])`, `Export(ids, "png", dir)`); a bare string fails with "First argument … must be a non-empty array". No `await` (a plain call).
  - **`StickyEstimateBar` width override works** (`width: 720` on the ref, absolute child of the frame): the `fill_container` Main Row reflows, text column left, CTA right, no wide master needed. Glass pill = floating over the form; content scrolls under it.
  - **Instance overrides by unique node name** reach deep parts of a copied phone form (`"Completion Badge": {enabled: true}`, `"Badge Label"`, `"Reason Label"`, `"Estimate Caption"`, `"Estimate Total"`, `Nickname`, `"Plate and Status"`); the wide stepper's `Completion Badge` is `enabled:false` in the master and is switched on per instance.
  - **A clipped `layout: "none"` viewport with a form at negative `y`** gives a scrolled tablet form (`Form Viewport` › `Scrolled Content`, exempt by name); a hug row that must center or start needs `justifyContent`, not `x`.
  - **Copying a phone `Unit Form` into a tablet frame** (`Copy(id, parent, {width, padding})`) keeps every instance and override, so tablet content cannot drift from the phone; the chips are copied refs in a plain row, the rail is rail-row refs with text overrides.
  - **Dark copy of a sheet holding refs** again yields unnamed refs (6 here); the step's dark sheet was deleted and re-copied after the review fix (`Delete` + `Copy`) and renamed with a loop.
  - **Stress ×1.3 on a copy** = `Get(copy, visit, {resolveInstances:true, resolveVariables:true})` + `Update(id, {fontSize})`: 64 text nodes including the hidden disabled reason rows.
  - **Audit output size:** a raw-hex script that also visits `resolveInstances` sees primitive palette hexes inside generated art and floods the response (3,192 rows in the phone group); audit hex with `Get` **without** `resolveInstances`, and print counts, not rows.
  - **07a bug class:** a state frame must use the bar variant that matches the gate (`CTA Disabled` whenever any chip is not ✓): check `StickyEstimateBar` refs against the chip states with one `Get`.
- **Verified in step 08 (2026-09-24):**
  - **An override object spread into `Insert` can drop a `descendants` key:** `{type:"ref", …, descendants:{…}, ...ov}` with `ov.descendants` lost the `Chosen Tag` override in a loop (the same key worked in a plain `Insert`). Set slot overrides with `Update(refId, {descendants:{"Chosen Tag":{enabled:true}}})` after the insert and read the ref back (`Get(id, {depth:0})`); `Update` merges with the existing overrides.
  - **Unique-name overrides reach three levels of nesting:** `"Workshop Photo/Initials"`, `"Estimate Row"` (read back as `JgAjl/Vmy9S`), `"Label"` inside a nested button, `"Map Canvas"`, `"Pin"`, `"Static Map"` all resolved by name on a `WorkshopDetailContent` instance. A whole nested block can be swapped in the override: `"Workshop Info": {type:"ref", ref:<closed variant>, descendants:{…}}` (used for the Closed frame).
  - **A token-bound map is a clipped `layout:"none"` frame with a larger `Map Canvas` child** (768×432 of rectangles, one rotated road, labels); instances change the crop by overriding the canvas `x / y` and the absolute `Pin` `x / y`; `Map …` names are exempt from the clipping audit. `rotation` works on rectangles.
  - **`WorkshopCard` slots:** new `enabled:false` children (`Estimate Row`, `Chosen Tag`, `Preview Chevron`) added to existing masters do not change the step 04 sheets; a frame in a hug row can use `height:"fill_container"` (the chevron) — Pencil's "not inside a flexbox layout" warning on disabled or hug-row children is spurious again.
  - **`Copy` of a non-reusable frame keeps the ref names** (0 unnamed refs after 8 copies, unlike sheets that hold masters); a dark sheet of masters yielded 21 unnamed refs, renamed with a loop.
  - **`Replace` on a ref inside a copied frame** works for pane content (`Scrolled Content`, `WorkshopCtaBar`), used to turn the S13 Tablet-L Populated copy into the S14 Loading frame.
  - **Audit script for gradients:** composite fills from the outside in; for a gradient ancestor evaluate every stop (`Photo` gradient); siblings do not count as a background, so text on a sibling shape (map road label) is measured from the tokens by hand (`GetVariables()` resolved per mode).
  - **Static-map decoration must not borrow status tokens:** the first park (`success-soft` / `success-text`) was replaced by a neutral block; a green hue on a non-status shape reads as "open / OK".
  - **A 5,300 dp component sheet cannot share the y 12380 dark row**; the dark copy went to y 14200. The S11 sheets already overlap their dark copies by ~282 dp (step 07a).
- **Verified in step 09 (2026-09-24):**
  - **`Get` without `resolveInstances` returns instance `descendants` keyed by node ids** (`gUTUy`), not by the unique names used to write them; an audit that reads overrides by name (chip caption, footer counter) must use `resolveInstances: true`, and then identify a chip by fill / stroke tokens (`$warning-soft` = limited, `$surface-inset` + `$border-default` = short, `+ $border-subtle` = full, `$accent-soft` = selected).
  - **A raw-hex audit must not use `resolveVariables`** (every token resolves to a hex: 5,730 false rows). Audit hex with a plain `Get` (0 of 1,020 nodes) and print counts.
  - **Float-epsilon "partially clipped":** three fill-container chips at `221.333…` (or `400.00000000000006 + 48`) overflow their row by 1e-13 and are flagged; read the exact bounds before treating it as clipping.
  - **A slot master with no children collapses and warns** ("Collapsed size"): give the slot a default child (the `UnitSlotSection` Expanded master holds a `DateStrip`); screens replace it with `Replace(instance + "/<slotId>", …)`, which also takes new padding / gap.
  - **Chip captions wrap only if the status row fills its parent**: `SlotChip` needs padding [8, 6], `Status Row` `fill_container` and a fixed-width fill text; at text ×1.3 "Sisa 2 motor" wraps to two lines instead of clipping (chips 99 – 104 dp, 3 per row).
  - **A frame builder driven by one `stateOf(left, units, selected, past)` function** kept 189 chips consistent with the slot table; the audit re-derives the same states from the tokens.
  - **Restructuring a node in place:** `Insert(parent, row)` + `Move(row, parent, 0)` + `Move(title, row)` put a header row around an existing title in six frames without touching ids; `Update(id, {y: y + 3000})` over a root list moved 72 nodes.
  - **`note` height:** the height read back after insert (384 / 342 / 426 …) differs from the height passed in; set the explicit height from the bounds.
  - **Focus specimens** (no focus layer in `SlotChip`, `DateStripItem`, `DateGridCell`, section header, toggle): a wrapper frame with padding 4, `stroke: $focus-ring` width 2 inner, radius = inner + 4, holding an instance of the master; the component keeps its own border.
  - **Disabled switch check glyph** measures 2.37 : 1 (light) / 1.89 : 1 (dark) and is exempt as a disabled control; state also reads from thumb position and track.
- **Verified in step 10 (2026-09-24):**
  - **`descendants` keys accept name paths** through two levels (`"Part Line 1/Label"`, `"Total Row/Value"`, `"Banner Action/Label"`, `"CTA/Label"`, `"Note Row/Note"`), so a frame builder needs no node ids; `Update(ref, {descendants})` merges.
  - **`Move` keeps ids and instance overrides:** wrapping an existing child in a new `Action Row` inside a master (`CapacityBanner` Warning) changed no instance; S15 banner heights were identical before and after (146 / 100 / 124 / 124 dp).
  - **`Get(..., {resolveInstances:true})` returns instances as plain `frame` nodes** (no `ref`, no master id): read `n.ref` from a `Get` **without** `resolveInstances` (gate and master audits), and text overrides from one **with** it.
  - **A `fill_container` sibling collapses when the others are fixed:** the `ConfirmBar` Total Row in a horizontal `Main Column` shrank to 4 dp (label one character per line) beside a 280 + 280 dp reason and CTA; give it a width.
  - **A hug frame set to `width: fill_container` with fixed-width text wraps its label** (the `VoucherCard` `Reason Badge`), the fix for badges whose text can be long; the step 04 sheets inherit it.
  - **Master child swap:** `Delete` of the last child + `Insert` into the parent works inside a master (accordion chevron); the instances re-flow without new overrides. A focus specimen that wraps a deleted control is deleted by name.
  - **`note` auto height changes after a content edit** (four notes grew 42 – 147 dp): re-read the bounds and set the explicit height again.
  - **Equal-height grid rows:** the shorter card gets `height: fill_container`, exactly as in step 06 (84 / 106 → 106 / 106).
  - **Contrast audit script at scale:** composite ancestors' resolved fills outside in, skip `enabled:false` chains and `Skeleton …`; 2,490 text + icon nodes over 39 frames and 2 sheets in one call. It found two pairs a visual check missed (a 4.38 : 1 `text-accent` on `warning-soft`, a 4.44 : 1 dark `text-muted` on `warning-soft`): a tinted status surface changes the pair for every muted / accent text placed on it.
  - **A text-scale stress copy** (`resolveInstances` + `resolveVariables`, `fontSize × 1.3` per text node) scaled 63 nodes in one call.
  - **`TakeScreenshot` of a full-scroll phone frame (1,400 – 1,800 dp) is too small to judge:** screenshot its sub-nodes (`Units Column`, `Estimate Block`, `ConfirmBar`).
- **Verified in step 11 (2026-09-24):**
  - **A real, scannable QR is buildable:** compute the matrix outside Pencil (`segno` in a scratchpad venv, Version 1, ECC Q, 21 × 21), then draw one `rectangle` per horizontal run of dark modules inside a `layout: "none"` tile (114 / 127 rectangles). Bind tile and modules to **primitives** (`sand-0` / `sand-900`), which stay dark-on-light in a dark copy (resolved `#FFFFFF` / `#1A1716`). Proof = `Export(ids, "png", dir)` and an OpenCV `QRCodeDetector` decode of the PNG: 7 of 7 read back (light, dark, tablets, ×1.3, the 5-unit specimen).
  - **`Export` accepts an absolute directory** outside the project (scratchpad), useful for throw-away proof exports.
  - **Swapping a master's last child** (icon → `QrCode` ref) and wrapping an existing text in a new row (`Insert` + `Move(row, parent, 1)` + `Move(text, row)`) both left every existing instance intact; a new `enabled:false` child (`Slot Line`) does not change the step 04 sheets.
  - **Inside an instance,** `Replace(instanceId + "/<childId>", {type:"frame", …})` followed by `Insert` into the returned id swaps a block (the 5-row `Units Block`); a nested ref can be swapped by name in `descendants` (`"QR Code": {type:"ref", ref:<other master>}`); a fixed-width perforation is stretched by overriding the ref `width` and the notch `x` (`"Tear Line 1/Decor Notch Right": {x: 548}`).
  - **Hug text does not wrap:** a `Workshop Row` whose text is a hug child overflows a long name at ×1.3 (the clipping check does not flag text overflow, the screenshot does); the row and the text need `fill_container` + `textGrowth: "fixed-width"`. Found only by the ×1.3 copy.
  - **A skeleton line wider than its row** (200 in a 180 dp text column) is reported "partially clipped": size skeleton lines to the narrowest row.
  - **Contrast script bug class:** composite the background from `c.parentCtx` upward, not from the node itself, otherwise the text fill becomes its own background and every pair reads 1.00.
  - **Side-by-side columns of different height** (Tablet-L ticket vs status panel) need a `Content Group` with `alignItems: "start"` and a top padding on the shorter column; centering each column independently leaves stray tops.
  - **A fixed 800 Loading frame** clips a skeleton ticket that is taller than the viewport minus the sticky footer; the Loading state is a full-scroll capture like the populated ones.
- **Verified in step 12 (2026-09-24):**
  - **Fresh inserts can render blank and measure wrong for a while.** After a long build call, every non-`Copy` node (a rectangle, text, frame, even a `SectionHeader` ref) came back as a blank screenshot and its bounds were shifted +50 dp in y; the same nodes rendered and measured correctly after a `get_app_state` call and one more `execute`. Call `get_app_state` (or wait one call) before screenshotting or measuring fresh inserts; do not rebuild.
  - **`execute` can fail with `InternalError: interrupted`** on a heavy scan (whole-document `Get` with `resolveInstances` over all 202 P0 frames); everything in the call is rolled back. Split the scan by screen group (3 – 4 calls) and re-run with `edits`.
  - **A shared type token is one change:** `SetVariables` on `type-label-sm-*` moved 2,608 nodes; literal overrides do not follow (a ×1.3 stress copy stores literal sizes: 126 nodes had to be re-scaled from 14.3 to 15.6, found with `resolveVariables` + `resolveInstances`). Re-scan for literal old sizes after any token change.
  - **A token change is a wrap test:** compare the count of text nodes with `height > line × 1.06` before and after (baseline ids), split into visible and `enabled:false` chains, and re-check hug rows. A fixed-width caption that fitted by 1 dp wrapped in the 99 dp split chips; the fix was structural (icon moved beside the time), not a smaller size.
  - **`Move` into a new wrapper inside a master keeps instance overrides keyed by leaf ids** (166 `SlotChip` instances unchanged after `Insert(master, Time Row)` + `Move(icon, row)` + `Move(time, row)`).
  - **JSON scan finds slot / override content that a visitor cannot:** `JSON.stringify(Get(id))` + `"ref":"<id>"` sees refs inside `descendants` overrides and slot content, `Get` with a visitor does not; instance text overrides are reached as `Update("<instanceId>/<childId>", {content})` using the ids printed by a `resolveInstances` scan.
  - **Unused-component analysis needs both:** component sheets hold an instance of every master, so "unused" means not reachable from a screen through masters (closure over the JSON refs); type roles, logo marks and spec-only states are expected unreachable.
  - **Copies of full frames** (`Copy(id, board, {x, y, name})`) keep every override and name, so a flow board of nine 360 × 837 – 1,477 dp frames is one call; the board root is a `layout: "none"` frame with absolute children.
  - **Contrast audit false positive class:** the `TsLogo` monogram (white on orange, 3.45 : 1 at 11 px) is a logotype and is exempt; skip `Monogram` in the audit and the < 12 sp scan.
- **Verified in step 13 (2026-09-24 / 25):**
  - **`Generate(svg)` can silently deliver nothing.** Four generations (nested in a sheet, a root frame, a plain root frame, a 120 px probe) left the frame empty and cleared its `placeholder` flag within one call, and nothing arrived after ~20 calls; `Get(frame).placeholder` is `undefined` both for "still running" and "failed", so it cannot be used as the progress signal. Wait ≈ 5 calls, then ask the user to check Pencil or fall back (component vignettes built from existing masters worked and needed no budget).
  - **A visitor `Get` over a frame that holds an instance whose slot was replaced** (`Replace(card + "/<slotId>", …)`, the `AuthCard` in the Tablet-P frames) throws `TypeError: cannot read property of undefined` (also from whole-document scans); pass `{resolveInstances:true}` for every audit script (clipping, contrast, naming). Rendering and bounds are unaffected.
  - **Fresh frames screenshot blank for 2 – 3 calls** (bounds already correct); re-screenshot in a later call, no rebuild (as step 12).
  - **Ref overrides:** `descendants: {"Page Indicator": {type:"ref", ref:<other master>}}` swaps a nested master per slide; `"CTA/Label": {content}` reaches a nested label; token-bound overrides such as `"Title": {fontSize:"$type-headline-lg-size", lineHeight:…}` restyle a master's text per breakpoint; `Update(refId, {descendants:{"Label":{fill:"$text-on-accent-soft"}}})` recolours by name.
  - **Absolute overlays are invisible to a parent-chain contrast audit:** the `Skip Row` (absolute, child of the frame) sits over the accent-soft art panel but its ancestors are only `bg-page`, so the audit passes falsely; check such overlays by hand (`Lewati` on `accent-soft`: `text-accent` 4.10 : 1 → `text-on-accent-soft`; `focus-ring` orange-500 on `accent-soft` = 2.92 : 1).
  - **Ghost `TsButton` indents 16 dp:** a link that must align with the text edge is a separate 48 dp `AuthLink` (zero side padding); inline links inside a sentence cannot be spans in Pencil, so the note is two lines (`TermsNote`).
  - **Adding sections to a sheet means re-copying its dark copy** (`Delete` + `Copy` with `theme:{mode:"dark"}`, then rename the 15 unnamed refs).
- **Verified in step 14 (2026-09-25):**
  - **Name paths resolve through nested refs:** `descendants` keys such as `"Nickname Field/Value"`, `"Suffix Icon/Icon"`, `"CTA/Label"`, `"Model Row/Value"` reach leaves two and three levels down (read back as `<refId>/<leafId>`). A nested `descendants:{…}` object inside a `descendants` entry is silently ignored: write the path key instead.
  - **Nested ref swap works for variants:** `"Model Field": {type:"ref", ref:<Error | Focused | Disabled variant>, descendants:{…}}` and `"CTA": {type:"ref", ref:<Primary Loading>, width:"fill_container"}` replace a field / button inside a `MotorForm` / `WorkshopCtaBar` instance. **But `Move` of a node inside a master drops the swap override of that node** (a `Status Badge` swap on a history row went back to the master badge; text overrides had to be re-applied with `Update`): give a state its own master (`ServiceHistoryRow / State=Cancelled`) instead of swapping a nested ref.
  - **Slot content is editable by resolved id:** `Get(frame, visitor, {resolveInstances:true})` lists the slot children of a shell instance, and `Delete` / `Insert` / `Move(id, parent, 0)` on those ids work (used to drop the list add card, remove a grid row and swap the app bar in six S07 frames and their dark copies). A `Get` without `resolveInstances` shows no slot content.
  - **A text ×1.3 throw-away copy finds what 1.0 hides:** a hug outline-compact button whose label (`Tambah foto (opsional)`) overflowed a 216 dp column, and a ticket code that broke beside a badge; both were structural fixes (shorter label + helper; badge moved to the date line). Delete every `TMP` copy: one scan for `name` starting with `TMP` at the root before closing.
  - **Row of `fill_container` cards beside a 1 dp spacer collapses** (the spacer is the only definite height): make the lone card `fit_content`; use `fill_container` only on the shorter of two real cards. A grid row that must keep the column width takes spacer siblings.
  - **`Copy` keeps `placeholder:true`:** clear it on dark copies and on frames built with a placeholder flag, then check with a depth-0 scan (`c.skipChildren()` at depth 0 also avoids the visitor `TypeError` on slot-replaced refs when only root nodes are listed).
  - **Reusing an effect:** `Get("<modal id>", {depth:0}).effect` returns the two-layer shadow array, so a new modal (`MotorModelPicker / Layout=Modal`) copies the exact shadow of `CopySourceSheet / Layout=Modal`; an absolute `rectangle` with `fill:"$scrim"` and a literal size covers a copied screen for a sheet / modal / dialog-in-context frame.
  - **Full-scroll capture on tablets:** a tablet frame can be taller than its viewport (S09 Tab-P 800 × 1,356) when the page scrolls; it is documented in the step file instead of squeezing content. Row header numbers show the **step** number ("14").
  - **Weekdays by script:** `new Date(y, m − 1, d).getDay()` confirmed the demo dates (Sen 28 Sep, Sel 29 Sep, Kam 10 Sep, Sel 14 Jul, Sab 2 Mei 2026) before they were typed.
- **Verified in step 15 (2026-09-25):**
  - **A whole-document visitor `Get(n => …)` throws `TypeError`** (slot-replaced refs, as in step 13) even for a plain "collect all masters" scan; read a master by id instead (`Get(refId, {depth:0}).name`). Renaming the unnamed refs of a dark sheet copy = loop over its refs and name each `<master name> (instance)` from `n.ref`; a parallel DFS of the light and dark trees does **not** align (masters become shallow instances).
  - **`TsCheckbox` and `TsIconButton` carry a built-in `Focus Ring` frame** (`enabled:false`): a focused specimen is `descendants: {"Focus Ring": {enabled: true}}`; other controls use the step 09 wrapper (padding 4, `focus-ring` 2 dp inner stroke, radius = inner + 4).
  - **Node names that contain " / " cannot be path keys** (`TsButton / Primary (confirm)` in `TsDialog`): read the resolved ids with `Get(instance, visitor, {resolveInstances:true})` and `Update("<instanceId>/<childId>", …)` (dialog title, body, both button labels, icon).
  - **A `Grid` tile widened by a `width` override keeps its absolute `Selection Mark` at the old x**: override `"Selection Mark": {x: width − 52}` on every instance (352 → 300, 296 → 244).
  - **A viewport crop of a full-scroll copy:** `Insert` a `layout:"none"` clipped `Scroll Viewport`, `Move` the old `Scroll Body` into it, rename it `Scrolled Content` (exempt by name), set `x/y 0` and `width`; the bar and gesture bar stay in flow below, under the scrim. Copying a full-scroll frame and forcing `height: 800` alone leaves the bar "fully clipped" in the audit.
  - **A scroll-overflow chip row** (`clip:true`, chips past the width, absolute `Scroll Fade` rectangle with `bg-page-clear → bg-page`) is flagged "partially / fully clipped" for the overflowing `TsChip`s: exempt by the parent name `CategoryChipRow`.
  - **`Copy(refId, document, {x, y, name, descendants})` clones a row-header instance and merges text overrides** (`Gpvrl` number, `YUYHZ` title, `Hd5hK` subtitle) in one call.
  - **Three 360 dp masters in one component-sheet row overflow the 1,104 dp content width** (3 × 360 + 2 × 24 = 1,128): gap 12 fits (caught by the clipping audit, not by eye).
  - **Note `height` again goes stale after an edit** (`m38edl` explicit 636, bounds 909): re-read the bounds and set the height again.
  - **Contrast script** (composite ancestors' resolved fills outside in, WCAG ratio, skip `enabled:false` and skeleton chains): 1,460 text + icon nodes over 17 frames and 2 sheets in one call, 0 failures.
- **Verified in step 17 (2026-09-25):**
  - **A rating star is a token-bound `path`** (`geometry` = Material 24-unit star, `viewBox [0,0,24,24]`, `strokeLinejoin: "round"`, `strokeWidth` 1.5 at 32 dp / 1.25 at ≤ 20 dp): filled = `fill` + `stroke` `$warning-text`, empty = `stroke` `$border-control` only; a **half star = the empty star + a clipped half-width frame** (`clip: true`, `width: size / 2`) holding the filled star. `stroke` takes a plain color / variable string (`{fill: …}` is rejected). Material Symbols `star` has no fill axis, so the icon cannot show filled vs outline. The clip frame is exempt by name (`Half Clip`) in the clipping audit.
  - **A root frame built with `placeholder: true` and cleared in the same call kept stale child offsets (+50 dp) and rendered blank in light mode**; a `Copy` of its dark twin with `theme: {mode: "light"}` rendered correctly. Read the children's `c.bounds` once after building a root frame; a wrong y means copy it.
  - **`TsAppBar / Type=Back` action slot:** `descendants: {Actions: {enabled: true}}`, then `Update("<instId>/<Action 2 id>", {enabled: false})` and the icon of `Action 1` through the resolved path (`<instId>/xFVFI/rJ5Az`, `icon: "share"`). Icon names `share`, `payments`, `rate_review`, `event_available`, `schedule` exist.
  - **`TsButton / State=Loading` is spinner-only** (`Label` disabled, width 120): show the label with `descendants: {Label: {enabled: true, content}}`; inside a `WorkshopCtaBar` whose `CTA` was replaced by the Loading master, the label needs the resolved path (`<barId>/<ctaId>/<labelId>`).
  - **`WorkshopCtaBar` on a tablet:** `descendants: {PMZgP: {alignItems: "center"}, CTA: {width: 560}}` centers a 560 dp CTA under an 800 dp bar; the `ConfirmBar` tablet recipe (`QtGW7` horizontal, padding [12, 80], `W6y8Bg` and `rFGTX` 280) was reused from S16.
  - **Parallel sessions on one `.pen`:** a whole-document `Get(visit)` throws and `FindEmptySpace({direction: "bottom"})` returns the space under everything (−220, 133,186), so a lane is chosen by reading sheet bounds (`Get(id, visit)` → `c.bounds`) and placing right of / below them; `Copy` / `Insert` at fresh coordinates moved nothing (the other session's sheet bounds were identical before and after).
  - **A dialog on a full-scroll or tablet frame:** scrim rectangle sized to the frame + `TsDialog / Confirm Save` absolute at the viewport center; text and icon overrides go through resolved ids (`Get(dlg, visit, {resolveInstances: true})`, icon `save` → `payments`).
  - **Instance overrides swap a nested ref:** `descendants: {"Rating Stars": {type: "ref", ref: <other master>, name: "Rating Stars"}, "Rating Label/Word": {content}}` turns the Rated mechanic row from 4 to 5 stars without a new master; `Replace(node, {type: "ref", … descendants})` swaps a row inside a copied frame.
  - **The dark sheet is deleted and re-copied after every light-sheet edit that adds nodes** (a focus section added after the first dark copy); the unnamed refs are renamed `<master> (instance)` from `n.ref` (27 here).
- **Verified in step 16 (2026-09-25, rescue of the first build):**
  - **Root listing:** `Get(document, visit)` with `c.skipChildren()` at depth 0 lists the 575 roots (a full-depth walk throws); a per-root `Get(id, visit)` works for all but a few sheets. Two overlap checks are cheap and worth running after any layout work: a root-AABB script (only the 3 old component-sheet / dark-copy pairs remain) and a `Get(id, visit)` gesture-bar position check.
  - **`AppShell` slot content must be `height: fill_container`** (`Replace(refId + "/" + slotNodeId, {type: "frame", name: "Content", width: "fill_container", height: "fill_container", layout: "vertical"})`, S07 recipe: app-bar ref + `Scroll Body`). A hug slot frame (240 dp) leaves the shell's own Gesture Bar floating mid-screen; a re-`Replace` needs the *current* slot node id, not the master's.
  - **Gesture bar in full-scroll frames = absolute `y = H − 24`** (frames taller than 800 dp); a hug frame that shrinks below 800 after a content edit needs an explicit `height: 800`. **A bottom sheet is anchored at `y = 800 − h` with its own `Gesture Bar` ref as the last child** (24 dp inside the sheet); the frame's gesture bar is moved under the scrim (`Move(id, frame, indexOfScrim)`).
  - **`Move` into a deeper parent breaks instance overrides keyed by the node id** (they stop applying), and the stale id keys stay: a `TsChip` override `w8anv: {enabled: false}` hid the whole chip (it is the `Focus Ring Frame`). Capture each instance's `descendants` before restructuring a master, then re-apply by **unique node name** (`"Unit Name"`, `"Label"`, `"Leading Icon"`, `"Count Badge"`); replace stale refs with `Replace` so the old keys go away (65 `UnitStatusRow` instances re-keyed in one call).
  - **Removing a fill / stroke:** `fill: null` is invalid; use `{type: "color", color: "$token", enabled: false}` + `strokeWidth: 0`. Per-side strokes work: `strokeWidth: {bottom: 1}`. An instance accepts `strokeWidth: 0` as a root override (last row without a divider).
  - **Underline tab recipe:** tab = vertical frame, height 48, `Label Cell` (`fill_container` height, padding [0, 16], text `Label Large`) + 3 dp `Active Indicator` rectangle (`accent-fill`, radius [3, 3, 0, 0]); the inactive tab uses padding-bottom 3 so labels align; the row master gap 0; a scrolled row = clipped `layout: none` track (48 dp) with a 1 dp divider at y 47, the row at `x = −offset`, edge fades (gradient `rotation: 270`, `bg-page-clear` ↔ `bg-page`). Pencil warns "circular" for the hug tab with a `fill_container` indicator; bounds are right.
  - **Tablet Tab-P body:** a `Scroll Body` with `width: 720` in a vertical 800 dp frame is left-aligned; `width: fill_container` + padding `[8, (W − max)/2, 24, (W − max)/2]` centers it. A modal replaces the sheet header with the `Title Row` of `PartDetailSheet / Modal` (padding [16, 12, 4, 24], title block + close `TsIconButton`), radius-xl and the `shadow-md` pair.
  - **Icon overrides:** `descendants: {<iconId>: {name: "event"}}` only renames the node; set `icon` and `enabled`. `Copy` of a plain frame ignores a `descendants` map (edit the copied child with `Update`). `note` heights cannot be read once an explicit height is set: use ≈ `130 + 0.75 × characters` (min 219) and screenshot one.
  - **Contrast script** (composite fills outside-in, resolved values, skip disabled chains / skeleton / glass / scrim-covered underlay) ran clean on 1,837 nodes light + dark; literal `fontWeight` `600` / `normal` / `700` (71 nodes) were bound to `$font-weight-*` (700 is not a loaded Exo 2 face).
- **Verified in step 18 (2026-09-25):**
  - **A frame-level `theme: {mode}` on a nested frame renders inside a frame of the other theme** (`ThemePreview` stages: forced light inside a dark frame and the reverse). The mini app is tokens, rectangles and ellipses only, so no text falls under 12 sp. Whether html2figma keeps that per-frame theme is **not verified** (step 20).
  - **Root frames holding slot-filled `DemoPanel` instances came back with a 0.9157 dp child offset**, reported by the clipping check as "partially clipped" (Gesture Bar, Scroll Body, last panel). `Copy` + `Delete` of the original clears it (ids change). A section whose children were moved with `Move` kept stale y until a no-op `Update` of `gap` (25 → 24) forced a relayout.
  - **An instance cannot take children**, so a dialog / sheet / modal on an `AppShell` screen = a plain `layout: "none"` wrapper frame holding a `Copy` of the screen ref, a `$scrim` rectangle (literal size) and the dialog ref; the top-800 dp rule for full-scroll captures still applies (reset dialog centered at y 266 of 1,448).
  - **Override keys containing `/` are read as paths:** `"TsButton / Primary (confirm)/zZjKm"` did nothing; use the ids (`<dialogId>/w6MH4/zZjKm`, `Update` after the insert).
  - **Slot replacement through `descendants`** works with nested `ref` children that carry their own `descendants` (`DemoPanel` slot `qT6rD` → unit rows, buttons); a sub-instance swaps with `{type: "ref", ref: <master>}` (`Status Badge` → Diperiksa). `Replace(inst + "/<Action 1 id>", {type: "ref", …})` swaps an app-bar action for a ghost text button on a screen-level instance.
  - **`strokeWidth: {bottom: 1}`** works on a master (row dividers); `strokeWidth: 0` overrides it on the last instance of a card.
  - **Text ×1.3 stress found two real defects** the ×1.0 frames hid: an app-bar title wrapping beside a long action, and a two-button row overflowing a 296 dp panel. A row that must survive large text becomes a column (Flutter `Wrap`); a long text action does not belong in an app bar.
  - **`Get(document, visit)` and the whole-document `Get(visit)` throw** ("cannot read property of undefined"); audits iterate known root ids. `Get(id, …)` for a missing id throws "Can't find node" (transient ids in the `issues detected` list may already be replaced).
  - **Audit script** (composite fills outside-in, resolved values, skip disabled chains, `Screen ·` underlays, scrims, skeletons, `Mini` preview parts): 1,542 text + icon nodes, 5 fails = the logo monogram (3.45 : 1, exempt logotype); it found the selected `DemoUnitRow` (muted plate on `accent-soft` 4.36 : 1, badge 4.48 : 1 in dark) before the review.
- **Verified in step 19 (2026-09-25):**
  - **A root listing visitor must call `c.skipChildren()` for every node at depth 0**, not only for the nodes it collects; otherwise the walk descends into slot-replaced refs and throws `cannot read property of undefined`. A plain per-root `Get(id, visit)` throws for screens too: pass `{resolveInstances: true}` for every screen scan, plain `Get` is fine for sheets.
  - **`Update(id, {x, y})` over 546 root nodes in one `execute` is fine** (no interruption). A whole-canvas re-layout = read all roots once, assign every node to its row header (nearest header above with the same `S##` and x lane), compute cluster / band positions, then update: ids, names and overrides stay. Guard the write with assertions (header count, member count, empty cluster) so a bad model throws before the first `Update`.
  - **A master edit resizes every header** (`SectionHeader` +40 dp): anchors next to boards had to move up 40 dp, and the frame offset under a header is measured (tallest header + 40), never a fixed 186.
  - **Adding a `note` to a wrapper with no `layout` widens it** (S03 / S09 wrappers grew to 1,188 dp and hit the dark cluster); set the wrapper to `layout: "vertical"` before inserting. Note height ≈ 130 + 0.75 × characters at width 250, min 219.
  - **A hug row inside a master is a text-scale bug**: `VoucherRow` `Saving Row` (hug) overflowed at ×1.3; `width: fill_container` on the row and `textGrowth: "fixed-width"` + `fill_container` on the label fixed all 29 S16 frames from the master. Only a ×1.3 frame shows it.
  - **Instance children are toggled by resolved path**: `Update("<instanceId>/<rowId>", {enabled: true})` and `Update("<instanceId>/<labelId>", {content})` (found with `Get(frame, visit, {resolveInstances: true})`, id contains `/`) enabled the disabled `Reason Row` / `Helper Row` of 14 Loading footers without touching the masters.
  - **`SetVariables` merges**: passing only `focus-ring` and `rating-star` left the other 149 variables untouched; a themed value can reference primitives (`$orange-600`).
  - **Strokes: refs need their own `strokeAlignment`** when an instance overrides `stroke` at root level (16 focus specimens); frame / rectangle strokes without it export as CSS `outline`. `path` / `ellipse` strokes are SVG and exempt.
  - **Contrast at scale:** 386 frames, 17,013 text + icon pairs in 5 `execute` calls of 50 – 90 frames each (composite fills outside in, skip `enabled: false`, opacity < 1, `Skeleton`, `Glass`, `Scrim`, `Decor`, `Disabled`, `Photo`, `Map`, gradients). Clipping exemptions that were real scroll specimens: `(scroll)` names, `DateStrip`, `Tabs Track`, `CategoryChipRow`, `Scroll Body` crops in 800 dp frames.
  - **`Copy(source, board, {x, y, name})` into a `layout: none` board** clones a whole frame with overrides in one call; the `issues detected` list (fill_container not in a flexbox, collapsed size) was the known false positive.
  - **The scratchpad path is one string:** a `Write` to a mistyped scratch path creates a new directory tree; check the path against the environment block.
- **Unsaved file:** the document lives in Pencil's memory until the user saves (Cmd+S); Claude has no save tool.
- **Generated art internals** (the `rectangle` / `path` children of a generated SVG) are unnamed and exempt from the naming check; the wrapping frame/component is named.
- **Multiplayer:** nodes the user adds while Claude works appear at the root (at step 01 close: 8 unnamed, paste-like nodes; the user told Claude to delete them at step 02 kickoff and they were removed after an id/type/position re-check). Claude never deletes nodes it did not create without asking.
- **HTML export for Figma (Route B):** `Export(frameId, "html-css", "./design/pencil/exports/html/<step>/<frame>.html", {includeLayerNames:true})`, one frame per file. Claude pre-checks each file by rendering it in Chromium (Playwright, cached locally) against the Pencil PNG before the user drags it into html2figma.

### Figma-plugin compatibility
- The converter (html2figma) reads the `html-css` export of each frame, so the Pencil conventions above are what it converts. Keep `Prop=Value` component names (`TsButton / Type=Primary, State=Default`) so Figma's *Combine as variants* can regroup them into component sets, and keep the Type board as the source for Figma text styles.
- Route B's Figma-side result was approved by the user at step 01 close (the imported spike looked as wanted; per-feature scores were not collected). Every further rule the step 04 test import and the step 20 import find (what html2figma drops, flattens or garbles) is added here (the step 12 test import was deferred to step 20). Step 19 checks all frames against this list.
- _Rules found so far_ (from the HTML export of Route B, verified in the file and a Chromium render; Figma-side result approved by the user):
  - The `html-css` export carries **no components, no variables, no themes**: instances are expanded into plain frames, every color is a resolved hex, a dark frame is just another resolved frame. Components, variables and styles are rebuilt in Figma from the Pencil spec (`GetVariables()` + the component list).
  - Layer names ride on `data-pencil-name` (icons also carry `data-icon-name` / `data-icon-set`). Keep every node named, as already required.
  - **Strokes: set `strokeAlignment: "inner"`.** The default (center) exports as CSS `outline`, which DOM-based converters may drop; inner exports as `border`.
  - **Blur unit:** Pencil `background_blur.radius` exports as half in CSS (radius 14 → `blur(7px)`). PRD 02's `blur(14px)` therefore needs radius **28** in Pencil (step 02 glass board).
  - Export **one frame per HTML file**: several frames share one absolutely positioned wrapper, which imports as an extra parent frame.
  - Fonts load from Google Fonts in the HTML (Exo 2 is available in Figma as a Google font).
  - Icons, illustrations and effects survive as inline `<svg>`, multi-layer `box-shadow` (negative spread included) and `backdrop-filter`.
  - _Step 04 test import (2026-09-24):_ the user imported the 7 HTML files into Figma and reported "all export i check look good in figma" (no per-feature scores or screenshots, so no new drift rules beyond the `note` drop). Chromium pre-check: 7 sheet files render like the Pencil PNG (no `outline`, gradients as `linear-gradient`, `backdrop-filter: blur(14px)` for radius 28, Exo 2 loaded). **`note` nodes are dropped**, so handoff notes have to be re-created in Figma (comments or sticky notes) in step 20. Scroll specimens export as clipped frames.
- Claude has no Figma access. The user runs html2figma and sends screenshots (canvas, layers panel, Local variables, Assets); Claude scores them against the step's checklist.

### Safe-layout rules (PRD 06, applied as design checks)
48dp minimum targets · ellipsis + max lines on names/plates/workshops/notes · sticky bars sit above the bottom inset · max-widths per PRD 06 table · no fixed-height boxes around text · photo slots have an aspect-ratio box.

### Copy
Bahasa Indonesia, friendly voice (PRD 02). `Rp428.000`, `Sel, 29 Sep 2026`, `09.00`. All strings must be realistic — no lorem ipsum. **Sentence case** for buttons, chips, titles (decided at the step 03 review; proper nouns and service names keep their case); errors name the fix ("Contoh: 812-3456-7890").

## `/better-interface` on Pencil designs

The skill is web-oriented and demands `file:line` evidence. On Pencil frames, cite **frame name + node id** (the skill's format allows "exact screen and component when the artifact has no source files") and attach the screenshot. Mapping for static mobile mockups:

| Skill trigger (web) | Check on the design |
|---|---|
| Control with no accessible name | Icon-only controls carry a `note` with the Flutter `Semantics` label |
| Focus indicator | Designed focused state exists for TsButton / TsTextField / TsChip (tablet + keyboard / switch access) |
| `prefers-reduced-motion` | Motion notes state the `MediaQuery.disableAnimations` fallback, and no state is conveyed by motion alone |
| Clipped at 320px / 200% zoom | 360×640 frame and text-scale ×1.3 stress frames show no clipping |
| Contrast | Ratio computed from `Get(..., {resolveVariables: true})` values; text ≥ 4.5:1, UI boundaries/icons ≥ 3:1 |
| Color-only state | Every status/error/selected state also has icon, label or shape |
| Destructive action confirmation | Dialogs use danger styling; cancel de-emphasized |
| Truncation without full value | Truncated text has a reachable detail (tap → sheet, or wraps) |

Fix authority: the plan decision authorizes fixing HIGH + MEDIUM after the report is recorded. The review itself stays read-only; fixes are a separate, logged action. LOW findings stay listed for the user. A step may not enter the review gate until the verdict is `Approve` (no HIGH left).

## Token risks — decided at step 02 kickoff (2026-09-23)

Measured from the resolved hexes (WCAG relative luminance). Decisions are applied in `prd/02` and as variables in step 02.

| Pair | Measured | Decision |
|---|---|---|
| `text-muted` `#8A817A` on `bg-page` / `surface-card` / `surface-inset` (light) | 3.66 / 3.82 / 3.39 : 1 | **Fixed:** light → new `sand-600` `#756C65` = 4.93 / 5.14 / 4.56 |
| `text-faint` `#B0A79F` on light surfaces | 2.27–2.37 : 1 | Decorative only (disabled/placeholder art); never content. Dark `#6C645F` = 3.11–3.32, same rule |
| `success` / `warning` / `info` / `danger` as **text** on white | 2.58 / 2.44 / 3.23 / 3.64 : 1 | **Fixed:** `*-text` (darker) + `*-soft` tints, both modes, all pairs ≥ 4.6 : 1. Base tokens for icons, dots, borders only |
| `border-default` for control boundaries | 1.37–1.54 : 1 light, 1.40–1.50 dark | **Fixed:** new `border-control` (light `sand-500` 3.39–3.82, dark `#6C645F` 3.11–3.32); `border-default` = decorative dividers |
| `text-accent` `orange-600` on `accent-soft` `orange-100` | 4.10 : 1 | **Fixed:** new `text-on-accent-soft` (light `orange-700` `#B04418` 4.83, dark `orange-400` ≥ 5.71); M3 `onPrimaryContainer` maps to it |
| White on `orange-600` | 4.83 : 1 | ✓ as PRD states |
| `1A0E07` on `orange-400` (dark) | 7.86 : 1 | ✓ |
| `text-muted` dark `#9A918B` on dark surfaces | 5.82–6.23 : 1 | ✓ |

## Canonical demo content

Every screen uses the same story so the prototype reads as one app. Draft from the PRD; **step 01 finalizes it** into a demo-content sheet frame.

| Item | Value |
|---|---|
| User | Galah · `+62 812-3456-7890` (masked `+62 812-****-7890`) |
| Garage | Vario 125 (AB 1234 XY), Beat 110 (AB 5678 ZZ), PCX 160 (AB 9012 QR) |
| Workshop | Bengkel Jaya Motor (fictional, Yogyakarta area) |
| Slot | Sel, 29 Sep 2026 · 09.00 (weekday fixed 2026-09-23: 29 Sep 2026 is a Tuesday, PRD says "Sen"; booking code date = service date) |
| Workshop detail | 2 service bays · ★ 4,8 · 1,2 km · Buka s.d. 17.00 · Jl. Melati Raya No. 12, Sleman, DI Yogyakarta (fictional) |
| Unit A · Vario 125 | Servis Berkala Rp85.000 (60 mnt) → **Rp85.000** |
| Unit B · Beat 110 | Servis Berkala Rp85.000 + AHM Oil MPX1 Rp58.000 (60 mnt) → **Rp143.000** |
| Unit C · PCX 160 | Servis Berkala Rp85.000 + AHM Oil MPX2 Rp70.000 + Kampas Rem Rp45.000 (60 mnt) → **Rp200.000** |
| Totals | Subtotal **Rp428.000** · voucher 10% **−Rp42.800** · total **Rp385.200** · 3 × 60 mnt on 2 bays → makespan **2 jam** |
| S11 running estimate | 1 unit Rp85.000 · 1 j → 2 units (2/3 ✓) Rp228.000 · 1 j → 3 units Rp428.000 · 2 j (voucher applies from S16) |
| Booking | `TS-260929-0417`, units `-A` `-B` `-C` |
| S05 Home populated (step 05 kickoff, 2026-09-24) | Garage strip adds the sheet-only **Supra X 125** (`AB 3344 KL`, bebek) as a 4th free motor; the draft = Supra X 125 only, step 2/4, "Kedaluwarsa dalam 22 jam". Unit stages: A Vario Dikerjakan, B Beat Dikerjakan, C PCX Diperiksa → card "3 motor · Dikerjakan" + "1 motor masih Diperiksa". Empty state = same 3 motors, no badges |
| S10 Pilih Motor (step 06 kickoff, 2026-09-24) | Garage = Vario 125, Beat 110, PCX 160 (selected, → S11 units A / B / C) + Supra X 125 (`AB 3344 KL`, free) + Ninja 250 (`AB 7788 MN`, sheet-only sport, **Sedang dalam servis**): "3 dari 5 motor dipilih". Max-reached specimen ("Demo: garage 6 motor") adds the sheet-only **Scoopy 110** (`AB 2468 TP`, matic). S05's populated state (all three in service after the booking) is the moment *after* this flow |
| S13 Pilih Bengkel (step 08 kickoff, 2026-09-24) | 5 fictional workshops, order Terdekat: Bengkel Jaya Motor ★ 4,8 · 1,2 km · 2 bay · tutup 17.00 · "Estimasi 2 jam untuk 3 motor" (canonical) · Sinar Roda Motor ★ 4,6 · 2,1 km · 3 bay · 18.00 · 1 jam · Motor Care Kotagede ★ 4,9 · 3,4 km · 2 bay · 17.00 · 2 jam · Bengkel Resmi Sumber Rejeki Motor & Spesialis Matic Ngaglik ★ 4,3 · 4,7 km · 1 bay · 17.00 · 3 jam (long-name stress) · Cahaya Motor Gejayan ★ 4,5 · 5,0 km · 2 bay · **Tutup, buka 08.00** · 2 jam. Rating order: Kotagede, Jaya, Sinar Roda, Cahaya, Resmi. Jaya's S14: ★ 4,8 (126 ulasan), "Setiap hari 08.00–17.00", Jl. Melati Raya No. 12, Sleman, DI Yogyakarta; services Servis Berkala, Ganti Oli, Perbaikan/Keluhan, Ganti Ban, Tune-Up |
| S15 Pilih Jadwal (step 09 kickoff, 2026-09-24) | **Demo today = Sen 28 Sep 2026, now 10.20** (strip D+0 Sen 28 Sep … D+14 Sen 12 Okt; canonical slot Sel 29 Sep · 09.00 = 2nd item). Capacity **5 motors per hour** (mock). Sel 29 Sep booked 1·1·3·4·5·2·3·1·5 for 08.00…16.00 → for 3 motors: available 08 / 09 (selected) / 13 / 15, short 10 / 11 / 14 ("Sisa 2 / 1 / 2 motor"), Penuh 12 / 16 (info banner on the default frame). Rab 30 Sep = every slot short or full (warning banner). Kam 1 Okt = all full, CTA "Lihat Jum, 2 Okt". Sen 28 Sep: 08–12 "Lewat". Split: Vario 09.00, Beat 10.00, PCX 13.00 = complete; sibling conflict = Vario takes the last seat of 11.00 |
| S16 Ringkasan (step 10 kickoff, 2026-09-24) | Canonical 3-unit booking (lines per unit as above); PCX 160 adds an optional Keluhan on S16 only ("Rem belakang bunyi saat dingin."); default expanded accordion = PCX 160. Caption "Estimasi 2 jam · dikerjakan bergantian di 2 bay"; split "Estimasi 1 jam per motor · datang di jam berbeda". Slot-invalid demo: Sel 29 Sep 09.00 now holds 2 seats for 3 motors. Single unit = Vario 125 Rp85.000 · 1 jam, no eligible voucher |
| Vouchers (step 10 kickoff, 2026-09-24) | `DISKON10` "Diskon 10% servis ≥2 motor" (minUnits 2 → Hemat Rp42.800) · `HEMAT25` "Potongan Rp25.000 min. belanja Rp300.000" (→ Hemat Rp25.000, total Rp403.000) · "Diskon 15% servis ≥4 motor" (ineligible "Butuh min. 4 motor") · "Potongan Rp75.000 min. belanja Rp500.000" (ineligible "Min. belanja Rp500.000 — kurang Rp72.000"). Single motor (Rp85.000): all four ineligible, "Butuh min. 2 motor" on the 10 % one |
| S18 Booking Berhasil (step 11 kickoff, 2026-09-24) | Canonical ticket = `TS-260929-0417`, rows "Unit -A · Servis Berkala" / "-B · Servis Berkala + Oli" / "-C · Servis Berkala + Oli + Kampas rem", all Terjadwal, total **Rp385.200** "Total estimasi · Bayar di bengkel". Single unit = Vario Rp85.000. Split = 09.00 / 10.00 / 13.00 on Sel 29 Sep. **5-unit stress specimen** ("Demo: 5 motor"): `TS-261002-0418`, Jum 2 Okt 2026 · 08.00 (a 5-motor shared slot needs an empty hour), + `-D` Supra X 125 Rp85.000 and `-E` Ninja 250 Rp130.000 → subtotal Rp643.000, DISKON10 −Rp64.300, total Rp578.700 |
| S03 / S04 Auth (step 13 kickoff, 2026-09-24) | Login number `+62 812-3456-7890` (typed as `812-3456-7890`; invalid example shows "Nomor tidak valid. Contoh: 812-3456-7890"); S04 headline masks it as `+62 812-****-7890`; demo OTP `123456`, resend countdown `0:30` |
| S07 / S08 / S09 Garage (step 14 kickoff, 2026-09-25) | **After-booking moment.** S07 garage = Vario 125 (`AB 1234 XY`, Dikerjakan) · Beat 110 (`AB 5678 ZZ`, Dikerjakan) · PCX 160 (`AB 9012 QR`, Diperiksa) · Supra X 125 (`AB 3344 KL`, free, bebek) (Ninja 250 / Scoopy 110 stay sheet-only S10 motors). S09 default = Beat 110 (Honda Beat 110 · Matic · 2021): active `TS-260929-0417-B` Servis Berkala + Oli · Sel, 29 Sep 2026 · 09.00 · Dikerjakan; past `TS-260910-0091` (PRD 05 seed on `motor_002`) Servis Berkala + Oli · Selesai · Rp143.000, `TS-260714-0058` Servis Berkala · Selesai · Rp85.000, `TS-260502-0031` Ganti Ban · Dibatalkan (weekdays checked against demo today Sen 28 Sep 2026). Free motor = Supra X 125 (Honda Supra X 125 · Bebek · 2018, no history). S08 Edit = Beat 110 prefilled (year 2021); validation demo plate `AB12 34`. Picker = 15 models: Honda Beat 110, Scoopy 110, Vario 125, PCX 160, Supra X 125, CB150R · Yamaha Mio M3 125, NMAX 155, Jupiter Z1 115, R15, MT-15 · Suzuki Address 110, Smash 115, Satria F150, GSX-R150 |
| S12 Katalog (step 15 kickoff, 2026-09-25) | Select-mode unit = **Beat 110** (`AB 5678 ZZ`, unit -B): S11 hands over AHM Oil MPX1 ticked; frames show MPX1 + Kampas Rem Matic ticked → "2 dipilih · Suku cadang Rp103.000". 14-part mock catalog (MPX1 Rp58.000, MPX2 Rp70.000, SPX2 Rp62.000, Yamalube Sport Rp98.000, Kampas Matic Rp45.000 / Bebek Rp40.000 / Sport Rp120.000, Busi NGK Rp28.000 / Iridium Rp95.000, Aki GS Astra Rp185.000 / Yuasa Rp165.000, Ban IRC Rp185.000 / Federal Rp210.000, Filter Udara Rp35.000), each with category + cc range; Beat 110 fits 7 (MPX1, Kampas Matic, both Busi, Aki GS, Ban IRC, Filter). Search demo "oli" (keyboard) and "Ninja" (empty). Browse detail lists the garage: Vario 125, Beat 110, PCX 160, Supra X 125. Full table in [15](15-catalog-s12.md) |
| S23 / S24 Invoice & Ulasan (step 17 kickoff, 2026-09-25) | Booking `TS-260929-0417`, all units Selesai on Sel 29 Sep 2026: invoice issued **11.08**, paid **11.24**, review sent **11.31**. Lines as the canonical table (Rp85.000 / Rp143.000 / Rp200.000 → subtotal Rp428.000, DISKON10 −Rp42.800, total **Rp385.200**, "Bayar di bengkel" → "Dibayar di bengkel"; reference = booking code). Mechanics: **Mas Rudi** (Beat 110, ★ 4,8 as step 16 S21) and **Pak Anto** (Vario 125 + PCX 160). S24 filled example: workshop 5★ "Sangat baik" + "Cepat dan rapi. Montirnya jelas menerangkan kondisi rem PCX.", Mas Rudi 5★, Pak Anto 4★. Single-mechanic variant = seed `TS-260910-0091` (Beat 110, Rp143.000, Mas Rudi only). Full table in [17](17-invoice-rating-s23-s24.md) |
| S06 / S25 / S26 (step 18 kickoff, 2026-09-25) | **Now = Sel 29 Sep 2026 ≈ 10.30** (S05 moment). S06 = 9 notifications, 2 unread (PCX 160 sedang diperiksa 10.26 → S21 -C; Beat 110 mulai dikerjakan 10.18 → S21 -B), read: Vario 125 dikerjakan 10.05 → S21 -A, check-in 09.08 → S20; Minggu ini: Booking berhasil TS-260929-0417 (Sen 28 Sep → S20), reminder ganti oli Supra X 125 (→ S10), promo HEMAT25 (Sab 26 Sep → S10 + voucher); Lebih lama: Servis selesai Beat 110 TS-260910-0091 Rp143.000 (10 Sep → S23), promo DISKON10 (3 Sep). S25 user = Galah · `+62 812-****-7890` · avatar "G", theme default Sistem, version `1.0.0 (1)`. S26 booking `TS-260929-0417`: -A Dikerjakan, -B Dikerjakan, -C Diperiksa; speed default 15 dtk. Full table in [18](18-notif-profile-demo.md) |
| Promo/OTP | demo OTP `123456` |

**Resolved in step 01 kickoff (2026-09-23, user approved):** the price set and weekday in the table above are canonical. PRD 02/03/04 text is corrected in step 19 (S11 estimate, S16 per-unit amounts, S18, the "Sen" weekday, the S11 plate `AB 1234 XY` shown for Beat, `services.json` gains the parts/services used here). Original inconsistency for reference — S11 wireframe shows `Est. Rp412.000`, S16 shows 2 units (Rp428.000 → Rp385.200 after voucher), S18 shows 3 units with the same Rp385.200 total, and `services.json` prices Servis Berkala at Rp85.000 while S16 shows Rp185rb per unit. Target: one 3-unit booking, subtotal Rp428.000, 10% voucher (−Rp42.800), total Rp385.200, duration from makespan on a 2-bay workshop; S11's running estimate consistent with the same line items.

## Per-step workflow

1. **Kickoff** — read the step's PRD refs; ask the user (`AskUserQuestion`) the step's *Open questions* that change layout or content. Set status 🟡.
2. **Build** — `get_app_state`; `read_skill` docs as needed; one `execute` per section with `placeholder: true` until done; frames per the step's matrix; variables + instances only; end each section with a screenshot.
3. **Self-check** — tick the Build checklist; run the automated checks; fix before review.
4. **`/better-interface`** — scope = this step's frames. Record scope/coverage, findings, verification and verdict in the step file. Apply HIGH + MEDIUM, re-screenshot, re-run until `Approve`. List LOW.
5. **Session log** — append rows (time · action · result) to the step's Session log as work happens.
6. **Review gate** — status 🔵; give the user the frame list and what to look at; the user reviews in Pencil and replies *approve* or *changes*. Log each round. Loop until approved.
7. **Close** — only after approval: PNG export; write the `docs/claude-session/` file; status ✅; update the tracker below. No commit.

## Status tracker

⬜ not started · 🟡 in progress · 🔵 in review · ✅ approved

| Step | File | Priority | Owns screens | Status | Claude session file |
|---|---|---|---|---|---|
| 01 | [01-setup-spike.md](01-setup-spike.md) | — | — | ✅ | `03-design-step01-setup-spike.md` |
| 02 | [02-foundations.md](02-foundations.md) | — | — | ✅ | `04-design-step02-foundations.md` |
| 03 | [03-components-core.md](03-components-core.md) | — | — | ✅ | `05-design-step03-components-core.md` |
| 04 | [04-components-booking.md](04-components-booking.md) | — | — | ✅ | `06-design-step04-components-booking.md` |
| 05 | [05-s05-home.md](05-s05-home.md) | P0 | S05 | ✅ | `07-design-step05-s05-home.md` |
| 06 | [06-s10-pilih-motor.md](06-s10-pilih-motor.md) | P0 | S10 | ✅ | `08-design-step06-s10-pilih-motor.md` |
| 07 | [07-s11-detail-servis.md](07-s11-detail-servis.md) | P0 | S11 | ✅ | `09-design-step07-s11-detail-servis.md` |
| 08 | [08-s13-s14-bengkel.md](08-s13-s14-bengkel.md) | P0/P1 | S13, S14 | ✅ | `10-design-step08-s13-s14-bengkel.md` |
| 09 | [09-s15-jadwal.md](09-s15-jadwal.md) | P0 | S15 | ✅ | `11-design-step09-s15-jadwal.md` |
| 10 | [10-s16-s17-ringkasan.md](10-s16-s17-ringkasan.md) | P0/P1 | S16, S17 | ✅ | `12-design-step10-s16-s17-ringkasan.md` |
| 11 | [11-s18-tiket.md](11-s18-tiket.md) | P0 | S18 | ✅ | `13-design-step11-s18-tiket.md` |
| 12 | [12-p0-checkpoint.md](12-p0-checkpoint.md) | — | (S05→S18 flow) | ✅ | `14-design-step12-p0-checkpoint.md` |
| 13 | [13-auth-s01-s04.md](13-auth-s01-s04.md) | P1 | S01–S04 | ✅ | `15-design-step13-auth.md` |
| 14 | [14-garage-s07-s09.md](14-garage-s07-s09.md) | P1 | S07–S09 | ✅ | `16-design-step14-garage.md` |
| 15 | [15-catalog-s12.md](15-catalog-s12.md) | P1 | S12 | ✅ | `17-design-step15-catalog.md` |
| 16 | [16-tracking-s19-s22.md](16-tracking-s19-s22.md) | P1 | S19–S22 | ✅ | `18-design-step16-tracking.md` |
| 17 | [17-invoice-rating-s23-s24.md](17-invoice-rating-s23-s24.md) | P1 | S23, S24 | ✅ | `19-design-step17-invoice-rating.md` |
| 18 | [18-notif-profile-demo.md](18-notif-profile-demo.md) | P1 | S06, S25, S26 | ✅ | `20-design-step18-notif-profile-demo.md` |
| 19 | [19-full-app-audit.md](19-full-app-audit.md) | — | all | ✅ | `21-design-step19-full-app-audit.md` |
| 20 | [20-figma-conversion.md](20-figma-conversion.md) | — | all | ⬜ | `22-design-step20-figma-conversion.md` |
| 21 | [21-figma-prototype-publish.md](21-figma-prototype-publish.md) | — | S05→S18 | ⬜ | `23-design-step21-figma-prototype-publish.md` |

Session `02-design-plan.md` records the creation of this plan itself.

## Coverage map

Every screen and every PRD 02 inventory component is owned by exactly one step (each step file has `Owns screens` / `Owns components` lines — grep them to verify).

| Screens | Step |
|---|---|
| S05 | 05 |
| S10 | 06 |
| S11 | 07 |
| S13, S14 | 08 |
| S15 | 09 |
| S16, S17 | 10 |
| S18 | 11 |
| S01–S04 | 13 |
| S07–S09 | 14 |
| S12 | 15 |
| S19–S22 | 16 |
| S23, S24 | 17 |
| S06, S25, S26 | 18 |

| Components (28) | Step |
|---|---|
| `TsLogo` | 02 |
| `TsButton`, `TsTextField`, `TsChip`, `TsAppBar`, `SheetHeader`, `NavBar` / `NavRail`, `EmptyState`, `ErrorState`, `Skeleton`, `UnitStatusBadge` (+ extra `TsDialog`, `TsSnackbar`, `TsIconButton`) | 03 |
| `VehicleTabChip`, `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `WorkshopCard`, `SlotChip`, `DateStripItem`, `BookingStepper`, `StickyEstimateBar`, `PriceBreakdown`, `TicketCard`, `PromoBanner`, `VoucherCard` (+ `TsCheckbox`, `TsRadio`, `TicketUnitRow`, `PageIndicator`, see *Inventory additions*) | 04 |
| `StatusTimeline`, `MechanicCard` | 16 |
| `RatingStars` | 17 |
| `NotificationTile` | 18 |

Step 02 also adds design-only masters that are not Flutter widgets: the `Type / <Role>` text nodes (Figma text styles in step 20), `System / Status Bar` and `System / Gesture Bar`.

`TsDialog` and `TsSnackbar` are not in the PRD 02 inventory but PRD 04 "Global patterns" require them; they are added to the inventory in step 03 and must be added to `prd/02` (and become Flutter widgets).

### Inventory additions (running list → applied to `prd/02` in step 19, 2026-09-25)

Components that exist in PRD 04 screens or global patterns but not in the PRD 02 inventory. Steps append here as they build.

| Component | Added in | Why |
|---|---|---|
| `TsDialog`, `TsSnackbar` | 03 | PRD 04 global patterns |
| `TsIconButton` | 03 | Back, close, bell, snackbar dismiss, field clear: 48×48 target, shared by `TsAppBar`, `SheetHeader`, `TsSnackbar`, `TsTextField` (decided at step 03 kickoff) |
| `System / Status Bar`, `System / Gesture Bar` | 02 | Android chrome (24dp + 24dp), instanced by every phone frame; not Flutter widgets |
| `TsCheckbox`, `TsRadio` | 04 | Selection glyph shared by `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `VoucherCard`: 48dp target, unchecked / checked / disabled; Flutter = themed `Checkbox` / `Radio` wrappers (decided at step 04 kickoff) |
| `TicketUnitRow`, `PageIndicator` | 04 (moved from 11 / 13) | Needed inside `TicketCard` and `PromoBanner`; steps 11 and 13 instance them instead of redrawing |
| `AppShell` | 05 | Tab shell (bottom `NavBar` / `NavRail`) reused by S05, S07, S19, S25 |
| `ActiveBookingCard`, `DraftResumeCard`, `QuickLinkTile`, `FleetProgress` | 05 (`FleetProgress` full in 16) | S05 content blocks |
| `BookingCtaCard` (Compact / Hero), `SectionTitleRow`, `GarageAddTile`, `VehicleSelectCard` compact In Service variant | 05 (added at kickoff, 2026-09-24) | S05: primary CTA (hero in the empty state), garage strip header / "+" tile, in-service badge on the compact garage card |
| `TsAppBar / Type=Title, Actions=Bell` | 05 (added while building) | Tablet app bar without the logo (the rail carries it). A promo pause / play control was proposed by the review and declined by the user |
| `TsDialog` confirm-save variant, `SelectionFooter` (the step file's `SelectionCounter`), `AddMotorCard`, `TsAppBar` close-leading | 06 (added at kickoff, 2026-09-24) | S10: non-destructive booking-exit dialog reused by every booking step; flat sticky footer with counter + reason line + Lanjut; full-width "+ Tambah motor lain" card; close-leading bar for the first booking step |
| `UnitHeader`, `CopyFromRow` (+ `CopyNote`), `CopySourceSheet` (+ `CopySourceRow`), `ComplaintSection`, `EstimatePane`, `TsAppBar` step variant (back leading + close trailing, reused S13–S16), `System / Keyboard` (design-only) | 07 (added at kickoff, 2026-09-24) | S11 sections: unit header with remove button, copy-from row + dropped-parts note + source sheet, collapsible complaint block, tablet estimate pane, the booking-flow app bar for S11+, keyboard block for the keyboard state |
| `VehicleTabChip` + rail: Active+Incomplete / Active+Complete / Active+Error | 07 (amends step 04) | The active unit keeps its status glyph (✓ / ○ / error) instead of a status-hiding ● |
| `EstimatePane` (Units=3 Default / CTA Disabled / Loading / Error, Units=1 Default), `CopySourceSheet / Layout=Modal` | 07b (added at kickoff, 2026-09-24) | S11 tablet-landscape live estimate pane (static per-unit lines, no voucher; the S16 `PriceBreakdown / Variant=Pane` stays S16's); centered modal form of the source sheet for tablet |
| `SearchBar`, `FilterChipRow` (filter + sort chips), `StaticMap` (token-bound), `WorkshopPhoto`, `ServiceTag`, `WorkshopInfoBlock` (Open / Closed, with `Chosen Tag` slot), `WorkshopMapBlock`, `WorkshopServicesBlock`, `WorkshopAddressBlock`, `WorkshopDetailContent` (Populated / Loading; the Split layout is composed inline in the standalone Tablet-L frame), `WorkshopCtaBar`, `EmptyState` variant Bengkel, `WorkshopCard` Loading | 08 (added at kickoff and while building, 2026-09-24) | S13/S14 (`SearchBar` reused by 15); `WorkshopCard` gains slots `Estimate Row`, `Chosen Tag` (all three masters) and `Preview Chevron` (Selected only) — amends step 04. `TsAppBar / Type=Back` already existed (step 03), no new app bar |
| `TsSwitch` (moved from 18), `ScheduleModeToggle`, `WorkshopSummaryRow`, `UnitSlotSection`, `CapacityBanner` (Info / Warning; reused by step 10 for the S16 invalid-slot banner), date-grid `DateStripItem` + `DateGrid`; `SlotChip` caption "Sisa n motor" (amends step 04) | 09 (added at kickoff, 2026-09-24) | S15 split / capacity / landscape; workshop context row (PRD 04 S15 lists none); the toggle needs a switch before S25 |
| `SummaryCard` (Shared / Split / Invalid), `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow` (Empty / Applied / Loading), `PriceBreakdown / Variant=Confirm`, `ConfirmBar`, `ConfirmPane`, `NoVoucherOption`; `CapacityBanner` gains an `Action 2` slot (amends step 09) | 10 (added at kickoff, 2026-09-24) | S16 recap + confirm bar / pane, S17 "Tidak pakai voucher" row; the estimate block reuses the step 04 static unit / summary / voucher / total / note parts |
| `SuccessHeader`, `QrCode` (real matrix, primitives), `TicketActions` (Bar / Pane, Default / Tracking Disabled), `ShareTicketRow` (P2); amends step 04: `TicketCard` Code Row + copy button, `QrCode` replaces the icon, `TicketCard / State=Loading` (Phone / Landscape), `TicketUnitRow` Slot Line, `TicketCard Units Panel / State=Loading` (`TicketUnitRow` moved to 04) | 11 (added at kickoff, 2026-09-24) | S18 header, scannable ticket QR, sticky / pane CTAs, split slots, loading skeleton |
| `OtpInput` (Focused / Filled / Error / Loading), `AuthLink` (Default / Disabled), `TermsNote`, `AuthHero`, `OnboardingContent`, `OnboardingArt / Slide=1–3` + `Slide=1, Size=Large` (component vignettes), `AuthCard`, `System / Keyboard Numeric` (design-only) (`PageIndicator` moved to 04) | 13 (added at kickoff and while building, 2026-09-24 / 25) | S02–S04: 6-cell OTP with demo-hint and error slots, 48 dp text links for "Ganti nomor" / resend, two-line terms note with links, Tab-L brand pane, shared onboarding text / CTA block, the 3 onboarding vignettes, centered Tab-P card shell, numeric pad for the keyboard frames |
| `TsAppBar / Type=Title, Actions=Add`, `VehicleSelectCard / Mode=Display` `State=In Service` + `State=Loading`, `MotorPhotoField`, `MotorModelPicker` (`Layout=Sheet` / `Layout=Modal`, + `ModelRow`, `BrandHeader`), `MotorForm` (Phone / Wide), `MotorPreviewPane`, `MotorHero` (Free / In Service), `ServiceHistoryRow` (Active / Past / Cancelled), `HistorySection` (Populated / Empty), `MotorDetails` (List / Grid), `FormErrorBanner` | 14 (added at kickoff and while building, 2026-09-25) | S07 bar with "+", garage card status badge / skeleton, S08 photo / model picker / form / Tab-L live preview, S09 hero + CTA block + service history |
| `PartDetailSheet` (Sheet / Modal × Select Add / Select Selected / Select Incompatible / Browse), `CompatRow`, `SpecRow`, `SelectedPartsBar` (Default / None / Loading), `CategoryChipRow`, `CompatToggleRow`, `PartOptionTile` Loading masters (amends step 04) | 15 (added at kickoff, 2026-09-25) | S12: detail sheet / modal with a compat block, staged-selection footer, category chips with scroll cue, "Hanya yang cocok" toggle row, skeleton tiles |
| `BookingHistoryCard`, `UnitStatusRow` (flat rows, badge on the name row), `CancelScopeChooser`, `DemoModeShortcut`, `HistoryTab` (Active / Inactive) + `HistoryTabRow` (Active = Mendatang / Berlangsung / Selesai / Dibatalkan) as underline tabs; `WorkshopSummaryRow` gains a disabled `Row Chevron` slot (rescue, 2026-09-25) | 16 | S19–S22 |
| `RatingStars` (`Star` atoms Empty / Half / Full as token-bound paths, Input Large / Compact, Display, `RatingLabel`), `PaymentStatusTag`, `PaidBanner`, `InvoiceHeaderCard`, `InvoiceSummaryCard`, `WorkshopRatingCard` (Empty / Rated / Error), `MechanicRatingRow`, `ReviewRecap` (Submitted / Preview / Preview Empty) | 17 (added at kickoff and while building, 2026-09-25) | S23 / S24: invoice paid tag + banner + Tab-L summary pane, star input / display with word label, per-mechanic rating row, read-only / live recap |
| `NotificationTile` (Category × Read / Unread + Loading), `TsSegmentedControl` (theme + speed), `SettingsRow` (Chevron / Demo / Switch On / Switch Off; `SettingsGroup` is a composition, no master), `NotificationGroupHeader`, `UserCard`, `ThemeSetting`, `ThemePreview` (System / Light / Dark), `DemoPanel` (with slot), `DemoUnitRow` (Default / Selected / At Selesai), `DemoPreviewPane`, `ErrorSimBanner`, `AboutContent`; late variant `TsButton / Outline, Compact, Disabled` (amends step 03). **`TsSlider` dropped** at the kickoff (speed = segmented; `TsSwitch` moved to step 09 and is instanced) | 18 (added at kickoff, 2026-09-25) | S06 tiles, S25 settings rows / theme control / Tab-L theme preview, S26 labelled demo panels, per-unit controls, armed banner, About sheet |

`VehicleSelectCard` gains display and compact modes (step 04) instead of a separate garage-card component.

## Cut-line guidance

The PRD 7-day plan gives design roughly D1–D3, so this plan is deliberately ordered so a hard stop still leaves a valid submission. If time runs short, cut in this order:

1. P2 optional items inside steps 07, 11, 16 (complaint photo, share/calendar, "additional work" card).
2. Dark-mode frames for P1 screens (keep tokens + P0 dark).
3. Tablet frames for P1 screens (keep one tablet frame each).
4. Step 15 (catalog) degrades to the shortlist already in S11.
5. Step 18 S26 detail (keep S25).

Never cut: steps 01–12, the P0 tablet frames, or step 20–21 (M1 needs the public Figma link). Steps 20–21 run after the Flutter app build (decided at the step 12 kickoff, 2026-09-24), so the plugin path, the Draft public link and the Starter dark-mode workaround are first verified at step 20; the PRD 7-day plan (Figma D1–D3, Flutter D3–D7) is the schedule to re-check when the app build finishes.

## Templates

### Step file skeleton

````markdown
# Step NN — <Title>

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 / P1 / — |
| **Owns screens** | Sxx |
| **Owns components** | … |
| **PRD refs** | … |
| **Pen location** | … |
| **Depends on** | Step … |
| **Claude session** | `docs/claude-session/<NN+2>-design-stepNN-<slug>.md` (written after approval) |

## Goal
## Inputs
## Open questions (ask at kickoff)
## Scope
### Frame matrix
### Components / illustrations to build
### Content & copy notes
### Annotations to place
## Checklist
### Build
### Quality (automated, run in `execute`)
### /better-interface
### Review gate
### Close (only after approval)
## /better-interface report
## Review rounds
## Session log
````

### `/better-interface` report block (paste into each step)

````markdown
**Scope:** <frame names + node ids> · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | | |
| Layout | | |
| Writing | | |
| Typography | | |
| Color | | |
| UI | | |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|

**Verification:** <checks run + result; **Not verified** items>
**Verdict:** Block / Approve
**Fixes applied:** <HIGH/MEDIUM fixed, with node ids> · **LOW left for user:** <list>
````

### Review round block

````markdown
#### Round N — YYYY-MM-DD
- **Frames shown:** …
- **User feedback:** "<quote>"
- **Changes made:** …
- **Outcome:** changes requested / approved
````

### Session log row

`| HH:MM | action | result / node ids |`

### Claude-session file skeleton

Mirrors [`../../claude-session/01-create-prd.md`](../../claude-session/01-create-prd.md):

````markdown
# Claude Session Log — NN: Design step MM — <Title>

**Tool:** Claude Code + Pencil MCP, model <model>
**Date:** YYYY-MM-DD
**Topic:** <one line>

## Initial prompt
## Research performed
## Clarifying interview   (AskUserQuestion rounds → answers)
## Execution              (frames/components built, node ids, exports)
## /better-interface      (findings summary, fixes applied, verdict)
## Review rounds          (user feedback → changes → approval)
## Key decisions worth flagging to a reviewer
## Output                 (files: .pen sections, exports, docs updated)
````

## Risks

| Risk | Mitigation |
|---|---|
| html2figma fidelity on the full component set and the tablet layouts is proven only on the spike | The user approved the spike result at step 01; the step 04 test import found no drift; the P0 test import (step 12) was deferred, so tablet layouts and the full component set are first imported at step 20; fallback = Route C (Figma dev plugin) or manual rebuild |
| Free third-party plugin may change, break or disappear before step 20 | Re-test one frame at the start of step 20 (the step 12 re-test was deferred); keep PNG exports + the Pencil spec as the manual-rebuild source |
| Figma Starter caps: 3 pages per team file, variable modes documented only for paid/Education plans (PRD 02 needs 6 pages + Light/Dark) | Decided at step 01 close but not yet verified on the account (check at the start of step 20); default = Draft file + dark mode as a second collection; alternatively Education/Pro before step 20 |
| Figma work is manual for the user (no Figma MCP) | Claude writes step checklists and the prototype wiring table; user sends screenshots; budget the time in step 20 / 21 (after the app build) |
| `Generate svg` is slow/expensive, style may drift, and it can deliver nothing (step 13: 4 empty results) | ≤ 11 illustrations, each a reusable component; style approved once in step 01 before budget is spent; step 13 fell back to component vignettes (no generation) |
| Glass effect: Pencil has `background_blur` but no `saturate` | Approximate with tint + blur + border; note the Flutter `BackdropFilter` spec; flat fallback documented |
| Frame count explosion (states × breakpoints × themes) | Matrix rule above; dark/tablet cut-lines; components + instances only |
| PRD inconsistencies (window classes, demo prices) | Resolved in step 01 and written back to the PRD |
