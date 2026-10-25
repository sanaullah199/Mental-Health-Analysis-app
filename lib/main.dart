import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/firebase_options.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_in/sign_in_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/dashboard/dashboard_screen.dart';

import 'package:mental_health_analysis_app/ui/screens/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storage = LocalStorageServices();
  await storage.init();

  Widget initialScreen;
  if (!storage.welcomeCompleted) {
    initialScreen = WelcomeScreen();
  } else if (!storage.loginAlready) {
    initialScreen = SignInScreen();
  } else if (!storage.assessmentCompleted) {
    initialScreen = AssessmentScreen();
  } else {
    initialScreen = DashboardScreen();
  }

  setupLocator();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mental Health Analysis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "urbanRegular",
        scaffoldBackgroundColor: scafoledBgColor,
      ),
      home: initialScreen,
    );
  }
}
