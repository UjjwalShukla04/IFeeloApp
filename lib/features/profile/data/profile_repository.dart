import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

// Use Mock for now
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => RealProfileRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  ),
);

abstract class ProfileRepository {
  Future<String> uploadImage(String userId, XFile imageFile);
  Future<void> createProfile(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getProfile(String userId);
}

class MockProfileRepository implements ProfileRepository {
  // Static storage to persist data in memory during session
  static final Map<String, Map<String, dynamic>> _storage = {};

  @override
  Future<String> uploadImage(String userId, XFile imageFile) async {
    await Future.delayed(const Duration(seconds: 2));
    // Convert to Base64 to ensure it works across all UI screens without blob/path issues
    final bytes = await imageFile.readAsBytes();
    final base64String = base64Encode(bytes);
    return 'data:image/jpeg;base64,$base64String';
  }

  @override
  Future<void> createProfile(String userId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    _storage[userId] = data;
    print('Mock DB: Saved profile for $userId: $data');
  }

  @override
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _storage[userId];
  }
}

class RealProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  RealProfileRepository(this._firestore, this._storage);

  @override
  Future<String> uploadImage(String userId, XFile imageFile) async {
    try {
      final ref = _storage
          .ref()
          .child('user_images')
          .child(userId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Handle Web vs Mobile file
      // On web, putData/putBlob is often safer with XFile bytes
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': imageFile.path},
      );

      final bytes = await imageFile.readAsBytes();
      final uploadTask = ref.putData(bytes, metadata);

      // Wait for the upload to complete
      await uploadTask;

      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  @override
  Future<void> createProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
        'isPremium': false,
        'location': const GeoPoint(0, 0), // Placeholder for now
      });
    } catch (e) {
      throw Exception('Profile creation failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }
}
