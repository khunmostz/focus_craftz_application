# Focus Craftz — What's Next

> อ่านเพื่อเรียนรู้ทิศทาง ยังไม่ต้องโค้ดทั้งหมดในที ค่อยๆ ทำทีละ feature

---

## สถานะปัจจุบัน (2026-05-30)

### Auth ✅ Done
| ส่วน | สถานะ |
|------|--------|
| Email / Password Sign In + Sign Up | ✅ |
| Google Sign In | ✅ |
| Firestore: สร้าง user doc ตอน register | ✅ |
| Analytics + Crashlytics | ✅ |
| AuthPage (single page, toggle sign in/register) | ✅ |
| Forgot Password | ❌ ยังไม่ได้ทำ |
| Display Name field ตอน register | ❌ ยังไม่ได้ทำ |

### Profile Feature — Domain + Data ✅ Done, UI ❌ ยังไม่ได้ทำ
| ส่วน | สถานะ |
|------|--------|
| `UserProfile` entity + schema ครบ | ✅ |
| `UserProfileRepository` (abstract + impl) | ✅ |
| `GetUserProfile` / `CreateUserProfile` use cases | ✅ |
| `UserProfileModel` (Firestore toMap/fromMap) | ✅ |
| `UserProfileRemoteDataSource` (Firestore) | ✅ |
| `ProfileBloc` + event + state | ✅ |
| Profile Screen UI (page + widgets) | ❌ |

### อื่นๆ ❌ ยังไม่ได้ทำ
| ส่วน | สถานะ |
|------|--------|
| Firestore Security Rules | ❌ สำคัญมาก ทำก่อน production |
| Home Screen | ❌ |
| Focus Timer Screen | ❌ |
| Market Screen | ❌ |
| Leaderboard Screen | ❌ |

---

## ลำดับที่แนะนำ (เรียงตาม priority)

```
1. Auth polish                          ← ~1 session (เล็กน้อยแต่ควรปิดให้จบ)
   - Display Name field ในฟอร์ม register
   - Forgot Password (bottom sheet + SendPasswordResetEmail use case)

2. Firestore Security Rules             ← ทำก่อน push production เด็ดขาด
   - rules อยู่ท้าย file นี้แล้ว พร้อม deploy

3. Home Screen                          ← เห็นผลทันที, ต้องใช้ UserProfile data
   - HomeBloc: FetchUserStats + FetchRecentSessions
   - UI: greeting, stats row (coins/xp/level), streak, Start Focusing CTA, recent sessions

4. Focus Timer                          ← core loop ของ app
   - FocusBloc: timer tick, pause/resume/stop, complete
   - UseCase: SaveFocusSession (write to focus_sessions + update users/{uid})
   - Coins/XP formula ดูที่ section ด้านล่าง

5. Profile Screen UI                    ← domain/data พร้อมแล้ว แค่ต้องสร้าง page
   - ProfilePage: avatar, level, XP progress bar, streak, total minutes
   - ต้องมี focus session data จาก step 4 ก่อนถึงจะ meaningful

6. Market Screen                        ← ต้อง seed items ใน Firestore ก่อน
   - ItemBloc: FetchItems (by category), PurchaseItem
   - InventoryBloc: FetchInventory, EquipItem

7. Leaderboard                          ← ต้องมี users หลายคนถึงจะ test ได้จริง
   - query users orderBy weeklyFocusMinutes desc limit 50
```

---

## Firestore Schema (reference)

### Collection: `users/{uid}`
```
uid:                 string
email:               string
displayName:         string?
photoUrl:            string?
coins:               int
xp:                  int
level:               int
streak:              int
lastFocusDate:       Timestamp?
totalFocusMinutes:   int
weeklyFocusMinutes:  int      ← reset ทุกวันจันทร์ (leaderboard)
weekStartDate:       Timestamp
createdAt:           Timestamp
updatedAt:           Timestamp
```

### Collection: `focus_sessions/{sessionId}`
```
uid:           string
durationSecs:  int
targetSecs:    int
completed:     bool
coinsEarned:   int
xpEarned:      int
completedAt:   Timestamp
weekId:        string   — เช่น "2026-W22"
```

### Collection: `items/{itemId}` (Global Catalog — seed โดย developer)
```
name:        string
description: string
category:    string    — "keyboard" | "plant" | "lamp" | "monitor_theme" | "decoration"
price:       int
imageUrl:    string
unlockLevel: int
sortOrder:   int
isActive:    bool
```

### Subcollection: `users/{uid}/inventory/{itemId}`
```
purchasedAt:  Timestamp
isEquipped:   bool
slot:         string?
```

---

## Focus Timer Logic

### Coins Formula
```
baseCoins  = floor(durationSecs / 60)   // 1 coin ต่อนาที
bonusCoins = completed ? 5 : 0          // bonus ถ้าครบ target
streakBonus = streak >= 7 ? 3 : 0      // bonus สำหรับ streak 7+ วัน
totalCoins  = baseCoins + bonusCoins + streakBonus
```

### Streak Logic
```
ถ้า lastFocusDate == วานนี้ → streak++
ถ้า lastFocusDate == วันนี้ → ไม่เปลี่ยน (already counted)
ถ้า lastFocusDate เก่ากว่าวานนี้ หรือ null → streak = 1
```

### weeklyFocusMinutes Reset
- ตรวจ `weekStartDate` เทียบกับ Monday ของสัปดาห์ปัจจุบัน
- ถ้าต่างสัปดาห์ → reset `weeklyFocusMinutes = 0`, อัปเดต `weekStartDate`
- logic นี้ควรอยู่ใน `SaveFocusSession` use case

---

## UI Wireframes

### Home Screen
```
┌─────────────────────────────┐
│  👋 Good morning, Mozi!     │  ← greeting + displayName
│  🔥 5 day streak            │
│                             │
│  ┌───┐  ┌───┐  ┌────────┐  │
│  │ 💰│  │⭐ │  │ Level  │  │  ← stats row
│  │240│  │ 3 │  │   4    │  │
│  └───┘  └───┘  └────────┘  │
│                             │
│  ┌─────────────────────┐   │
│  │  🕐  Start Focusing │   │  ← CTA → Focus Timer
│  └─────────────────────┘   │
│                             │
│  Recent sessions            │
│  ┌─────────────────────┐   │
│  │ 25 min · +10 coins  │   │
│  │ Today, 9:30 AM      │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
```

### Focus Timer Screen
```
┌─────────────────────────────┐
│         Focus Time          │
│                             │
│       ┌───────────┐         │
│       │  25:00    │         │  ← countdown (วงกลม progress)
│       └───────────┘         │
│                             │
│  [  25 min  ] [  50 min  ]  │  ← preset buttons
│  [  Custom  ]               │
│                             │
│    [ ▶ Start ]              │  ← Start / Pause / Resume / Stop
│                             │
│  +10 coins when done 🪙     │  ← preview reward
└─────────────────────────────┘
```

### Profile Screen
```
┌─────────────────────────────┐
│  [← back]        [edit ✏️]  │
│                             │
│      [avatar]               │
│      Mozi                   │
│      Level 4 · 240 coins    │
│                             │
│  ━━━━━ XP Progress ━━━━━    │
│  [████████░░░░] 380/500 XP  │
│                             │
│  🔥 Streak: 5 days          │
│  ⏱ Total: 1,240 minutes    │
│                             │
│  — My Workspace —           │
│  [desk preview with items]  │
│                             │
│  — Achievements —           │
│  [🏆] First Focus           │
│  [🔒] 7-Day Streak          │
└─────────────────────────────┘
```

### Market Screen
```
┌─────────────────────────────┐
│  Market      💰 240 coins   │
│                             │
│  [Keyboard] [Plants] [Lamps]│  ← category filter
│                             │
│  ┌─────────┐ ┌─────────┐   │
│  │ [img]   │ │ [img]   │   │
│  │ Sakura  │ │ Bamboo  │   │
│  │ 80 🪙  │ │ 40 🪙  │   │
│  │[Buy/✓] │ │[Buy/✓] │   │
│  └─────────┘ └─────────┘   │
└─────────────────────────────┘
```

### Leaderboard Screen
```
┌─────────────────────────────┐
│  Leaderboard  This Week     │
│                             │
│  🥇  Alice      8h 20m      │
│  🥈  Bob        7h 45m      │
│  🥉  Charlie    6h 00m      │
│  4.  Mozi       4h 30m  ←you│
│  5.  Dave       3h 10m      │
└─────────────────────────────┘
```
Query: `users` orderBy `weeklyFocusMinutes` desc, limit 50

---

## Firestore Security Rules (deploy ก่อน production!)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // users: อ่านได้ทุกคน (leaderboard), แก้ได้เฉพาะตัวเอง
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == uid;

      // inventory: เจ้าของเท่านั้น
      match /inventory/{itemId} {
        allow read, write: if request.auth != null && request.auth.uid == uid;
      }
    }

    // focus_sessions: อ่าน/เขียนได้เฉพาะ session ของตัวเอง
    match /focus_sessions/{sessionId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == resource.data.uid;
      allow create: if request.auth != null
                    && request.auth.uid == request.resource.data.uid;
    }

    // items: ทุกคนอ่านได้, ห้ามแก้จาก client
    match /items/{itemId} {
      allow read: if request.auth != null;
      allow write: if false; // admin SDK only
    }
  }
}
```
