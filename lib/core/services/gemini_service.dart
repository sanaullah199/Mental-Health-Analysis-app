import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mental_health_analysis_app/core/constants/api_end_points.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: EndPoints.apiKey,
    );
  }

  void initializeChat({AssessmentModel? assessment}) {
    final systemPrompt = _buildSystemPrompt(assessment);
    _chat = _model.startChat(
      history: [
        Content.text(systemPrompt),
        Content.model([
          TextPart(
            'I understand. I\'m here to support you with your mental health journey. How can I help you today?',
          ),
        ]),
      ],
    );
  }

  String _buildSystemPrompt(AssessmentModel? assessment) {
    if (assessment == null) {
      return '''You are a compassionate mental health support AI assistant. Your role is to:
- Provide emotional support and active listening
- Offer evidence-based coping strategies and techniques
- Encourage healthy habits and self-care
- Never diagnose or replace professional help
- Be empathetic, non-judgmental, and supportive
- Keep responses concise (2-3 sentences) and actionable
- Use a warm, friendly tone''';
    }

    final concerns = assessment.concerns.isNotEmpty
        ? assessment.concerns.join(', ')
        : 'none identified';
    final recommendations = assessment.recommendations.isNotEmpty
        ? assessment.recommendations.join('; ')
        : 'maintain current habits';

    return '''You are a compassionate mental health support AI assistant with access to the user's recent assessment data.

USER'S CURRENT STATUS:
- Mental Health Score: ${assessment.aiScore}/100
- Mood: ${assessment.mood}
- Sleep Quality: ${assessment.sleepQuality}
- Stress Level: ${assessment.stressLevel}
- Current Concerns: $concerns
- Personalized Recommendations: $recommendations

YOUR ROLE:
- Provide personalized support based on their assessment data
- Reference their specific concerns when relevant
- Reinforce the recommendations they've received
- Celebrate improvements and progress
- Offer evidence-based coping strategies
- Be empathetic, non-judgmental, and supportive
- Keep responses concise (2-3 sentences) and actionable
- Use a warm, friendly tone

IMPORTANT:
- Never diagnose or replace professional help
- Encourage seeking professional support for serious concerns
- Focus on practical, immediate actions they can take
- Acknowledge their feelings and validate their experiences

Remember: You're a supportive companion helping them implement their personalized mental health plan.''';
  }

  Future<String> sendMessage(String message) async {
    try {
      debugPrint('Sending message to Gemini: $message');

      final content = Content.text(message);
      final response = await _chat.sendMessage(content);

      final text =
          response.text ??
          'I apologize, but I couldn\'t generate a response. Please try again.';
      debugPrint('Received response from Gemini: $text');

      return text;
    } catch (e) {
      debugPrint('Error sending message to Gemini: $e');
      return 'I\'m having trouble connecting right now. Please check your internet connection and try again.';
    }
  }

  Future<String> sendMessageWithContext({
    required String message,
    required AssessmentModel? assessment,
  }) async {
    try {
      // Reinitialize chat with updated assessment data
      initializeChat(assessment: assessment);
      return await sendMessage(message);
    } catch (e) {
      debugPrint('Error in sendMessageWithContext: $e');
      return 'I\'m having trouble connecting right now. Please try again.';
    }
  }
}
