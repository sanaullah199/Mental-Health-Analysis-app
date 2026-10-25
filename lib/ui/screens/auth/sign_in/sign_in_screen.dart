import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';

import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/constants/validators.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_already_acount_text.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_button.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_textformfield.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_in/sign_in_view_model.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_up/sign_up_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Consumer<SignInViewModel>(
        builder: (_, model, child) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Form(
                  key: model.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Center(
                        child: Text(
                          "Sign In To Your Account", // Generic text
                          textAlign: TextAlign.center,
                          style: headingTextStyle.copyWith(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Email Address",
                        style: headingTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      // Email field
                      CustomTextFormField(
                        controller: model.emailController,
                        hintText: "Email Address",
                        prefixWidget: Image.asset(
                          "${AppAssets.iconsPath}/email.png",
                          width: 24,
                          height: 24,
                        ),
                        // prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Password",
                        style: headingTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      // Password field
                      CustomTextFormField(
                        controller: model.passwordController,
                        hintText: "Enter your password",
                        suffex: GestureDetector(
                          onTap: () {
                            model.togglePasswordVisibility();
                          },
                          child: Icon(
                            model.obscurePassword == false
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryColor,
                          ),
                        ),
                        prefixWidget: Image.asset(
                          "${AppAssets.iconsPath}/password.png",
                          width: 24,
                          height: 24,
                        ),
                        obscureText: model.obscurePassword,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 12),
                   
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () =>
                              _showForgotPasswordDialog(context, model),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                     
                      CustomButton(
                        text: "Sign In",
                        isLoading: model.state == ViewState.busy,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          model.signIn();
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: AlreadyHaveAccountText(
                          onTap: () {
                            Get.to(
                              SignUpScreen(),
                              transition: Transition.fadeIn,
                              duration: Duration(milliseconds: 500),
                            );
                            FocusScope.of(context).unfocus();
                          },
                          text1: "Don't have an account?",
                          text2: "Sign Up",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context, SignInViewModel model) {
    final emailController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Reset Password",
                        style: headingTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  "Enter your email address and we'll send you a link to reset your password.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (emailController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please enter your email"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (!Validators.isValidEmail(
                                  emailController.text.trim(),
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please enter a valid email",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() => isLoading = true);
                                await model.resetPassword(
                                  emailController.text.trim(),
                                );
                                setState(() => isLoading = false);

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Send Reset Link",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom TextFormField for uniform styling
