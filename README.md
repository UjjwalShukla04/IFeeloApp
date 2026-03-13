# Dating App - Flutter Project

A modern, feature-rich dating application built with Flutter, designed to provide a seamless and emotionally intelligent user experience.

## 🏗 Architecture

This project follows a **Feature-First Architecture** combined with **Riverpod** for state management. This ensures scalability, maintainability, and clear separation of concerns.

### Core Principles
- **Layered Separation**: Each feature (e.g., Auth, Chat, Home) is self-contained with its own Presentation, Domain, and Data layers.
- **State Management**: Uses `flutter_riverpod` for dependency injection and reactive state management.
- **Navigation**: Uses `go_router` for declarative routing and deep linking.
- **Repository Pattern**: Abstracts data sources (API/Firebase) from the UI.

### Folder Structure
```
lib/
├── core/                   # Shared resources across the app
│   ├── theme/              # App themes, colors, and text styles
│   ├── widgets/            # Reusable common widgets (buttons, fields)
│   └── models/             # Shared data models
├── features/               # Feature modules
│   ├── auth/               # Authentication (Login, Sign Up)
│   ├── home/               # Home feed, Matching, User Details
│   ├── chat/               # Messaging & Emotional Assistant
│   └── profile/            # User Profile management
├── router/                 # Navigation configuration (GoRouter)
└── main.dart               # App entry point
```

---

## 🚀 Key Features

### 1. Authentication & Onboarding
- **Secure Login/Signup**: Email and password authentication flow.
- **Onboarding**: Smooth onboarding experience for new users.
- **State Persistence**: Auto-login functionality using persistent auth state.

### 2. Smart Profile Management
- **Detailed Profiles**: Users can add photos, bio, interests, and "looking for" details.
- **Visual Editing**: Easy-to-use interface for updating profile information.
- **Perfect Date & Dreams**: Unique sections to share "Perfect Date" ideas and life goals.

### 3. Matching & Discovery (Home)
- **Interactive Feed**: Swipe or browse through potential matches.
- **Detailed Views**: Click to view full profiles including interests and gallery.
- **Match Notifications**: "It's a Match!" screen animations when mutual interest occurs.

### 4. Real-time Chat
- **Messaging Interface**: Modern chat UI with typing indicators and timestamps.
- **Mock Simulations**: (Currently) Simulates incoming messages for testing interactions.

### 5. 🧠 Emotional Intelligence Assistant (Unique Feature)
A built-in AI companion to help users navigate relationship dynamics.
- **Contextual Analysis**: Users input their emotion, their partner's emotion, and the relationship stage.
- **Tailored Advice**: Provides:
  - **Emotional Context**: What the dynamic means.
  - **Needs**: What both parties likely need.
  - **Tone Suggestions**: How to communicate effectively.
  - **Cautions**: Gentle warnings on what to avoid.
- **Accessible**: Integrated directly into the chat screen via the "Brain" icon.

---

## 🛠 Tech Stack

- **Framework**: Flutter (Web & Mobile)
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Backend/Services**: Firebase (Auth, Firestore, Storage) - *Integration in progress*
- **UI Components**: Material Design with custom theming
- **Utilities**: `flutter_card_swiper`, `cached_network_image`, `google_fonts`

## 🚦 Getting Started

1.  **Prerequisites**: Ensure you have Flutter SDK installed.
2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```
    For web:
    ```bash
    flutter run -d chrome
    ```

## 🤝 Contribution
The project is structured to allow multiple developers to work on different features simultaneously without conflict. Always follow the `feature-first` folder structure when adding new capabilities.
