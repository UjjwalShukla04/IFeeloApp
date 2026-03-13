# Backend Architecture & Data Layer

This document outlines the backend infrastructure, data schema, and repository pattern used in the Dating App.

## 🏗 Overview

The application uses **Firebase** as its primary backend-as-a-service (BaaS) solution, integrated via the **Repository Pattern**. This ensures a clean separation between the UI and the data source, allowing for easy switching between "Mock" (dev) and "Real" (production) implementations.

### Core Technologies

- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore (NoSQL)
- **Storage**: Firebase Storage (Images/Media)
- **State Management**: Flutter Riverpod (for dependency injection of repositories)

---

## 🔌 Repository Pattern

We use a strict interface-based approach to handle data.

### 1. Abstraction

Each feature has a repository `interface` (abstract class) defining the contract.
_Example:_

```dart
abstract class ProfileRepository {
  Future<String> uploadImage(String userId, XFile imageFile);
  Future<void> createProfile(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getProfile(String userId);
}
```

### 2. Implementation Strategy

- **Mock Implementation (`MockProfileRepository`)**:
  - Used currently for UI development.
  - Stores data in-memory (RAM).
  - Simulates network delays (1-2s).
  - Allows development without internet or Firebase setup.

- **Real Implementation (`RealProfileRepository`)**:
  - Connects to actual Firebase services.
  - Handles errors, caching, and network requests.
  - _Ready to be swapped in via the Riverpod Provider._

---

## 🗄 Database Schema (Firestore)

The database is structured using **Cloud Firestore**. Below are the core collections and document structures.

### `users` Collection

Stores public and private user profile information.
**Document ID**: `uid` (from Firebase Auth)

```json
{
  "uid": "string (unique)",
  "name": "string",
  "email": "string",
  "birthDate": "timestamp",
  "gender": "string",
  "bio": "string",
  "interests": ["string", "string"],
  "imageUrls": ["url1", "url2"],
  "location": {
    "latitude": number,
    "longitude": number
  },
  "preferences": {
    "lookingFor": "string (e.g., Relationship, Casual)",
    "ageRange": [18, 30]
  },
  "isVerified": boolean,
  "isPremium": boolean,
  "createdAt": "serverTimestamp",
  "lastActive": "timestamp"
}
```

### `matches` Collection (Planned)

Stores successful matches between users.

```json
{
  "users": ["uid1", "uid2"],
  "timestamp": "serverTimestamp",
  "lastMessage": "string",
  "lastMessageTime": "timestamp"
}
```

### `chats` Collection (Planned)

Sub-collection or top-level collection for messages.

```json
{
  "matchId": "string",
  "messages": [
    {
      "senderId": "uid",
      "text": "string",
      "timestamp": "serverTimestamp",
      "read": boolean
    }
  ]
}
```

---

## 🔐 Authentication Flow

1.  **Sign Up**:
    - User enters Email/Password.
    - `AuthRepository` creates user in Firebase Auth.
    - On success, navigates to **Onboarding**.
2.  **Profile Creation**:
    - User completes onboarding steps (Name, Photos, Bio).
    - Data is aggregated and sent to `ProfileRepository.createProfile`.
    - User document is created in `users` collection.
3.  **Session Management**:
    - App listens to `authStateChanges` stream.
    - Automatically redirects to **Home** or **Login** based on state.

---

## 📂 Storage Structure

Images are stored in **Firebase Storage** with the following hierarchy to ensure security and organization.

```
/user_images
    /{userId}
        /timestamp_1.jpg
        /timestamp_2.jpg
```

- **Security Rules**: Users can only read/write to their own folder. Public read access is granted for profile display.

---

## 🔄 Switching to Real Backend

To switch from Mock to Real data, update the Provider in the respective data file.

**File:** `lib/features/profile/data/profile_repository.dart`

**Change From:**

```dart
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => MockProfileRepository(),
);
```

**To:**

```dart
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => RealProfileRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance
  ),
);
```

_(Note: Ensure `firebase_options.dart` is generated and initialized in `main.dart` before switching.)_
