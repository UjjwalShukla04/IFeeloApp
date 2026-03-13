import '../models/mock_models.dart';

class MockData {
  static final List<UserModel> users = [
    UserModel(
      id: '1',
      name: 'Jessica',
      age: 24,
      bio: 'Loves hiking, coffee, and good conversations. Looking for someone to explore the city with.',
      imageUrls: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
      ],
      interests: ['Hiking', 'Coffee', 'Travel', 'Photography'],
      jobTitle: 'UX Designer',
      company: 'Google',
      location: 'New York, USA',
      distanceKm: 5,
    ),
    UserModel(
      id: '2',
      name: 'Sarah',
      age: 22,
      bio: 'Art student. I paint my own reality. Let\'s go to a museum!',
      imageUrls: [
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=800&q=80',
      ],
      interests: ['Art', 'Museums', 'Wine', 'Music'],
      jobTitle: 'Student',
      company: 'NYU',
      location: 'Brooklyn, NY',
      distanceKm: 12,
    ),
    UserModel(
      id: '3',
      name: 'Emily',
      age: 26,
      bio: 'Tech enthusiast by day, gamer by night. I can beat you at Mario Kart.',
      imageUrls: [
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=800&q=80',
      ],
      interests: ['Gaming', 'Tech', 'Coding', 'Pizza'],
      jobTitle: 'Software Engineer',
      company: 'Spotify',
      location: 'Manhattan, NY',
      distanceKm: 3,
    ),
  ];

  static final List<ChatModel> chats = [
    ChatModel(
      id: '1',
      user: users[0], // Jessica
      lastMessage: 'Hey! Are we still on for coffee?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    ChatModel(
      id: '2',
      user: users[1], // Sarah
      lastMessage: 'That painting looks amazing!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
  ];
}
