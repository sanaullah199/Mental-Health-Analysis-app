import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_onboarding.dart';
import 'package:mental_health_analysis_app/ui/screens/welcome/get_started_view_model.dart';
import 'package:provider/provider.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetStartedViewModel(),
      child: Consumer<GetStartedViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isActive = viewModel.currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 10 : 8,
                        height: isActive ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? const Color(0xFF4B3F29)
                              : const Color(0xFF4B3F29).withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    flex: 8,
                    child: PageView(
                      controller: viewModel.pageController,
                      onPageChanged: viewModel.onPageChanged,
                      children: [
                        CustomOnboarding(
                          imagePath: AppAssets.welcomeImage2,
                          step: 'STEP 1',
                          title: 'Personalize Your Mental',
                          highlighted: 'Health State',
                          subtitle: 'With AI',
                          textColor: textPrimaryColor,

                          highlightedTextColor: Color(0xff9BB068),
                        ),
                        CustomOnboarding(
                          imagePath: AppAssets.welcomeImage3,
                          step: 'STEP 2',
                          title: "Intelligent",
                          highlighted: ' Mood Tracking &',
                          subtitle: 'Emotion Insights',
                          textColor: Color(0xffFE631B),
                          tagColor: Color(0xffFE631B).withOpacity(0.3),
                          tagTextColor: Color(0xffFE814B),

                          highlightedTextColor: textPrimaryColor,
                        ),
                        CustomOnboarding(
                          imagePath: AppAssets.welcomeImage3,
                          step: 'STEP 3',
                          title: "Mindful",
                          highlighted: 'Resources',
                          subtitle: 'That Makes You Happy',
                          textColor: textPrimaryColor,

                          highlightedTextColor: Color(0xffFFBD1A),
                        ),
                        CustomOnboarding(
                          imagePath: AppAssets.welcomeImage5,
                          step: 'STEP 4',
                          title: 'Loving',
                          highlighted: '& Supportive',
                          subtitle: 'Community',
                          textColor: Color(0xff7152FF),
                          subtitleColor: Color(0xff7152FF),
                          tagColor: Color(0xff7152FF).withOpacity(0.3),
                          tagTextColor: Color(0xff7152FF),

                          highlightedTextColor: textPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.nextPage();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(AppAssets.forwardArrow),
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
