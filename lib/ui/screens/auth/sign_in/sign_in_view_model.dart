import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/services/database_services.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/dashboard/dashboard_screen.dart';

class SignInViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseServices _databaseServices = locator<DatabaseServices>();
  final LocalStorageServices _localStorageServices = LocalStorageServices();

  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  // TextEditingController get nameController => _nameController;
  GlobalKey<FormState> get formKey => _formKey;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      setState(ViewState.busy);

      try {
        final user = await _authService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (user == null) {
          setState(ViewState.idle);
          return;
        }

        final assessment = await _databaseServices.getAssessment(
          _authService.currentUser!.uid,
        );
        if (assessment != null) {
          _localStorageServices.loginAlready = true;
          _localStorageServices.assessmentCompleted = true;
          await Get.to(
            DashboardScreen(),
            //duration: Duration(milliseconds: 300),
            transition: Transition.fade,
          );
        } else {
          _localStorageServices.loginAlready = true;

          await Get.to(
            AssessmentScreen(),
            duration: Duration(milliseconds: 300),
            transition: Transition.fade,
          );
        }
      } finally {
        setState(ViewState.idle);
        notifyListeners();
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      debugPrint("Error resetting password: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
