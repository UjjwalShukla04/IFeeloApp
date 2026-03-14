import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/mock_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _controller = CardSwiperController();
  final List<UserModel> _candidates = MockData.users;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.grey),
          onPressed: () => context.go('/profile'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.forum_rounded, color: Colors.grey),
            onPressed: () => context.push('/matches'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: _controller,
                cardsCount: _candidates.length,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                      final candidate = _candidates[index];
                      return _CardView(
                        candidate: candidate,
                        onTap: () =>
                            context.push('/user-detail', extra: candidate),
                      );
                    },
                onSwipe: (previousIndex, currentIndex, direction) {
                  final candidate = _candidates[previousIndex];
                  if (direction == CardSwiperDirection.right) {
                    // Simulate Match logic
                    if (currentIndex != null && currentIndex % 2 == 0) {
                      // Every 2nd swipe is a match for demo
                      final router = GoRouter.of(context);
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if (mounted) {
                          router.push('/match-found', extra: candidate);
                        }
                      });
                    }
                  }
                  return true;
                },
                allowedSwipeDirection: const AllowedSwipeDirection.only(
                  right: true,
                  left: true,
                  up: true,
                ),
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(0, 40),
                padding: const EdgeInsets.all(24.0),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    onPressed: () =>
                        _controller.swipe(CardSwiperDirection.left),
                  ),
                  _ActionButton(
                    icon: Icons.star,
                    color: Colors.blue,
                    size: 40, // Smaller super like
                    onPressed: () => _controller.swipe(CardSwiperDirection.top),
                  ),
                  _ActionButton(
                    icon: Icons.favorite,
                    color: const Color(0xFFE94057),
                    size: 60, // Bigger like button
                    onPressed: () =>
                        _controller.swipe(CardSwiperDirection.right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        iconSize: size * 0.5,
        onPressed: onPressed,
        padding: EdgeInsets.all(size * 0.2),
        constraints: BoxConstraints.tightFor(width: size, height: size),
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  final UserModel candidate;
  final VoidCallback onTap;

  const _CardView({required this.candidate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight.isFinite ? constraints.maxHeight : size.height;
        final targetH = maxH.clamp(0.0, size.height * 0.72);
        final targetW = constraints.maxWidth.isFinite ? constraints.maxWidth : size.width;
        return Center(
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: targetH,
              width: targetW,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      candidate.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(26),
                            Colors.black.withAlpha(204),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                candidate.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${candidate.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${candidate.distanceKm} km away',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: candidate.interests
                                .take(3)
                                .map(
                                  (i) => Chip(
                                    label: Text(
                                      i,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
