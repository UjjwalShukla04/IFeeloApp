import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert'; // Import for Base64
import '../data/profile_repository.dart';
import '../../auth/data/auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Helper method to build image from Network or Base64
  Widget _buildProfileImage(String imageUrl, {double? width, double? height}) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64Data = imageUrl.split(',')[1];
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        );
      } catch (e) {
        return const Icon(Icons.error, color: Colors.red);
      }
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final uid = user?.uid ?? 'mock_user_123';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/profile/settings'),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ref.read(profileRepositoryProvider).getProfile(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;
          final displayName = data?['displayName'] ?? 'New User';
          final bio = data?['bio'] ?? 'No bio yet';
          final photos = (data?['photos'] as List?) ?? [];
          final interests =
              (data?['interests'] as List?)?.cast<String>() ?? <String>[];
          final profilePhoto = photos.isNotEmpty
              ? photos.first
              : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=60';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _buildProfileImage(
                          profilePhoto,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE94057),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => context.go('/profile/edit'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '$displayName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(bio),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Photos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    if (index < photos.length) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _buildProfileImage(photos[index]),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Icon(Icons.add, color: Colors.grey),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _ProfileInfoSection(
                  title: 'About me',
                  chips: const [
                    '160 cm',
                    'Almost never',
                    'Graduate degree',
                    'Rarely',
                    'No',
                    'Woman',
                    'Want kids',
                    "Don't have kids",
                    'Cancer',
                    'Moderate',
                    'she/her',
                    'Hindu',
                  ],
                ),
                const SizedBox(height: 16),
                _ProfileInfoSection(
                  title: "I'm looking for",
                  chips: const [
                    'Fun, casual dates',
                    'Confidence',
                    'Sassiness',
                    'Loyalty',
                  ],
                ),
                const SizedBox(height: 16),
                _ProfileInfoSection(
                  title: 'My interests',
                  chips: interests.isNotEmpty
                      ? interests
                      : const [
                          'Writing',
                          'Museums & galleries',
                          'Wine',
                          'Coffee',
                          'Foodie',
                        ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileInfoSection extends StatelessWidget {
  final String title;
  final List<String> chips;

  const _ProfileInfoSection({
    required this.title,
    required this.chips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map(
                  (text) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 6,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
