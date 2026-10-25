import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_loader.dart';
import 'package:mental_health_analysis_app/ui/screens/compiling/compiling_assessment_view_model.dart';
import 'package:provider/provider.dart';

class CompilingAssessment extends StatelessWidget {
  AssessmentModel assessmentModel;
  CompilingAssessment({super.key, required this.assessmentModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = CompilingAssessmentViewModel(assessmentModel);
        vm.setup();
        return vm;
      },
      child: Consumer<CompilingAssessmentViewModel>(
        builder: (_, model, __) {
          return Scaffold(
            backgroundColor: Color(0xffFE814B),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLoader(size: 72, color: Color(0xffFFD2C2)),
                  SizedBox(height: 10),
                  Text(
                    "Compiling Data...",
                    style: headingTextStyle.copyWith(color: Colors.white),
                  ),
                  //SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Please wait... We’re calculating the data based on your asessment inputs.",
                      textAlign: TextAlign.center,
                      style: bodyTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
