# Dating App Backend Architecture

## 1. Technology Stack Selection
We have chosen **Node.js + Express + MongoDB** for this backend.

### Why MongoDB over PostgreSQL?
1.  **Flexible Schema**: User profiles in dating apps often evolve (adding new interest tags, changing preferences, adding prompts). MongoDB's document model handles this without complex migrations.
2.  **Geospatial Performance**: MongoDB's `$near` and `$geoWithin` operators are highly optimized for "find users near me" queries, which is the core of a dating app.
3.  **Write Throughput**: "Swiping" generates a massive amount of write operations (User A likes User B). MongoDB handles high write loads efficiently.
4.  **JSON Native**: Seamless integration with the Node.js backend and Flutter frontend (which consumes JSON).

## 2. Architecture & Folder Structure
We will follow a **Controller-Service-Model** pattern (or simplified MVC) to keep logic clean.

```
backend/
├── src/
│   ├── config/             # DB connection, Environment variables
│   ├── controllers/        # Request handling logic (req, res)
│   ├── middleware/         # Auth check, Validation, Error handling
│   ├── models/             # Mongoose Schemas (DB Design)
│   ├── routes/             # API Route definitions
│   ├── sockets/            # Socket.io event handlers (Chat, Status)
│   ├── utils/              # Helper functions (Token gen, Distance calc)
│   ├── app.js              # Express App setup (Middleware, Routes)
│   └── server.js           # Server entry point (HTTP + Socket)
├── .env                    # Secrets (Not committed)
├── package.json            # Dependencies
└── README.md               # Documentation
```

## 3. Database Schema (MongoDB)

### 3.1 User Model
-   **_id**: ObjectId
-   **email**: String (Unique, Indexed)
-   **passwordHash**: String
-   **profile**: {
        name: String,
        dob: Date,
        gender: String,
        bio: String,
        photos: [String],
        interests: [String],
        jobTitle: String
    }
-   **preferences**: {
        gender: String,
        minAge: Number,
        maxAge: Number,
        maxDistance: Number
    }
-   **location**: {
        type: "Point",
        coordinates: [Longitude, Latitude] // 2dsphere Index
    }
-   **status**: {
        isOnline: Boolean,
        lastSeen: Date
    }

### 3.2 Swipe Model
-   **_id**: ObjectId
-   **swiperId**: ObjectId (Ref: User)
-   **swipedId**: ObjectId (Ref: User)
-   **action**: String ('like', 'dislike', 'superlike')
-   **timestamp**: Date

### 3.3 Match Model
-   **_id**: ObjectId
-   **users**: [ObjectId] (Array of 2 Users)
-   **lastMessage**: { text: String, sender: ObjectId, timestamp: Date }
-   **timestamp**: Date (Created At)

### 3.4 Message Model
-   **_id**: ObjectId
-   **matchId**: ObjectId (Ref: Match)
-   **senderId**: ObjectId (Ref: User)
-   **text**: String
-   **status**: String ('sent', 'delivered', 'read')
-   **timestamp**: Date

## 4. Key Algorithms

### 4.1 Matching Logic (The Feed)
1.  **Filter**: Find users where:
    -   `location` is within `currentUser.preferences.maxDistance` (using `$near`).
    -   `age` is within range.
    -   `gender` matches preference.
2.  **Exclusion**: Exclude users already present in `Swipe` collection where `swiperId` == `currentUserId`.
3.  **Ranking** (Optional): Boost users with "superlike" or shared interests.

### 4.2 Real-time Chat
-   **Socket.io** namespaces/rooms based on `matchId`.
-   Events: `join_room`, `send_message`, `receive_message`, `typing`, `stop_typing`, `message_read`.

## 5. Security Best Practices
-   **Helmet**: Sets secure HTTP headers.
-   **Rate Limiting**: Prevents brute-force on login/registration.
-   **Bcrypt**: Hashing passwords with salt.
-   **JWT**: Short-lived access tokens (15m) + Long-lived refresh tokens (7d).
-   **Input Validation**: Joi or express-validator to sanitize all inputs.
