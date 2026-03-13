class UserModel {
  final String id;
  final String name;
  final int age;
  final String bio;
  final List<String> imageUrls;
  final List<String> interests;
  final String jobTitle;
  final String company;
  final String location;
  final int distanceKm;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.imageUrls,
    required this.interests,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.distanceKm,
  });
}

class ChatModel {
  final String id;
  final UserModel user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}
