import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/create_account_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/chat/presentation/chat_list_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/create_profile_screen.dart';
import '../features/profile/presentation/settings_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/home/presentation/match_found_screen.dart';
import '../features/home/presentation/user_profile_detail_screen.dart';
import '../core/models/mock_models.dart'; // Import mock models

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/create-profile',
      builder: (context, state) => const CreateProfileScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'matches',
          builder: (context, state) => const ChatListScreen(),
        ),
        GoRoute(
          path: 'chat/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ChatScreen(matchId: id);
          },
        ),
        GoRoute(
          path: 'match-found',
          pageBuilder: (context, state) {
            final user = state.extra as UserModel;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MatchFoundScreen(matchedUser: user),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
        GoRoute(
          path: 'user-detail',
          builder: (context, state) {
            final user = state.extra as UserModel;
            return UserProfileDetailScreen(user: user);
          },
        ),
      ],
    ),
  ],
);
