import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/core/models/user_model.dart';

class DatabaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Save new user
  Future<void> createUser(UserModel user) async {
    await _db.collection("users").doc(user.uuid).set(user.toJson());
    debugPrint("Auth Services=====> ${user.toJson()}");
  }

  /// Get current user
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  //update name and image
  Future<void> updateNameAndImage({
    required String name,
    required String profileImage,
  }) async {
    try {
      await _db.collection("users").doc(currentUser?.uid).update({
        'name': name,
        'profileImage': profileImage,
      });
      debugPrint("✅ Name and profile image updated successfully");
    } catch (e) {
      debugPrint("❌ Error updating name and image: $e");
    }
  }

  //update fcm token
  // Future<void> updateFcmToken(String fcmToken) async {
  //   try {
  //     await _db.collection("users").doc(currentUser?.uid).update({
  //       'fcmToken': fcmToken,
  //     });
  //     debugPrint("✅ FCM token updated successfully");
  //   } catch (e) {
  //     debugPrint("❌ Error updating FCM token: $e");
  //   }
  // }

  Future<void> saveAssessment(AssessmentModel assessment) async {
    try {
      await _db
          .collection("assessments")
          .doc(assessment.userId)
          .set(assessment.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Error Saving Assessment: $e");
    }
  }

  Future<AssessmentModel?> getAssessment(String userId) async {
    try {
      final doc = await _db.collection("assessments").doc(userId).get();
      if (doc.exists) {
        return AssessmentModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error getting Assessment: $e");
      return null;
    }
  }

  // Chat conversation methods
  Future<void> saveConversation({
    required String userId,
    required String userMessage,
    required String botResponse,
  }) async {
    try {
      final conversationRef = _db.collection("conversations").doc(userId);
      final doc = await conversationRef.get();

      final messagePair = {
        'userMessage': userMessage,
        'botResponse': botResponse,
        'timestamp': Timestamp.now(),
      };

      if (doc.exists) {
        // Update existing conversation
        await conversationRef.update({
          'messages': FieldValue.arrayUnion([messagePair]),
          'lastUpdated': Timestamp.now(),
        });
      } else {
        // Create new conversation
        await conversationRef.set({
          'conversationId': userId,
          'userId': userId,
          'messages': [messagePair],
          'lastUpdated': Timestamp.now(),
        });
      }
      debugPrint("✅ Conversation saved successfully");
    } catch (e) {
      debugPrint("❌ Error saving conversation: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getConversationHistory(
    String userId,
  ) async {
    try {
      final doc = await _db.collection("conversations").doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        final messages = data?['messages'] as List<dynamic>?;
        return messages?.cast<Map<String, dynamic>>() ?? [];
      }
      return [];
    } catch (e) {
      debugPrint("❌ Error getting conversation history: $e");
      return [];
    }
  }

  Future<void> clearConversationHistory(String userId) async {
    try {
      await _db.collection("conversations").doc(userId).delete();
      debugPrint("✅ Conversation history cleared");
    } catch (e) {
      debugPrint("❌ Error clearing conversation history: $e");
    }
  }

  Stream<DocumentSnapshot> conversationStream(String userId) {
    return _db.collection("conversations").doc(userId).snapshots();
  }

  // Conversation management
  Future<String> createConversation({
    required String userId,
    String? title,
  }) async {
    try {
      final conversationId = _db.collection("user_conversations").doc().id;
      await _db.collection("user_conversations").doc(conversationId).set({
        'id': conversationId,
        'userId': userId,
        'title': title ?? 'New Conversation',
        'lastMessage': '',
        'mood': 'Neutral',
        'messageCount': 0,
        'createdAt': Timestamp.now(),
        'lastUpdated': Timestamp.now(),
      });
      debugPrint("✅ Conversation created: $conversationId");
      return conversationId;
    } catch (e) {
      debugPrint("❌ Error creating conversation: $e");
      return '';
    }
  }

  Future<void> updateConversation({
    required String conversationId,
    required String lastMessage,
    String? mood,
    String? title,
  }) async {
    try {
      final updates = {
        'lastMessage': lastMessage,
        'lastUpdated': Timestamp.now(),
        'messageCount': FieldValue.increment(1),
      };
      if (mood != null) {
        updates['mood'] = mood;
      }
      if (title != null) {
        updates['title'] = title;
      }
      await _db
          .collection("user_conversations")
          .doc(conversationId)
          .update(updates);
    } catch (e) {
      debugPrint("❌ Error updating conversation: $e");
    }
  }

  Stream<QuerySnapshot> getUserConversations(String userId) {
    // Using a simpler query structure to avoid index requirement
    // We'll sort in the app instead
    return _db
        .collection("user_conversations")
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _db.collection("user_conversations").doc(conversationId).delete();
      // Also delete associated messages
      final messages = await _db
          .collection("conversation_messages")
          .where('conversationId', isEqualTo: conversationId)
          .get();
      for (var doc in messages.docs) {
        await doc.reference.delete();
      }
      debugPrint("✅ Conversation deleted");
    } catch (e) {
      debugPrint("❌ Error deleting conversation: $e");
    }
  }

  // Conversation messages
  Future<void> saveConversationMessage({
    required String conversationId,
    required String userMessage,
    required String botResponse,
    String? emotion,
    int? emotionColor,
  }) async {
    try {
      await _db.collection("conversation_messages").add({
        'conversationId': conversationId,
        'userMessage': userMessage,
        'botResponse': botResponse,
        'timestamp': Timestamp.now(),
        'emotion': emotion,
        'emotionColor': emotionColor,
        'dataUpdated': emotion != null,
      });
    } catch (e) {
      debugPrint("❌ Error saving message: $e");
    }
  }

  Stream<QuerySnapshot> getConversationMessages(String conversationId) {
    return _db
        .collection("conversation_messages")
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Delete all user data
  Future<void> deleteUserData(String userId) async {
    try {
      // Delete user document
      await _db.collection("users").doc(userId).delete();

      // Delete assessment
      await _db.collection("assessments").doc(userId).delete();

      // Delete all conversations
      final conversations = await _db
          .collection("user_conversations")
          .where('userId', isEqualTo: userId)
          .get();
      for (var doc in conversations.docs) {
        await doc.reference.delete();
      }

      // Delete all conversation messages
      if (conversations.docs.isNotEmpty) {
        final messages = await _db
            .collection("conversation_messages")
            .where(
              'conversationId',
              whereIn: conversations.docs.map((d) => d.id).toList(),
            )
            .get();
        for (var doc in messages.docs) {
          await doc.reference.delete();
        }
      }

      // Delete old conversation format if exists
      await _db.collection("conversations").doc(userId).delete();

      debugPrint("✅ All user data deleted successfully");
    } catch (e) {
      debugPrint("❌ Error deleting user data: $e");
      rethrow;
    }
  }
}
