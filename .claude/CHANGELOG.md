## [2026-05-29] Introduce profile feature — UserProfile Clean Arch

### Added
- `lib/features/profile/domain/entities/user_profile.dart` — pure Dart entity ครบทุก field จาก schema (uid, email, displayName, photoUrl, coins, xp, level, streak, lastFocusDate, totalFocusMinutes, weeklyFocusMinutes, weekStartDate, createdAt, updatedAt)
- `lib/features/profile/domain/repositories/user_profile_repository.dart` — abstract interface (getUserProfile, createUserProfile)
- `lib/features/profile/domain/usecases/get_user_profile.dart` — GetUserProfile + GetUserProfileParams
- `lib/features/profile/domain/usecases/create_user_profile.dart` — CreateUserProfile + CreateUserProfileParams
- `lib/features/profile/data/models/user_profile_model.dart` — fromMap / toMap / toEntity / newUser factory (weekStartDate คำนวณ Monday ของสัปดาห์ปัจจุบัน)
- `lib/features/profile/data/datasources/user_profile_remote_data_source.dart` — abstract + impl (Firestore collection `users/{uid}`)
- `lib/features/profile/data/repositories/user_profile_repository_impl.dart`
- `lib/features/profile/presentation/bloc/profile_bloc.dart` + event + state (ProfileInitial / ProfileLoading / ProfileLoaded / ProfileError)

### Modified
- `lib/features/auth/data/datasources/auth_remote_data_source.dart` — ลบ `FirebaseFirestore` dependency, inject `UserProfileRemoteDataSource` แทน, `_saveUserToFirestore` เรียก `_profileDataSource.createUserProfile()` แทน inline Firestore write
- `lib/core/di/service_locator.dart` — register profile feature ครบ (ProfileBloc, usecases, repo, datasource)

### Removed
- `lib/features/auth/data/models/user_model.dart` — superseded โดย `UserProfileModel` ใน profile feature

### Design decision
- auth feature ไม่รู้เรื่อง gamification fields — `UserProfile` เป็น owner เดียว
- cross-feature dependency อยู่ที่ data layer เท่านั้น (auth datasource → profile datasource interface)
- `flutter analyze` clean — No issues found
- 38/38 unit tests ผ่าน, widget_test.dart fail เป็น pre-existing issue เดิม

---

## [2026-05-29] Separate Firebase prod project from dev

### Fixed
- prod config ทั้งหมดเคยชี้ไปที่ `focus-craftz-dev` project เดียว เพราะ flutterfire configure ครั้งแรกเพิ่ม bundle ID ทั้ง dev+prod ไว้ใน dev project
- สร้าง Android + iOS app ใหม่ใน `focus-craftz-prod` project ผ่าน Firebase CLI
- อัพเดต `android/app/src/prod/google-services.json` → ชี้ `focus-craftz-prod` (project: 589350790558)
- อัพเดต `ios/firebase/prod/GoogleService-Info.plist` → ชี้ `focus-craftz-prod`
- อัพเดต `lib/core/firebase/firebase_options_prod.dart` → ใช้ credentials ของ prod project
- อัพเดต `firebase.json` → `src/prod` และ `Debug-prod` ชี้ `focus-craftz-prod` ถูกต้อง

### Prod App IDs (focus-craftz-prod / 589350790558)
- Android: `1:589350790558:android:767ba8e558087799e9228f`
- iOS: `1:589350790558:ios:eab089832a955bf6e9228f`

---

## [2026-05-29] Merge login + register into single AuthPage with PageView

### Added
- `lib/features/auth/presentation/pages/auth_page.dart` — combined auth page: illustration คงที่บนสุด (height 240), toggle pill (Sign In / Create Account), `PageView` ด้านล่างด้วย `NeverScrollableScrollPhysics` (switch ด้วย tap เท่านั้น, ป้องกัน conflict กับ vertical scroll)

### Removed
- `lib/features/auth/presentation/pages/login_page.dart` — superseded โดย AuthPage
- `lib/features/auth/presentation/pages/register_page.dart` — superseded โดย AuthPage

### Modified
- `lib/core/router/app_router.dart` — `/login` → `AuthPage`, ลบ `/register` route, ลด isAuthRoute check เหลือแค่ `/login`
- `lib/core/router/app_routes.dart` — ลบ `register` / `registerName` constants

### Notes
- `flutter analyze` clean — No issues found
- BLoC / DI / redirect logic ไม่เปลี่ยน

---

## [2026-05-29] DeskIllustration: SVG asset replaces programmatic widget

### Added
- `assets/svg/desk_illustration.svg` — cozy desk scene: bookshelf, headphones, lamp, monitor (25:00 focus timer), mug with steam, plant, keyboard, mouse, sticky note. ใช้สี AppColors theme (sage green wall, warm wood desk, #1A1E2E monitor, #50E87A timer text)
- `pubspec.yaml` — เพิ่ม `flutter_svg: ^2.0.17`, เพิ่ม `assets/svg/` path

### Modified
- `lib/features/auth/presentation/widgets/desk_illustration.dart` — เปลี่ยนจาก programmatic Stack widget เป็น `SvgPicture.asset` (BoxFit.cover, double.infinity)

### Notes
- `flutter analyze` clean — No issues found
- Widget interface ไม่เปลี่ยน (const DeskIllustration()) — login/register page ไม่ต้องแก้

---

## [2026-05-29] Firestore user document on registration

### Added
- `pubspec.yaml` — เพิ่ม `cloud_firestore: ^6.4.1`
- `lib/features/auth/data/models/user_model.dart` — data model สำหรับ Firestore: uid, email, displayName, photoUrl, coins (0), xp (0), level (1), streak (0), createdAt (serverTimestamp)

### Modified
- `lib/features/auth/data/datasources/auth_remote_data_source.dart`
  - inject `FirebaseFirestore` เป็น 3rd constructor param
  - `createUserWithEmailAndPassword` → เรียก `_saveUserToFirestore` หลัง auth สำเร็จ
  - `signInWithGoogle` → เรียก `_saveUserToFirestore` เฉพาะ `additionalUserInfo?.isNewUser == true`
  - `_saveUserToFirestore` silent-fail (Firestore write failure ไม่ block auth — log ไว้ สร้าง doc ใหม่ตอน profile feature อ่านครั้งแรก)
- `lib/core/di/service_locator.dart` — register `FirebaseFirestore.instance`, pass เข้า `AuthRemoteDataSourceImpl`

### Notes
- Firestore collection: `users/{uid}`
- `flutter analyze` clean, 38/38 auth+home tests ผ่าน
- `widget_test.dart` fail เป็น pre-existing issue เดิม

---

## [2026-05-29] Firebase Analytics + Crashlytics integration

### Added
- `lib/core/analytics/analytics_service.dart` — abstract interface (setUserId, logScreenView, logEvent, recordError, addBreadcrumb)
- `lib/core/analytics/firebase_analytics_service.dart` — impl ที่ wrap `FirebaseAnalytics` + `FirebaseCrashlytics` ไว้ด้วยกัน

### Modified
- `lib/main.dart` — เพิ่ม Crashlytics global error handlers:
  - `FlutterError.onError` → `recordFlutterFatalError` (Flutter framework errors)
  - `PlatformDispatcher.instance.onError` → `recordError(fatal: true)` (uncaught async errors)
- `lib/core/di/service_locator.dart` — register `FirebaseAnalytics`, `FirebaseCrashlytics`, `AnalyticsService` (FirebaseAnalyticsService)
- `lib/features/auth/presentation/bloc/auth_bloc.dart` — inject `AnalyticsService`, track:
  - `setUserId(uid)` เมื่อ auth state เปลี่ยน (login/logout)
  - `logEvent('login', method: 'email'/'google')` เมื่อ sign in สำเร็จ
  - `logEvent('sign_up', method: 'email')` เมื่อ sign up สำเร็จ
  - `addBreadcrumb(...)` เมื่อ sign in/up/google ล้มเหลว
- `test/features/auth/presentation/bloc/auth_bloc_test.dart` — เพิ่ม `MockAnalyticsService` + stub methods ใน setUp

### Notes
- `flutter analyze` clean, auth tests 31/31 ผ่าน
- `widget_test.dart` fail เป็น pre-existing issue (Firebase ไม่ initialize ใน test env) — ไม่เกี่ยวกับ session นี้

---

## [2026-05-28] Auth unit tests — 31 tests, all passing

### Added
- `test/features/auth/domain/usecases/sign_in_with_email_password_test.dart` — 2 tests
- `test/features/auth/domain/usecases/sign_up_with_email_password_test.dart` — 2 tests
- `test/features/auth/domain/usecases/sign_in_with_google_test.dart` — 3 tests
- `test/features/auth/domain/usecases/sign_out_test.dart` — 2 tests
- `test/features/auth/data/repositories/auth_repository_impl_test.dart` — 12 tests (signIn, signUp, Google, signOut, stream, currentUser)
- `test/features/auth/presentation/bloc/auth_bloc_test.dart` — 10 tests (AuthStarted, signIn, signUp, Google, signOut)
- ใช้ `setUpAll { registerFallbackValue }` สำหรับ `SignInParams`, `SignUpParams`, `NoParams`

---

## [2026-05-28] Fix Google Sign-In on iOS — add URL scheme to Info.plist

### Fixed
- `ios/Runner/Info.plist` — เพิ่ม `CFBundleURLTypes` พร้อม `REVERSED_CLIENT_ID` ของทั้ง dev และ prod flavor
  - Dev: `com.googleusercontent.apps.377254767225-qlaekpp1l4jsh26p8kh4kunf2thu5cnp`
  - Prod: `com.googleusercontent.apps.377254767225-38hjplgm6do4isi52pbk23ncvuu7pa07`
- iOS ต้องมี URL scheme นี้เพื่อให้ Google Sign-In redirect กลับมาที่ app ได้หลัง OAuth flow

---

## [2026-05-28] Google Sign-In implementation

### Added
- `pubspec.yaml` — เพิ่ม `google_sign_in: ^6.2.2`
- `domain/usecases/sign_in_with_google.dart` — use case สำหรับ Google Sign-In
- `AuthGoogleSignInRequested` event ใน `auth_event.dart`
- `_onGoogleSignIn` handler ใน `AuthBloc`
- `signInWithGoogle()` ใน `AuthRemoteDataSource` + impl (flow: GoogleSignIn → credential → Firebase)
- `signInWithGoogle()` ใน `AuthRepository` interface + `AuthRepositoryImpl`
- Register `GoogleSignIn` singleton และ `SignInWithGoogle` use case ใน service locator
- Login page: Google button trigger `AuthGoogleSignInRequested` event จริงแทน stub

### Notes
- `signOut()` ทำ `GoogleSignIn.signOut()` พร้อมกันด้วยเพื่อ clear Google session

---

## [2026-05-28] Auth feature with Firebase — full Clean Architecture

### Added
- `lib/core/theme/app_colors.dart` — design tokens (background, primary, inputs, etc.)
- `lib/core/router/go_router_refresh_stream.dart` — ChangeNotifier wrapper for GoRouter refreshListenable
- `lib/core/error/failures.dart` — added `AuthFailure`, `ServerFailure`, `NetworkFailure`
- `lib/core/error/exceptions.dart` — added `AuthException`, `ServerException`

#### Auth feature (`lib/features/auth/`)
- **Domain**
  - `entities/auth_user.dart` — pure Dart entity (uid, email, displayName, photoUrl)
  - `repositories/auth_repository.dart` — abstract interface (authStateChanges, signIn, signUp, signOut)
  - `usecases/sign_in_with_email_password.dart` + `SignInParams`
  - `usecases/sign_up_with_email_password.dart` + `SignUpParams`
  - `usecases/sign_out.dart`
- **Data**
  - `datasources/auth_remote_data_source.dart` — Firebase Auth impl, maps error codes to readable messages
  - `repositories/auth_repository_impl.dart`
- **Presentation**
  - `bloc/auth_bloc.dart` + `auth_event.dart` + `auth_state.dart`
    - States: `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthUnauthenticated`, `AuthError`
    - Events: `AuthStarted`, `AuthSignInRequested`, `AuthSignUpRequested`, `AuthSignOutRequested`
  - `pages/login_page.dart` — cozy desk design, email/password form, Google/Apple buttons (stubbed)
  - `pages/register_page.dart` — email + password + confirm password
  - `widgets/desk_illustration.dart` — programmatic desk scene widget

### Modified
- `lib/core/router/app_routes.dart` — added `login`, `register` routes
- `lib/core/router/app_router.dart` — added auth routes + GoRouter redirect (unauthenticated → /login)
- `lib/core/di/service_locator.dart` — registered FirebaseAuth, AuthBloc, usecases, repo, datasource
- `lib/app/app.dart` — added `AuthBloc` provider, updated theme to use `AppColors`
- `lib/core/usecases/usecase.dart` — renamed type param `Type` → `T` (lint fix)

### Notes
- Google/Apple Sign-In UI buttons present but stubbed — requires `google_sign_in` / `sign_in_with_apple` packages (need approval)
- Router redirect is driven by `FirebaseAuth.instance.authStateChanges()` directly (no BLoC coupling at router level)
