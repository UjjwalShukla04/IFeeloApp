import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        final hasCompleted = (data['has_completed_assessment'] ?? false) == true;
        context.go(hasCompleted ? '/' : '/assessment');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _signUp() async {
    if (mounted) {
      context.go('/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 80, color: Color(0xFFE94057)),
              const SizedBox(height: 32),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE94057),
                ),
              ),
              const SizedBox(height: 48),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: _login,
                text: 'Login',
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _signUp,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
