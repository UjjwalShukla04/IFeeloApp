import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(FirebaseFirestore.instance));

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  Stream<QuerySnapshot> getMessages(String matchId) {
    return _firestore
        .collection(FirebaseConstants.matchesCollection)
        .doc(matchId)
        .collection(FirebaseConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String matchId, String senderId, String text) async {
    final messageData = {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'seen': false,
    };

    await _firestore
        .collection(FirebaseConstants.matchesCollection)
        .doc(matchId)
        .collection(FirebaseConstants.messagesCollection)
        .add(messageData);
        
    // Update last message in match doc
    await _firestore.collection(FirebaseConstants.matchesCollection).doc(matchId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
}
