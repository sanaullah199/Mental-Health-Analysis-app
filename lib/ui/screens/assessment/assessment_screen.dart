import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_back_button.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_button.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';
import 'package:mental_health_analysis_app/ui/screens/compiling/compiling_assessment.dart';
import 'package:provider/provider.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssessmentViewModel(),
      child: Consumer<AssessmentViewModel>(
        builder: (_, model, __) {
          return Scaffold(
            appBar: _appBar(model),

            body: Column(
              children: [
                Expanded(child: model.stepContent),

                _bottomButtons(model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomButtons(AssessmentViewModel model) {
    // Step 1 → only Continue
    if (model.currentStep == 1) {
      return CustomButton(
        text: "Continue",

        onPressed: () => model.nextStep(),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      );
    }

    // Steps 2–7 → Back + Continue/Finish
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Back",
              icon: "",
              onPressed: () => model.previousStep(),
              backgroundColor: Colors.grey.shade300,
              textColor: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              icon: "",
              text: model.currentStep == 6 ? "Finish" : "Continue",
              onPressed: () {
                if (model.currentStep == 6) {
                  model.navigateToCompiling();
                } else {
                  model.nextStep();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(AssessmentViewModel model) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: CustomBackButton(),
      centerTitle: false,
      title: Text("Assessment", style: headingTextStyle.copyWith(fontSize: 20)),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffE8DDD9),
          ),
          child: Text(
            "${model.currentStep} OF 6",
            style: headingTextStyle.copyWith(
              fontSize: 10,
              color: const Color(0xff926247),
            ),
          ),
        ),
      ],
    );
  }
}
