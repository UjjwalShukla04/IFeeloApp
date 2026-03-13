import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => RealAuthRepository(FirebaseAuth.instance),
);

// Abstract base class or Interface (implicitly defined by AuthRepository structure)
abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<bool> checkUserExists(String uid);
}

class MockUser implements User {
  @override
  String get uid => 'mock_user_123';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock_token';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthRepository implements AuthRepository {
  User? _user;

  @override
  Stream<User?> get authStateChanges => Stream.value(_user);

  @override
  User? get currentUser => _user;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    _user = MockUser();
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _user = MockUser();
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _user = null;
  }

  @override
  Future<bool> checkUserExists(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<User?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _user = MockUser();
    return _user;
  }
}

class RealAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  RealAuthRepository(this._auth);

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      final userCredential = await _auth.signInWithPopup(googleProvider);
      return userCredential.user;
    } else {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<bool> checkUserExists(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
