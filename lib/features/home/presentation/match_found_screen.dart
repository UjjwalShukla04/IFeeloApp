import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/mock_models.dart';

class MatchFoundScreen extends StatefulWidget {
  final UserModel matchedUser;

  const MatchFoundScreen({super.key, required this.matchedUser});

  @override
  State<MatchFoundScreen> createState() => _MatchFoundScreenState();
}

class _MatchFoundScreenState extends State<MatchFoundScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Or a dark overlay
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Blur
          Image.network(
            widget.matchedUser.imageUrls.first,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.8),
            colorBlendMode: BlendMode.darken,
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Text(
                  'It\'s a Match!',
                  style: TextStyle(
                    fontFamily: 'Cursive', // Or a nice display font
                    fontSize: 60,
                    color: Color(0xFFE94057),
                    fontWeight: FontWeight.bold,
                    shadows: [
                        Shadow(color: Colors.black, blurRadius: 10)
                    ]
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You and ${widget.matchedUser.name} like each other.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    // My Photo
                    const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=60'),
                    ),
                    const SizedBox(width: 24),
                    // Matched User Photo
                    CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.matchedUser.imageUrls.first),
                    ),
                ],
              ),

              const SizedBox(height: 64),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/chat/${widget.matchedUser.id}'); // Navigate to chat
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE94057),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Send a Message'),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: OutlinedButton(
                  onPressed: () {
                    context.pop(); // Go back to swiping
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Keep Swiping'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
