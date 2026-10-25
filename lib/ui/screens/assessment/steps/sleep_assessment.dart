import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';

class SleepAssessment extends StatelessWidget {
  final AssessmentViewModel model;
  const SleepAssessment(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "How would you rate your sleep quality?",
              textAlign: TextAlign.center,
              style: headingTextStyle,
            ),
            SizedBox(height: 15),
            Column(
              children: List.generate(model.sleepOptions.length, (index) {
                final option = model.sleepOptions[index];
                final isSelected = model.sleepIndex == index;

                return GestureDetector(
                  onTap: () => model.updateSleep(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xff9BB068)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? Colors.white
                              : Color(0xff1F160F).withOpacity(0.4),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected
                                      ? primaryColor
                                      : Color(0xff1F160F).withOpacity(0.4),
                                  fontFamily: "${AppAssets.extraBold}",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? primaryColor
                                      : Color(0xff1F160F).withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(option.emoji, width: 48, height: 48),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
