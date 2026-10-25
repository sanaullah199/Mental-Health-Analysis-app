import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/core/models/conversation_model.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/services/database_services.dart';
import 'package:mental_health_analysis_app/core/services/gemini_service.dart';
import 'package:mental_health_analysis_app/core/services/emotion_detection_service.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/chat/chat_screen.dart';

class ChatViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseServices _databaseServices = locator<DatabaseServices>();
  final GeminiService _geminiService = GeminiService();

  List<ChatMessage> _messages = [];
  List<ConversationModel> _conversations = [];
  AssessmentModel? _assessment;
  bool _isTyping = false;
  String? _currentConversationId;
  Stream<QuerySnapshot>? _messagesStream;
  Stream<QuerySnapshot>? _conversationsStream;

  List<ChatMessage> get messages => _messages;
  List<ConversationModel> get conversations => _conversations;
  bool get isTyping => _isTyping;
  AssessmentModel? get assessment => _assessment;
  String? get currentConversationId => _currentConversationId;

  Future<void> initialize() async {
    setState(ViewState.busy);
    await _loadAssessment();
    _geminiService.initializeChat(assessment: _assessment);
    _loadConversations();
    // Start a new conversation automatically
    await startNewConversation();
    setState(ViewState.idle);
  }

  Future<void> _loadAssessment() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _assessment = await _databaseServices.getAssessment(userId);
      notifyListeners();
    }
  }

  void _loadConversations() {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _conversationsStream = _databaseServices.getUserConversations(userId);
      _conversationsStream!.listen((snapshot) {
        _conversations = snapshot.docs
            .map(
              (doc) =>
                  ConversationModel.fromMap(doc.data() as Map<String, dynamic>),
            )
            .toList();

        // Sort by lastUpdated (newest first)
        _conversations.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        notifyListeners();
      });
    }
  }

  void _loadMessages(String conversationId) {
    _messagesStream = _databaseServices.getConversationMessages(conversationId);
    _messagesStream!.listen((snapshot) {
      _messages = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return [
              ChatMessage(
                text: data['userMessage'] ?? '',
                isUser: true,
                timestamp: (data['timestamp'] as Timestamp).toDate(),
                emotion: data['emotion'],
                emotionColor: data['emotionColor'] != null
                    ? Color(data['emotionColor'] as int)
                    : null,
                dataUpdated: data['dataUpdated'] as bool?,
              ),
              ChatMessage(
                text: data['botResponse'] ?? '',
                isUser: false,
                timestamp: (data['timestamp'] as Timestamp).toDate(),
              ),
            ];
          })
          .expand((pair) => pair)
          .toList();
      notifyListeners();
    });
  }

  Future<void> startNewConversation() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    final conversationId = await _databaseServices.createConversation(
      userId: userId,
      title: 'New Conversation',
    );

    _currentConversationId = conversationId;
    _messages = [];
    _loadMessages(conversationId);
    notifyListeners();
  }

  void switchConversation(String conversationId) {
    _currentConversationId = conversationId;
    _messages = [];
    _loadMessages(conversationId);
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || _currentConversationId == null) return;

    final isFirstMessage = _messages.isEmpty;

    // Detect emotion from message
    final emotionResult = EmotionDetectionService.detectEmotion(message);

    // Add user message immediately with emotion
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
      emotion: emotionResult.emotion,
      emotionColor: emotionResult.color,
      dataUpdated: true,
    );
    _messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _geminiService.sendMessage(message);

      // Add bot response
      final botMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(botMessage);

      // Update assessment based on emotion
      if (_assessment != null) {
        final newScore = EmotionDetectionService.calculateUpdatedScore(
          currentScore: _assessment!.aiScore,
          emotionScore: emotionResult.moodScore,
        );

        // Update assessment in Firebase
        final updatedAssessment = AssessmentModel(
          userId: _assessment!.userId,
          mood: emotionResult.emotion,
          pain: _assessment!.pain,
          sleepQuality: _assessment!.sleepQuality,
          medication: _assessment!.medication,
          judgement: _assessment!.judgement,
          stressLevel: _assessment!.stressLevel,
          stressLevelNumber: _assessment!.stressLevelNumber,
          aiScore: newScore,
          aiSummary: _assessment!.aiSummary,
          concerns: _assessment!.concerns,
          recommendations: _assessment!.recommendations,
          createdAt: _assessment!.createdAt,
        );

        await _databaseServices.saveAssessment(updatedAssessment);
        _assessment = updatedAssessment;
      }

      // Save to Firebase with emotion data
      await _databaseServices.saveConversationMessage(
        conversationId: _currentConversationId!,
        userMessage: message,
        botResponse: response,
        emotion: emotionResult.emotion,
        emotionColor: emotionResult.color.toARGB32(),
      );

      // Generate title from first message (truncate to 40 chars)
      String? conversationTitle;
      if (isFirstMessage) {
        conversationTitle = message.length > 40
            ? '${message.substring(0, 40)}...'
            : message;
      }

      // Update conversation metadata
      await _databaseServices.updateConversation(
        conversationId: _currentConversationId!,
        lastMessage: message,
        mood: emotionResult.emotion,
        title: conversationTitle,
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
      final errorMessage = ChatMessage(
        text: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    await _databaseServices.deleteConversation(conversationId);

    // If deleted conversation was active, start a new one
    if (_currentConversationId == conversationId) {
      await startNewConversation();
    }
  }
}
