import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';

class MoodAssessment extends StatelessWidget {
  final AssessmentViewModel model;
  const MoodAssessment(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "How would you describe your mood?",
          textAlign: TextAlign.center,
          style: headingTextStyle,
        ),
        Column(
          children: [
            Text(
              "I Feel ${model.selectedMoodLabel}",
              style: bodyTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1F160F).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),

            CarouselSlider.builder(
              itemCount: model.moods.length,
              options: CarouselOptions(
                height: 120,
                enlargeCenterPage: true,
                viewportFraction: 0.4,
                onPageChanged: (index, _) => model.updateMood(index),
              ),
              itemBuilder: (_, index, __) {
                final mood = model.moods[index];
                return Image.asset(mood["image"]!);
              },
            ),
          ],
        ),
        SizedBox(),
      ],
    );
  }
}
