import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_already_acount_text.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_button.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_in/sign_in_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/welcome/get_start_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to the ultimate mental health analysis plateform",
              textAlign: TextAlign.center,
              style: headingTextStyle.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Your mindful mental health AI companion for everyone, anywhere 🍃",
              textAlign: TextAlign.center,
              style: bodyTextStyle,
            ),
            SizedBox(height: 15),

            Image.asset(AppAssets.welcomeImage),
            SizedBox(height: 20),
            CustomButton(
              text: "Get Started",
              isLoading: false,
              destination: GetStartScreen(),

              margin: EdgeInsetsGeometry.symmetric(horizontal: 40),
            ),
            SizedBox(height: 30),
            AlreadyHaveAccountText(
              onTap: () {
                LocalStorageServices().welcomeCompleted = true;
                Get.to(SignInScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
