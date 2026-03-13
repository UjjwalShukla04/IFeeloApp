import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(false);

  Future<void> login(String email, String password) async {
    state = true; // Loading
    try {
      await _authRepository.signInWithEmail(email, password);
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> loginWithGoogle() async {
    state = true;
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = true;
    try {
      await _authRepository.signUpWithEmail(email, password);
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
  }
}
