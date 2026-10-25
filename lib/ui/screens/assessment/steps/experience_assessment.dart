import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';

class ExperienceAssessment extends StatelessWidget {
  final AssessmentViewModel model;
  const ExperienceAssessment(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Are you experiencing any physical symptoms of distress?",
            textAlign: TextAlign.center,
            style: headingTextStyle,
          ),
        ),
        //SizedBox(height: 40),
        Text("Select one answer."),
        // SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(model.energyOptions.length, (index) {
              final option = model.energyOptions[index];
              final isSelected = model.selectedPainIndex == index;

              return GestureDetector(
                onTap: () => model.selectPain(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff9BB068) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      // LEFT ICON
                      Image.asset(
                        option["icon"]!,
                        width: 24,
                        height: 24,
                        color: isSelected ? Colors.white : primaryColor,
                      ),

                      const SizedBox(width: 12),

                      // TEXT
                      Expanded(
                        child: Text(
                          option["text"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // RIGHT RADIO CIRCLE
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(),
      ],
    );
  }
}
