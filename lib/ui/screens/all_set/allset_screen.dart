import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_button.dart';
import 'package:mental_health_analysis_app/ui/screens/all_set/allset_view_model.dart';
import 'package:provider/provider.dart';

class AllsetScreen extends StatelessWidget {
  final AssessmentModel assessmentModel;

  const AllsetScreen({super.key, required this.assessmentModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllSetViewModel(),
      child: Consumer<AllSetViewModel>(
        builder: (_, model, __) {
          return Scaffold(
            backgroundColor: const Color(0xff9BB068), 
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        Container(
                          padding: EdgeInsets.all(2),
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            "${AppAssets.iconsPath}/check.png",
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 20),

                    
                        Text(
                          "You're all Set Up.",
                          style: headingTextStyle.copyWith(
                            fontSize: 30,
                            height: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Your health score is:",
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),

                        const SizedBox(height: 20),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset("${AppAssets.imagePath}/circle.png"),

                            Text(
                              "${assessmentModel.aiScore}",
                              style: headingTextStyle.copyWith(
                                fontSize: 96,
                                fontWeight: FontWeight.bold,
                                color: model.getScoreColor(
                                  assessmentModel.aiScore,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                      
                        Text(
                          assessmentModel.aiSummary,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 20),

                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "MOOD:",
                              style: headingTextStyle.copyWith(
                                color: Colors.white70,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              model.getMoodImage(assessmentModel.mood),
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              assessmentModel.mood,
                              style: headingTextStyle.copyWith(
                                color: Colors.white70,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),

                        // const SizedBox(height: 30),

                        /// BUTTON
                        CustomButton(
                          text: "Lets Be Mindfull",
                          isLoading: model.state == ViewState.busy,
                          margin: EdgeInsetsGeometry.symmetric(vertical: 20),
                          onPressed: () {
                            model.navigateToDashboard();
                          },
                          border: Border.all(color: Colors.white, width: 1),

                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
