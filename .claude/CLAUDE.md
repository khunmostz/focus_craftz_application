# Focus Craftz — Claude Instructions

# ────────────────────────────────────────────
# PROJECT OVERVIEW
# ────────────────────────────────────────────

## Project
Focus Craftz คือ mobile app สำหรับ focus timer ที่มี
gamification layer — ผู้ใช้ earn coins, unlock desk items,
และ compete บน leaderboard

## Tech Stack
- Framework:    Flutter (Dart) — SDK ^3.11.1
- State:        flutter_bloc (BLoC pattern)
- DI:           get_it (service locator via `locator`)
- Navigation:   go_router
- Backend:      Firebase (Auth, Analytics, Remote Config, Crashlytics)
- Testing:      bloc_test, mocktail

# ────────────────────────────────────────────
# SCREENS / FEATURES
# ────────────────────────────────────────────

## Features (lib/features/)
- auth/          — Login / Register
- focus_time/    — Main focus timer screen
- home/          — Home / Dashboard (มี example Clean Arch ครบ)
- leaderboard/   — Weekly focus hours ranking
- market/        — Coin shop, desk decorations
- profile/       — XP, achievements, streak, workspace evolution

# ────────────────────────────────────────────
# ARCHITECTURE
# ────────────────────────────────────────────

## Clean Architecture
แต่ละ feature แบ่งเป็น 3 layer:
```
features/<feature>/
  data/
    datasources/    — abstract + impl (local/remote)
    repositories/   — repository impl
  domain/
    entities/       — pure Dart classes (ไม่ depend on Flutter)
    repositories/   — abstract interface
    usecases/       — single-responsibility use cases
  presentation/
    bloc/           — xxxBloc, xxxEvent, xxxState
    pages/          — full screens
    widgets/        — feature-specific widgets
```

ดู `lib/features/home/` เป็น reference ที่สมบูรณ์

## Dependency Injection
ใช้ get_it ผ่าน `locator` (GetIt.instance) ใน `core/di/service_locator.dart`
- registerFactory    — BLoC (สร้างใหม่ทุกครั้ง)
- registerLazySingleton — UseCases, Repositories, DataSources

## Firebase Flavors
- dev/prod flavor แยก GoogleService-Info / google-services.json
- `core/firebase/app_flavor.dart` — enum AppFlavor
- `core/firebase/firebase_options_dev.dart` / `firebase_options_prod.dart`

# ────────────────────────────────────────────
# DESIGN SYSTEM
# ────────────────────────────────────────────

## Design Language
Theme: cozy desk setup + cute minimal
Mood: productive but cozy, warm natural light, calm focus

### Rules
- ใช้โทนสีนุ่ม warm neutral — ห้ามใช้ dark theme หรือ heavy gradient
- ทุก widget ต้องมี border-radius โค้งมน (≥12px)
- Whitespace เยอะ layout โปร่งสบาย
- Typography: rounded, friendly, modern — ห้าม harsh/angular font
- Decoration elements: keyboard, lamp, mug, shelf, headphones (minimal)
- ห้ามรก — ทุก element ต้องมี purpose

### Theme
- ตอนนี้ theme อยู่ใน `app/app.dart` (ColorScheme.fromSeed teal + Material3)
- เมื่อสร้าง design tokens ให้วางไว้ที่ `core/theme/`
- ห้ามแก้ core/theme/ โดยไม่บอก (เมื่อมีแล้ว)

# ────────────────────────────────────────────
# CODE CONVENTIONS
# ────────────────────────────────────────────

## File Structure
```
lib/
  app/            — App root widget, theme setup
  components/     — shared UI components (ยังว่างอยู่)
  core/
    di/           — service_locator.dart
    error/        — exceptions.dart, failures.dart
    firebase/     — flavor + firebase options
    router/       — app_router.dart, app_routes.dart, app_navigation.dart
    usecases/     — base UseCase abstract class
  features/       — แต่ละ feature มี Clean Arch layers
  main.dart
```

## Naming
- Files:      snake_case.dart
- Classes:    PascalCase
- Variables:  camelCase
- Constants:  kCamelCase หรือ SCREAMING_SNAKE (enum values)
- BLoC:       xxxBloc / xxxEvent / xxxState

## BLoC Rules
- Event เป็น sealed class หรือ abstract class + subclasses
- State เป็น sealed class หรือ freezed (ยึดตาม home feature เป็น reference)
- ห้าม call locator<> ใน widget โดยตรง — inject ผ่าน BlocProvider ใน app.dart
- ใช้ BlocBuilder / BlocListener / BlocConsumer ตามความเหมาะสม

## Widget Rules
- ใช้ const constructor ทุกที่ที่ทำได้
- Widget ที่ reuse ให้อยู่ใน `components/` (shared) หรือ `features/<x>/presentation/widgets/`
- ห้าม build() ทำงาน side effects — ใช้ BlocListener / initState

## Do / Don't
✅ แยก business logic ออกจาก UI เสมอ (ผ่าน BLoC + UseCase)
✅ เขียน unit test สำหรับ BLoC / UseCase / Repository (ใช้ bloc_test + mocktail)
✅ ใช้ go_router สำหรับ navigation ทั้งหมด
✅ Register dependency ใน service_locator.dart ทุกครั้ง
❌ ห้าม import package โดยไม่ได้รับ approval ก่อน
❌ ห้ามแก้ core/theme/ โดยไม่บอก (เมื่อมีแล้ว)
❌ ห้าม hardcode สีหรือ spacing ใน widget

# ────────────────────────────────────────────
# WORKFLOW
# ────────────────────────────────────────────

## Workflow
- ก่อนเริ่มงานใหม่ ให้อ่าน .claude/CHANGELOG.md ก่อนเสมอ
- หลังทำงานเสร็จแต่ละ session บันทึกลง .claude/CHANGELOG.md
- format: ## [YYYY-MM-DD] session summary
- run `flutter analyze` หลังแก้โค้ดทุกครั้ง
- run `flutter test` ก่อน commit

## Important Files
- lib/features/home/     ← reference feature สมบูรณ์ (Clean Arch + BLoC)
- lib/core/di/service_locator.dart  ← register dependency ที่นี่
- lib/core/router/app_router.dart   ← register routes ที่นี่
- .claude/CHANGELOG.md   ← session log (Claude เขียน)
- CHANGELOG.md           ← release log (ห้ามแตะ)

# ────────────────────────────────────────────
# GAMIFICATION NOTES
# ────────────────────────────────────────────

## Gamification System
- Currency:    Coins (earn จาก focus sessions)
- XP:         level up จาก streak + session duration
- Items:      keyboard skins, monitor themes, plants, lamps, room deco
- Streak:     consecutive focus days — reset ถ้าข้าม 1 วัน
- Leaderboard: weekly focus hours ranking
