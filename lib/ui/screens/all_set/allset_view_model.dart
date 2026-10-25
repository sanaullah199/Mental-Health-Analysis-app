import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/ui/screens/dashboard/dashboard_screen.dart';

class AllSetViewModel extends BaseViewModel {
  String getMoodImage(String moodLabel) {
    // Map of mood label → image
    const moodMap = {
      "Happy": "assets/images/overjoyed.png",
      "Neutral": "assets/images/neutral.png",
      "Depressed": "assets/images/depress.png",
      "Sad": "assets/images/sad.png",
    };

    return moodMap[moodLabel] ?? "assets/images/neutral.png";
  }

  Color getScoreColor(int score) {
    // Excellent: 80-100 (Green)
    if (score >= 80) {
      return const Color(0xff9BB068);
    }
    // Good: 60-79 (Light Green/Yellow-Green)
    else if (score >= 60) {
      return const Color(0xffB8C66A);
    }
    // Fair: 40-59 (Orange)
    else if (score >= 40) {
      return const Color(0xffE8A05D);
    }
    // Poor: 20-39 (Light Red/Orange-Red)
    else if (score >= 20) {
      return const Color(0xffE87D5D);
    }
    // Critical: 0-19 (Red)
    else {
      return const Color(0xffE85D5D);
    }
  }

  void navigateToDashboard() async {
    setState(ViewState.busy);
    await Future.delayed(const Duration(seconds: 3), () {
      Get.off(DashboardScreen());
    });
    setState(ViewState.idle);
    notifyListeners();
  }
}
