import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String id;
  final String userId;
  final String title;
  final String lastMessage;
  final String mood;
  final int messageCount;
  final Timestamp createdAt;
  final Timestamp lastUpdated;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.lastMessage,
    required this.mood,
    required this.messageCount,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'lastMessage': lastMessage,
      'mood': mood,
      'messageCount': messageCount,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? 'New Conversation',
      lastMessage: map['lastMessage'] ?? '',
      mood: map['mood'] ?? 'Neutral',
      messageCount: map['messageCount'] ?? 0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      lastUpdated: map['lastUpdated'] ?? Timestamp.now(),
    );
  }

  String get moodEmoji {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'great':
        return '😊';
      case 'sad':
      case 'low':
        return '😢';
      case 'anxious':
      case 'worried':
        return '😰';
      case 'angry':
        return '😠';
      case 'overjoyed':
        return '🤩';
      default:
        return '😐';
    }
  }
}
