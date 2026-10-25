import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/steps/experience_assessment.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/steps/judgement_assessment.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/steps/medications_assessment.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/steps/mood_assessment.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/steps/sleep_assessment.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/steps/stresslevel_assessment.dart';
import 'package:mental_health_analysis_app/ui/screens/compiling/compiling_assessment.dart';

class AssessmentViewModel extends BaseViewModel {
  final AuthService authService = locator<AuthService>();
  int currentStep = 1;

  int _selectedMoodIndex = 2; // Default to "Okay"
  int? selectedEnergyIndex;
  int _sleepIndex = 2;
  MedicationOption? _selectedOption;
  int _selected = 1; // Anxiety level default

  // Keep for backward compatibility
  int? get selectedPainIndex => selectedEnergyIndex;

  MedicationOption? get selectedOption => _selectedOption;
  bool? judgementValue = true;

  int get selectedMoodIndex => _selectedMoodIndex;
  int get sleepIndex => _sleepIndex;
  String get selectedMoodLabel => moods[_selectedMoodIndex]["label"]!;
  String get selectedMoodImage => moods[_selectedMoodIndex]["image"]!;
  int get selected => _selected;

  void navigateToCompiling() {
    final assessment = AssessmentModel(
      userId: authService.currentUser!.uid,
      mood: moods[_selectedMoodIndex]["label"] ?? "",
      //moodIndex: _selectedMoodIndex,
      pain: energyOptions[selectedEnergyIndex ?? 1]["text"] ?? "",
      // sleepIndex: _sleepIndex,
      sleepQuality: sleepOptions[_sleepIndex].title,
      medication: _selectedOption.toString(),
      stressLevelNumber: _selected,
      judgement: judgement,
      stressLevel: stressDescription,

      aiScore: generateAIScore(),
      aiSummary: generateAISummary(),
      concerns: generateConcerns(),
      recommendations: generateRecommendations(),
      createdAt: Timestamp.now(),
    );
    Get.to(() => CompilingAssessment(assessmentModel: assessment));
  }

  int generateAIScore() {
    int score = 100;

    
    if (_selectedMoodIndex == 4) {
      score -= 30; 
    } else if (_selectedMoodIndex == 3) {
      score -= 20; 
    } else if (_selectedMoodIndex == 2) {
      score -= 10;
    } else if (_selectedMoodIndex == 1) {
      score -= 0; 
    }

    
    if (_sleepIndex >= 4) {
      score -= 25; 
    } else if (_sleepIndex == 3) {
      score -= 18; 
    } else if (_sleepIndex == 2) {
      score -= 8; 
    }

    
    score -= (_selected * 5);

    
    if (selectedEnergyIndex == 2) {
      score -= 15; 
    } else if (selectedEnergyIndex == 1) {
      score -= 5; 
    }

    
    if (judgementValue == true) {
      score += 5; 
    }

    return score.clamp(0, 100);
  }

  List<String> generateConcerns() {
    List<String> concerns = [];

    
    if (_selectedMoodIndex >= 4) {
      concerns.add("very low mood");
    } else if (_selectedMoodIndex >= 3) {
      concerns.add("low mood");
    }

   
    if (_selected >= 5) {
      concerns.add("overwhelming anxiety");
    } else if (_selected >= 4) {
      concerns.add("high anxiety");
    } else if (_selected >= 3) {
      concerns.add("moderate worry");
    }

   
    if (_sleepIndex >= 4) {
      concerns.add("severe sleep deprivation");
    } else if (_sleepIndex >= 3) {
      concerns.add("poor sleep quality");
    }

   
    if (selectedEnergyIndex == 2) {
      concerns.add("low energy and fatigue");
    }

    return concerns;
  }

  List<String> generateRecommendations() {
    List<String> recommendations = [];

    
    if (_selectedMoodIndex >= 4) {
      recommendations.add(
        "Practice self-compassion: treat yourself with the same kindness you'd offer a friend",
      );
      recommendations.add(
        "Journal your thoughts for 5 minutes to process difficult emotions",
      );
    } else if (_selectedMoodIndex >= 3) {
      recommendations.add(
        "Engage in activities that brought you joy in the past, even if briefly",
      );
    }

    // Anxiety management techniques
    if (_selected >= 5) {
      recommendations.add(
        "Use the 4-7-8 breathing: inhale for 4 counts, hold for 7, exhale for 8",
      );
      recommendations.add(
        "Try progressive muscle relaxation: tense and release each muscle group",
      );
    } else if (_selected >= 4) {
      recommendations.add(
        "Practice the 5-4-3-2-1 grounding: name 5 things you see, 4 you touch, 3 you hear, 2 you smell, 1 you taste",
      );
    } else if (_selected >= 3) {
      recommendations.add(
        "Set aside 10 minutes for mindfulness meditation or deep breathing",
      );
    }

    // Sleep improvement strategies
    if (_sleepIndex >= 4) {
      recommendations.add(
        "Create a wind-down routine: dim lights, cool room, no screens 1 hour before bed",
      );
      recommendations.add(
        "Try the 4-7-8 breathing technique in bed to calm your nervous system",
      );
    } else if (_sleepIndex >= 3) {
      recommendations.add(
        "Keep a consistent sleep schedule, even on weekends, to regulate your body clock",
      );
    }

    // Energy boosting activities
    if (selectedEnergyIndex == 2) {
      recommendations.add(
        "Take a 10-minute walk outside - natural light and movement boost energy naturally",
      );
      recommendations.add(
        "Stay hydrated and eat protein-rich snacks to stabilize energy levels",
      );
    } else if (selectedEnergyIndex == 1) {
      recommendations.add(
        "Balance activity with rest periods throughout your day",
      );
    }

    // General wellness practices
    if (recommendations.isEmpty) {
      recommendations.add(
        "Maintain your current healthy habits and check in with yourself daily",
      );
      recommendations.add(
        "Practice gratitude: write down 3 things you're thankful for each day",
      );
    }

    // Add one general wellness tip if only one recommendation
    if (recommendations.length == 1) {
      recommendations.add(
        "Spend time in nature or with loved ones to boost your mood naturally",
      );
    }

    return recommendations;
  }

  String generateAISummary() {
    final score = generateAIScore();

    // Generate personalized summary based on score and specific indicators
    if (score >= 80) {
      return "Your mental wellness is strong today. You're managing well across mood, sleep, and stress. Continue your positive habits.";
    } else if (score >= 60) {
      if (_sleepIndex >= 3) {
        return "Your overall wellness is good, but improving your sleep quality could boost your energy and mood significantly.";
      } else if (_selected >= 4) {
        return "You're doing well overall. Managing your anxiety through breathing exercises and mindfulness can help you feel even better.";
      } else {
        return "You're in a stable place mentally. Small adjustments to your routine can help you feel more energized.";
      }
    } else if (score >= 40) {
      if (_selectedMoodIndex >= 3 && _sleepIndex >= 3) {
        return "Your mood and sleep are affecting each other. Focus on establishing a calming bedtime routine to break this cycle.";
      } else if (_selected >= 4 && selectedEnergyIndex == 2) {
        return "Anxiety and low energy are draining you. Start with gentle movement and grounding techniques to regain balance.";
      } else if (_sleepIndex >= 4) {
        return "Sleep deprivation is impacting your wellbeing. Prioritize rest - your mind and body need recovery time.";
      } else {
        return "You're facing some challenges right now. Breaking them into small, manageable steps will help you move forward.";
      }
    } else {
      // Score below 40 - multiple concerns
      if (_selectedMoodIndex >= 4) {
        return "You're going through a difficult time. Focus on basic self-care: rest, nutrition, and one small positive action each day.";
      } else if (_selected >= 5 && _sleepIndex >= 4) {
        return "Overwhelming anxiety and poor sleep are creating a tough cycle. Start with sleep hygiene - better rest will help manage worry.";
      } else {
        return "Multiple factors are affecting your wellbeing. Take it one day at a time, and remember that small improvements add up.";
      }
    }
  }

  void updateMood(int index) {
    _selectedMoodIndex = index;
    notifyListeners();
  }

  void setJudgement(bool value) {
    judgementValue = value;
    notifyListeners();
  }

  void nextStep() {
    if (currentStep < 6) {
      currentStep++;

      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      currentStep--;
      notifyListeners();
    }
  }

  void selectEnergy(int index) {
    selectedEnergyIndex = index;
    notifyListeners();
  }

  // Keep for backward compatibility
  void selectPain(int index) => selectEnergy(index);

  void updateSleep(int index) {
    _sleepIndex = index;
    notifyListeners();
  }

  void selectOption(MedicationOption option) {
    _selectedOption = option;
    notifyListeners();
  }

  void select(int value) {
    _selected = value;
    notifyListeners();
  }

  String get judgement {
    return judgementValue == true
        ? "Yes, I'm open to professional support"
        : "Not currently, but I'm considering it";
  }

  final List<Map<String, String>> moods = [
    {"label": "Great", "image": "assets/images/overjoyed.png"},
    {"label": "Good", "image": "assets/images/good.png"},
    {"label": "Okay", "image": "assets/images/neutral.png"},
    {"label": "Low", "image": "assets/images/sad.png"},
    {"label": "Very Low", "image": "assets/images/depress.png"},
  ];

  // Energy Level Options (replacing pain)
  final List<Map<String, String>> energyOptions = [
    {
      "icon": "${AppAssets.iconsPath}/check.png",
      "text": "Energized & Motivated",
    },
    {"icon": "${AppAssets.iconsPath}/question.png", "text": "Moderate Energy"},
    {"icon": "${AppAssets.iconsPath}/close.png", "text": "Tired & Drained"},
  ];

  final List<SleepQualityOption> sleepOptions = [
    SleepQualityOption(
      title: "Excellent",
      subtitle: "⏱ 7–9 HOURS",
      emoji: "${AppAssets.imagePath}/overjoyed.png",
    ),
    SleepQualityOption(
      title: "Good",
      subtitle: "⏱ 6–7 HOURS",
      emoji: "${AppAssets.imagePath}/good.png",
    ),
    SleepQualityOption(
      title: "Fair",
      subtitle: "⏱ 5 HOURS",
      emoji: "${AppAssets.imagePath}/fair.png",
    ),
    SleepQualityOption(
      title: "Poor",
      subtitle: "⏱ 3–4 HOURS",
      emoji: "${AppAssets.imagePath}/poor.png",
    ),
    SleepQualityOption(
      title: "Worst",
      subtitle: "⏱ <3 HOURS",
      emoji: "${AppAssets.imagePath}/worst.png",
    ),
  ];

  final List<Map<String, dynamic>> medicationOptions = [
    {
      "icon": "${AppAssets.iconsPath}/medications.png",
      "title": "Prescribed Medications",
      "value": MedicationOption.prescribed,
    },
    {
      "icon": "${AppAssets.iconsPath}/supplements.png",
      "title": "Over the Counter Supplements",
      "value": MedicationOption.otcSupplements,
    },
    {
      "icon": "${AppAssets.iconsPath}/not.png",
      "title": "I’m not taking any",
      "value": MedicationOption.preferNotToSay,
    },
    {
      "icon": "${AppAssets.iconsPath}/close.png",
      "title": "Prefer not to say",
      "value": MedicationOption.none,
    },
  ];

  // Renamed from stressDescription to anxietyDescription for better mental health assessment
  String get anxietyDescription {
    switch (selected) {
      case 1:
        return "Calm and relaxed";
      case 2:
        return "Slightly worried";
      case 3:
        return "Moderately anxious";
      case 4:
        return "Very anxious";
      case 5:
        return "Overwhelmed with worry";
      default:
        return "";
    }
  }

  // Keep for backward compatibility
  String get stressDescription => anxietyDescription;

  Widget get stepContent {
    switch (currentStep) {
      case 1:
        return MoodAssessment(this);
      case 2:
        return JudgementAssessment(this);
      case 3:
        return ExperienceAssessment(this);
      case 4:
        return SleepAssessment(this);
      case 5:
        return MedicationsAssessment(this);
      case 6:
        return StresslevelAssessment(this);

      default:
        return const SizedBox();
    }
  }
}

class SleepQualityOption {
  final String title;
  final String subtitle;
  final String emoji;

  SleepQualityOption({
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}

enum MedicationOption { prescribed, otcSupplements, none, preferNotToSay }
