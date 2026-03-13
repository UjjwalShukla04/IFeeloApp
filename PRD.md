# Product Requirements Document (PRD) - IFeelo

**Version:** 1.0
**Status:** Draft
**Last Updated:** 2024-10-27

---

## 1. Introduction

### 1.1 Purpose
The purpose of this document is to outline the product requirements for **IFeelo**, a dating application that integrates emotional intelligence into the matchmaking and conversation process. This document serves as a guide for design, development, and QA teams.

### 1.2 Vision
To create meaningful connections by prioritizing emotional awareness and communication compatibility over superficial swiping, helping users understand their own feelings and those of their matches.

### 1.3 Target Audience
- Young adults and professionals (ages 18-35) seeking serious or meaningful relationships.
- Users who value emotional maturity and communication skills.
- Individuals tired of the "hookup culture" associated with traditional swipe-based apps.

---

## 2. Product Scope

### 2.1 In Scope (MVP)
- **Authentication:** Email/Password, Google Sign-In, Phone Number.
- **Onboarding:** User profile creation (photos, bio, interests, job).
- **Discovery:** Card-based swiping interface (Like/Nope/Super Like).
- **Matching:** Mutual like mechanism to create matches.
- **Messaging:** Real-time text chat with matched users.
- **Emotional Intelligence Assistant:**
    - "How are you feeling?" prompt upon opening a chat.
    - Emotional tracking dashboard (basic).
    - Contextual emotional aid button in chat.

### 2.2 Out of Scope (for v1.0)
- Video/Audio calling.
- Advanced AI-driven match compatibility scores.
- Premium subscription tiers (Gold/Platinum features).
- Social media feed integration (Instagram/Spotify).

---

## 3. Functional Requirements

### 3.1 Authentication & Onboarding
| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| **FR-01** | Splash Screen | Display "IFeelo" logo for 10 seconds before navigating to onboarding. |
| **FR-02** | Social Login | Users can sign up/login using Google. |
| **FR-03** | Email Signup | Users can create an account with Email, Password, Name. |
| **FR-04** | Profile Creation | Users must upload at least 1 photo and enter a display name and DOB. |

### 3.2 Discovery (Home)
| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| **FR-05** | Swipe Interface | Users see a stack of candidate cards. Swipe Right = Like, Left = Pass, Up = Super Like. |
| **FR-06** | Profile Details | Tapping a card opens the full profile view (Bio, Interests, Distance). |
| **FR-07** | Match Logic | If User A likes User B and User B has already liked User A, trigger "It's a Match" screen. |

### 3.3 Chat & Messaging
| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| **FR-08** | Match List | Users can view a list of all mutual matches. |
| **FR-09** | Chat Interface | Users can send and receive text messages. |
| **FR-10** | Message History | Chat history is preserved and loaded upon opening the chat. |
| **FR-11** | Unread Indicators | Visual indicator for new/unread messages in the match list. |

### 3.4 Emotional Intelligence (Unique Selling Point)
| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| **FR-12** | Feeling Prompt | When opening a chat, a dialog asks "How are you feeling?" with options (Happy, Anxious, Excited, etc.). |
| **FR-13** | EI Assistant Icon | A persistent icon in the chat header allows users to re-open the feeling dialog or access emotional tips. |
| **FR-14** | Feeling Data | User's selected feeling is recorded (internal only for MVP) to help the system learn context. |

---

## 4. Non-Functional Requirements

### 4.1 Performance
- **App Load Time:** < 2 seconds (after splash).
- **Swipe Latency:** < 100ms response time for card swipes.
- **Chat Real-time:** Messages should appear within < 1 second of sending.

### 4.2 Security
- **Data Encryption:** All personal data encrypted at rest and in transit (HTTPS/TLS).
- **Auth:** Secure token management (JWT) for session handling.

### 4.3 Compatibility
- **OS Support:** iOS 15+, Android 10+.
- **Device Support:** Optimized for standard phone sizes; tablet support not required for MVP.

---

## 5. UI/UX Guidelines

### 5.1 Color Palette
- **Primary:** `#E94057` (Passion Red/Pink)
- **Secondary:** `#F27121` (Warm Orange)
- **Background:** White / Light Grey
- **Text:** Dark Grey / Black

### 5.2 Key Interactions
- **Swiping:** Smooth, physics-based card movement.
- **Dialogs:** Rounded corners (`24px` radius), centered modals for emotional prompts.
- **Navigation:** Bottom navigation bar or clear back buttons for deep hierarchies.

---

## 6. Analytics & Metrics (KPIs)
- **Daily Active Users (DAU)**
- **Retention Rate:** % of users returning after Day 1, Day 7, Day 30.
- **Match Rate:** % of swipes that result in a match.
- **EI Engagement:** % of chat sessions where users interact with the "How are you feeling?" prompt.

---

## 7. Roadmap (Future Considerations)
- **v1.1:** Push Notifications for matches and messages.
- **v1.2:** "Mood Match" – suggesting matches based on current emotional state.
- **v2.0:** AI Chat Coach – real-time suggestions to improve conversation quality based on emotional context.
