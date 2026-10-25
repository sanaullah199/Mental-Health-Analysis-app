import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_in/sign_in_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/welcome/get_start_screen.dart';

class GetStartedViewModel extends BaseViewModel {
  final PageController pageController = PageController();
  int currentPage = 0;

  final LocalStorageServices _storage = LocalStorageServices();

  GetStartedViewModel() {
    _storage.init(); 
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < 3) {
      
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    } else {
      
      _storage.welcomeCompleted = true;

     
      Get.to(() => SignInScreen(), transition: Transition.fade);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
