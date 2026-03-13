# API Contract for Dating App (IFeelo)

## Base URL

`https://api.ifeelo.com/v1` (Example)

## Authentication

### 1. Login with Email

**Endpoint:** `POST /auth/login`
**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (200 OK):**

```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "user_123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

### 2. Sign Up with Email

**Endpoint:** `POST /auth/signup`
**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response (201 Created):**

```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "user_123",
    "email": "user@example.com"
  }
}
```

### 3. Check User Existence (for Social Auth)

**Endpoint:** `GET /auth/check-exists/:uid`
**Response (200 OK):**

```json
{
  "exists": true,
  "user": {
    "id": "user_123",
    "email": "user@example.com"
  }
}
```

## Users & Profile

### 1. Get User Profile (Self)

**Endpoint:** `GET /users/me`
**Headers:** `Authorization: Bearer <token>`
**Response (200 OK):**

```json
{
  "id": "user_123",
  "name": "John Doe",
  "age": 28,
  "bio": "Love hiking and coffee",
  "imageUrls": ["url1.jpg", "url2.jpg"],
  "interests": ["Hiking", "Coffee", "Tech"],
  "jobTitle": "Software Engineer",
  "company": "Tech Corp",
  "location": "New York, USA",
  "distanceKm": 5
}
```

### 2. Update Profile

**Endpoint:** `PUT /users/me`
**Request Body:**

```json
{
  "bio": "Updated bio...",
  "interests": ["Hiking", "Photography"]
}
```

### 3. Get Discovery Feed (Potential Matches)

**Endpoint:** `GET /users/feed`
**Query Params:** `?limit=20&offset=0`
**Response (200 OK):**

```json
{
  "users": [
    {
      "id": "user_456",
      "name": "Jane Smith",
      "age": 26,
      "bio": "Travel enthusiast",
      "imageUrls": ["url3.jpg"],
      "location": "New York, USA",
      "distanceKm": 2
    }
  ]
}
```

## Matches & Chat

### 1. Get Matches / Conversations

**Endpoint:** `GET /matches`
**Response (200 OK):**

```json
{
  "matches": [
    {
      "id": "match_789",
      "user": {
        "id": "user_456",
        "name": "Jane Smith",
        "imageUrls": ["url3.jpg"]
      },
      "lastMessage": "Hey! How are you?",
      "lastMessageTime": "2023-10-27T10:00:00Z",
      "unreadCount": 1
    }
  ]
}
```

### 2. Get Messages

**Endpoint:** `GET /matches/:matchId/messages`
**Query Params:** `?limit=50&before=<timestamp>`
**Response (200 OK):**

```json
{
  "messages": [
    {
      "id": "msg_001",
      "text": "Hey! How are you?",
      "senderId": "user_456",
      "time": "2023-10-27T10:00:00Z",
      "isRead": true
    }
  ]
}
```

### 3. Send Message

**Endpoint:** `POST /matches/:matchId/messages`
**Request Body:**

```json
{
  "text": "I'm doing great, thanks!"
}
```

**Response (201 Created):**

```json
{
  "id": "msg_002",
  "text": "I'm doing great, thanks!",
  "senderId": "user_123",
  "time": "2023-10-27T10:05:00Z"
}
```

## Emotional Intelligence

### 1. Submit Feeling

**Endpoint:** `POST /emotional-aid/feeling`
**Request Body:**

```json
{
  "matchId": "match_789",
  "feeling": "Excited",
  "note": "Great conversation so far!"
}
```

**Response (200 OK):**

```json
{
  "status": "recorded"
}
```
