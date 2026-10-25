import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_button.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';

class JudgementAssessment extends StatelessWidget {
  final AssessmentViewModel model;
  const JudgementAssessment(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset("${AppAssets.imagePath}/judgement.png"),
        ),
        SizedBox(height: 20),
        Text(
          "Have you sought professional help before?",
          textAlign: TextAlign.center,
          style: headingTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Yes",
                  icon: "",
                  onPressed: () => model.setJudgement(true),
                  backgroundColor: model.judgementValue == true
                      ? const Color(0xff9BB068)
                      : Colors.white,
                  textColor: model.judgementValue == true
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "No",
                  icon: "",
                  onPressed: () => model.setJudgement(false),
                  backgroundColor: model.judgementValue == false
                      ? const Color(0xff9BB068)
                      : Colors.white,
                  textColor: model.judgementValue == false
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
