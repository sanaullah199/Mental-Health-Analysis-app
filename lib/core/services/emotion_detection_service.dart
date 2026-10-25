import 'package:flutter/material.dart';

class EmotionDetectionService {
  // Detect emotion from user message
  static EmotionResult detectEmotion(String message) {
    final lowerMessage = message.toLowerCase();

    // Negative emotions
    if (_containsAny(lowerMessage, [
      'angry',
      'furious',
      'mad',
      'rage',
      'hate',
      'fuck',
      'damn',
      'pissed',
      'annoyed',
      'frustrated',
      'irritated',
    ])) {
      return EmotionResult(emotion: 'Anger', color: Colors.red, moodScore: 20);
    }

    if (_containsAny(lowerMessage, [
      'hopeless',
      'despair',
      'give up',
      'can\'t',
      'impossible',
      'overwhelmed',
      'falling apart',
      'everything is',
      'nothing works',
    ])) {
      return EmotionResult(
        emotion: 'Despair',
        color: Colors.deepOrange,
        moodScore: 15,
      );
    }

    if (_containsAny(lowerMessage, [
      'sad',
      'depressed',
      'down',
      'unhappy',
      'miserable',
      'crying',
      'tears',
      'heartbroken',
      'lonely',
      'empty',
    ])) {
      return EmotionResult(emotion: 'Sad', color: Colors.orange, moodScore: 30);
    }

    if (_containsAny(lowerMessage, [
      'anxious',
      'worried',
      'nervous',
      'scared',
      'afraid',
      'panic',
      'stress',
      'tense',
      'uneasy',
      'fear',
    ])) {
      return EmotionResult(
        emotion: 'Anxious',
        color: Colors.amber,
        moodScore: 40,
      );
    }

    // Positive emotions
    if (_containsAny(lowerMessage, [
      'happy',
      'joy',
      'great',
      'wonderful',
      'amazing',
      'fantastic',
      'excellent',
      'love',
      'blessed',
      'grateful',
      'thank',
    ])) {
      return EmotionResult(
        emotion: 'Happy',
        color: Colors.green,
        moodScore: 85,
      );
    }

    if (_containsAny(lowerMessage, [
      'excited',
      'thrilled',
      'ecstatic',
      'overjoyed',
      'elated',
      'pumped',
      'enthusiastic',
    ])) {
      return EmotionResult(
        emotion: 'Overjoyed',
        color: Colors.lightGreen,
        moodScore: 95,
      );
    }

    if (_containsAny(lowerMessage, [
      'calm',
      'peaceful',
      'relaxed',
      'content',
      'serene',
      'tranquil',
    ])) {
      return EmotionResult(emotion: 'Calm', color: Colors.blue, moodScore: 75);
    }

    // Neutral
    return EmotionResult(emotion: 'Neutral', color: Colors.grey, moodScore: 60);
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  // Calculate new assessment score based on emotion
  static int calculateUpdatedScore({
    required int currentScore,
    required int emotionScore,
  }) {
    // Weighted average: 70% current, 30% new emotion
    return ((currentScore * 0.7) + (emotionScore * 0.3)).round();
  }

  // Get mood index for assessment
  static int getMoodIndex(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'overjoyed':
      case 'happy':
        return 0; // Great
      case 'calm':
      case 'neutral':
        return 2; // Okay
      case 'anxious':
      case 'sad':
        return 3; // Low
      case 'despair':
      case 'anger':
        return 4; // Very Low
      default:
        return 2; // Okay
    }
  }
}

class EmotionResult {
  final String emotion;
  final Color color;
  final int moodScore;

  EmotionResult({
    required this.emotion,
    required this.color,
    required this.moodScore,
  });
}
