import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/mock_models.dart';

class UserProfileDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserProfileDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(user.imageUrls.first, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(179),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                '${user.name}, ${user.age}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${user.location} • ${user.distanceKm}km away',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${user.jobTitle} at ${user.company}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  _UserInfoSection(
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
                  _UserInfoSection(
                    title: "I'm looking for",
                    chips: const [
                      'Fun, casual dates',
                      'Confidence',
                      'Sassiness',
                      'Loyalty',
                    ],
                  ),
                  const SizedBox(height: 16),
                  _UserInfoSection(
                    title: 'My interests',
                    chips: user.interests.isNotEmpty
                        ? user.interests
                        : const [
                            'Writing',
                            'Museums & galleries',
                            'Wine',
                            'Coffee',
                            'Foodie',
                          ],
                  ),

                  const SizedBox(height: 24),

                  if (user.imageUrls.length > 1)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        user.imageUrls[1],
                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 16),

                  const _PromptCard(
                    title: 'My perfect first date is',
                    value: 'Beach dates',
                    tag: 'Compliment',
                  ),

                  const SizedBox(height: 16),

                  const _UserInfoSection(
                    title: 'Languages',
                    chips: ['Bengali', 'English', 'Hindi', 'Telugu'],
                  ),

                  const SizedBox(height: 16),

                  if (user.imageUrls.length > 2)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        user.imageUrls[2],
                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 24),

                  const _PromptCard(
                    title: "I'm happiest when",
                    value: 'Reading books',
                    tag: 'Compliment',
                  ),

                  const SizedBox(height: 16),

                  const _PromptCard(
                    title: 'My dream is to',
                    value: 'Travel',
                    tag: 'Compliment',
                  ),

                  const SizedBox(height: 16),

                  _LocationCard(
                    city: user.location,
                    distanceLabel: '${user.distanceKm} km away',
                  ),

                  const SizedBox(height: 24),

                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: user.imageUrls.length > 3
                        ? user.imageUrls.length - 3
                        : 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          user.imageUrls[index + 3],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('Block ${user.name}'),
                    ),
                  ),

                  const SizedBox(height: 100), // Spacing for floating buttons
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: 'nope',
              onPressed: () => context.pop(),
              backgroundColor: Colors.white,
              child: const Icon(Icons.close, color: Colors.red, size: 30),
            ),
            FloatingActionButton(
              heroTag: 'superlike',
              onPressed: () {},
              backgroundColor: Colors.white,
              child: const Icon(Icons.star, color: Colors.blue, size: 30),
            ),
            FloatingActionButton(
              heroTag: 'like',
              onPressed: () {},
              backgroundColor: const Color(0xFFE94057),
              child: const Icon(Icons.favorite, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  final String title;
  final List<String> chips;

  const _UserInfoSection({required this.title, required this.chips});

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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map(
                  (text) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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

class _PromptCard extends StatelessWidget {
  final String title;
  final String value;
  final String tag;

  const _PromptCard({
    required this.title,
    required this.value,
    required this.tag,
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.favorite_border,
                size: 18,
                color: Color(0xFFE94057),
              ),
              const SizedBox(width: 8),
              Text(
                tag,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String city;
  final String distanceLabel;

  const _LocationCard({required this.city, required this.distanceLabel});

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
            'My location',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    distanceLabel,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
