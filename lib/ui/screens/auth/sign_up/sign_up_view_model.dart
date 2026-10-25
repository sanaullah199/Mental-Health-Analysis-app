import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_screen.dart';

class SignUpViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final LocalStorageServices _localStorageServices = LocalStorageServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;
  GlobalKey<FormState> get formKey => _formKey;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      setState(ViewState.busy);
      try {
        final user = await _authService.register(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
        );
        if (user == null) {
          setState(ViewState.idle);
          return;
        }
        _localStorageServices.loginAlready = true;
        await Get.to(
          AssessmentScreen(),
          duration: Duration(microseconds: 300),
          transition: Transition.fade,
        );
      } finally {
        setState(ViewState.idle);
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
