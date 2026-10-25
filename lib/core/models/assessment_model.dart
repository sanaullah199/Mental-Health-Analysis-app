import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentModel {
  final String userId;
  final String mood;
//  final int moodIndex;
  final String pain;
//  final int sleepIndex;
  final String sleepQuality;
  final String medication;
  final String judgement;
  final String stressLevel;
  final int stressLevelNumber;
  final int aiScore;
  final String aiSummary;
  final List<String> concerns;
  final List<String> recommendations;
  final Timestamp createdAt;

  AssessmentModel({
    required this.userId,
    required this.mood,
   // required this.moodIndex,
    required this.pain,
    required this.stressLevelNumber,
   // required this.sleepIndex,
    required this.sleepQuality,
    required this.medication,
    required this.judgement,
    required this.stressLevel,
    required this.aiScore,
    required this.aiSummary,
    required this.concerns,
    required this.recommendations,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "mood": mood,
    //  "moodIndex": moodIndex,
      "pain": pain,
     // "sleepIndex": sleepIndex,
     "stressLevelNumber": stressLevelNumber,
      "sleepQuality": sleepQuality,
      "medication": medication,
      "judgement": judgement,
      "stressLevel": stressLevel,
      "aiScore": aiScore,
      "aiSummary": aiSummary,
      "concerns": concerns,
      "recommendations": recommendations,
      "createdAt": createdAt,
    };
  }

  factory AssessmentModel.fromMap(Map<String, dynamic> map) {
    return AssessmentModel(
      userId: map["userId"] ?? "",
      mood: map["mood"] ?? "",
      stressLevelNumber: map["stressLevelNumber"] ?? "",
     // moodIndex: map["moodIndex"] ?? 0,
      pain: map["pain"] ?? "",
     // sleepIndex: map["sleepIndex"] ?? 0,
      sleepQuality: map["sleepQuality"] ?? "",
      medication: map["medication"] ?? "",
      judgement: map["judgement"] ?? "",
      stressLevel: map["stressLevel"] ?? "",
      aiScore: map["aiScore"] ?? 0,
      aiSummary: map["aiSummary"] ?? "",
      concerns: List<String>.from(map["concerns"] ?? []),
      recommendations: List<String>.from(map["recommendations"] ?? []),
      createdAt: map["createdAt"] ?? Timestamp.now(),
    );
  }
}
