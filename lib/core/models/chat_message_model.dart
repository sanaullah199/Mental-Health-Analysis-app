import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String userId;
  final String message;
  final String response;
  final Timestamp createdAt;
  final bool isUser;

  ChatMessageModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.response,
    required this.createdAt,
    required this.isUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'response': response,
      'createdAt': createdAt,
      'isUser': isUser,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      response: map['response'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      isUser: map['isUser'] ?? false,
    );
  }
}

class ConversationModel {
  final String conversationId;
  final String userId;
  final List<MessagePair> messages;
  final Timestamp lastUpdated;

  ConversationModel({
    required this.conversationId,
    required this.userId,
    required this.messages,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'userId': userId,
      'messages': messages.map((m) => m.toMap()).toList(),
      'lastUpdated': lastUpdated,
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      conversationId: map['conversationId'] ?? '',
      userId: map['userId'] ?? '',
      messages:
          (map['messages'] as List<dynamic>?)
              ?.map((m) => MessagePair.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: map['lastUpdated'] ?? Timestamp.now(),
    );
  }
}

class MessagePair {
  final String userMessage;
  final String botResponse;
  final Timestamp timestamp;

  MessagePair({
    required this.userMessage,
    required this.botResponse,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userMessage': userMessage,
      'botResponse': botResponse,
      'timestamp': timestamp,
    };
  }

  factory MessagePair.fromMap(Map<String, dynamic> map) {
    return MessagePair(
      userMessage: map['userMessage'] ?? '',
      botResponse: map['botResponse'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
