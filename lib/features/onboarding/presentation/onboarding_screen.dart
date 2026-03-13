import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/data/auth_repository.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFF6A88), Color(0xFFE94057)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 24),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'IFeelo',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text: "By tapping 'Continue' you agree to our ",
                          ),
                          TextSpan(
                            text: 'Terms',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ".\nLearn how we process your data in our ",
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Cookies Policy',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    _AuthButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      onPressed: () async {
                        debugPrint('Starting Google Sign-In...');
                        final controller = ref.read(
                          authControllerProvider.notifier,
                        );
                        try {
                          await controller.loginWithGoogle();
                          debugPrint('Google Sign-In completed.');
                          final user = ref
                              .read(authRepositoryProvider)
                              .currentUser;
                          
                          if (user != null) {
                            debugPrint('User logged in: ${user.uid}');
                            try {
                                final exists = await ref
                                    .read(authRepositoryProvider)
                                    .checkUserExists(user.uid);
                                debugPrint('User exists in Firestore: $exists');
                                if (exists) {
                                  if (context.mounted) {
                                    debugPrint('Navigating to Home...');
                                    context.go('/');
                                  }
                                } else {
                                  if (context.mounted) {
                                    debugPrint('Navigating to Create Profile...');
                                    context.go('/create-profile');
                                  }
                                }
                            } catch (e) {
                                debugPrint('Error checking user existence: $e');
                                // Fallback: Assume new user if check fails (e.g. permission error)
                                if (context.mounted) {
                                    context.go('/create-profile');
                                }
                            }
                          } else {
                             debugPrint('User is null after login.');
                          }
                        } catch (e) {
                          debugPrint('Google Sign-In Error: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Google sign-in failed: $e',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _AuthButton(
                      icon: Icons.phone,
                      label: 'Continue with phone number',
                      onPressed: () {
                        context.go('/login');
                      },
                    ),
                    const SizedBox(height: 12),
                    _AuthButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Continue with Line',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _AuthButton(
                      icon: Icons.person_outline,
                      label: 'Continue as Guest',
                      onPressed: () {
                        context.go('/');
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Trouble signing in?',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFE94057)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
