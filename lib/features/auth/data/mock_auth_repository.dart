import 'package:firebase_auth/firebase_auth.dart';

class LegacyMockAuthRepository {
  Stream<User?> get authStateChanges => Stream.value(null);

  User? get currentUser => null;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockUserCredential();
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockUserCredential();
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> checkUserExists(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  UserCredential _mockUserCredential() {
    throw UnimplementedError('MockUserCredential not fully implemented');
  }
}
