# Dating App Architecture & Roadmap

## 1. Feature Breakdown

### MVP (Minimum Viable Product)
- **Authentication**: Phone Auth (OTP) via Firebase, Social Login (Google/Apple).
- **Onboarding**: Name, DOB, Gender, Interests, Photos, Bio.
- **Geolocation**: Get user location, calculate distance between users.
- **Matching**: Swipe Left/Right (Tinder-style), Mutual Match logic.
- **Messaging**: Real-time chat for matched users (Text, Image).
- **Profile**: Edit profile, view own profile.
- **Settings**: Discovery preferences (Distance, Age Range, Gender).

### Advanced Features (Phase 2)
- **Super Like**: Highlight profile to the other user.
- **Boost**: Show profile to more users for 30 mins.
- **Video/Voice Call**: WebRTC integration.
- **Verification**: Selfie verification with AI or manual review.
- **Subscription**: Tinder Gold/Plus equivalent (See who liked you, rewind swipes).
- **Push Notifications**: New match, new message.

## 2. App Architecture

We will use a **Feature-First** architecture with **Riverpod** for state management. This ensures scalability and separation of concerns.

```
lib/
├── main.dart                  # Entry point
├── core/                      # Shared code
│   ├── constants/             # App-wide constants
│   ├── theme/                 # AppTheme
│   ├── utils/                 # Helpers (validators, date formatters)
│   ├── widgets/               # Reusable UI components (Buttons, Input fields)
│   └── services/              # Global services (Storage, Analytics)
├── features/
│   ├── auth/                  # Authentication Feature
│   │   ├── data/              # Repositories & Data Sources
│   │   ├── domain/            # Models & Entities
│   │   └── presentation/      # UI & Controllers (Riverpod Providers)
│   ├── onboarding/
│   ├── home/                  # Swipe functionality
│   ├── chat/                  # Messaging
│   ├── profile/               # User Profile & Edit
│   └── premium/               # Subscription & Payments
└── router/                    # GoRouter configuration
```

## 3. Firebase DB Schema (Firestore)

### `users` (Collection)
```json
{
  "uid": "string (PK)",
  "phoneNumber": "string",
  "displayName": "string",
  "dob": "timestamp",
  "gender": "string (male/female/other)",
  "interestedIn": "string (male/female/everyone)",
  "photos": ["url1", "url2"],
  "bio": "string",
  "location": {
    "geohash": "string",
    "lat": number,
    "lng": number
  },
  "fcmToken": "string",
  "isVerified": boolean,
  "isPremium": boolean,
  "createdAt": "timestamp"
}
```

### `swipes` (Collection)
```json
{
  "id": "string (PK)",
  "swiperId": "string (FK -> users.uid)",
  "targetId": "string (FK -> users.uid)",
  "action": "string (like/nope/superlike)",
  "timestamp": "timestamp"
}
```

### `matches` (Collection)
```json
{
  "id": "string (PK)",
  "users": ["uid1", "uid2"],
  "lastMessage": "string",
  "lastMessageTime": "timestamp",
  "createdAt": "timestamp"
}
```

### `messages` (Sub-collection of `matches`)
`matches/{matchId}/messages/{messageId}`
```json
{
  "senderId": "string",
  "text": "string",
  "imageUrl": "string (optional)",
  "seen": boolean,
  "timestamp": "timestamp"
}
```

## 4. Matching Algorithm Logic

1.  **Filtering**: Query `users` collection.
    -   Exclude current user.
    -   Filter by `interestedIn` matching `gender`.
    -   Filter by `gender` matching `interestedIn`.
    -   Filter by `age` range (calculated from DOB).
2.  **Geo-query**: Use `geoflutterfire` (or simple lat/lng bounding box) to find users within `maxDistance`.
3.  **Exclusion**: Exclude users already swiped (check local cache or query `swipes` collection where `swiperId == currentUserId`).
4.  **Ranking** (Optional for MVP): Rank by "Active recently", "Elo score" (popularity), or "Newest".
5.  **Pagination**: Fetch in batches of 10-20.

## 5. Timeline Roadmap

-   **Week 1**: Project Setup, Architecture, Authentication (Phone), Onboarding UI & Logic.
-   **Week 2**: Profile Creation (Photo Upload), Geolocation setup, Firestore Database setup.
-   **Week 3**: Home Screen (Swipe Card UI), Matching Logic (Backend/Cloud Functions).
-   **Week 4**: Chat System (Real-time), Push Notifications.
-   **Week 5**: Settings, User Blocking/Reporting, Subscription UI.
-   **Week 6**: Testing, Bug Fixing, Polish UI, Deployment to Play Store.

## 6. Monetization Strategy

-   **Freemium Model**: Free to swipe and chat.
-   **Subscriptions**:
    -   **Unlimited Swipes**: Remove daily limit.
    -   **Rewind**: Undo last swipe.
    -   **Passport**: Change location to swipe in other cities.
    -   **See Who Likes You**: Reveal blurred profiles.
-   **In-App Purchases**:
    -   **Super Likes**: Buy packs of 5/10.
    -   **Profile Boost**: Be top profile in area for 30 mins.
-   **Ads**: Native ads between swipes (careful not to ruin UX).
