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
import 'package:mental_health_analysis_app/ui/screens/auth/sign_in/sign_in_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_up/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
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
                      
                      Center(
                        child: Text(
                          "Sign Up To Your Account", // Generic text
                          textAlign: TextAlign.center,
                          style: headingTextStyle.copyWith(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Name",
                        style: headingTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                    
                      CustomTextFormField(
                        controller: model.nameController,
                        hintText: "Enter You Name",
                        prefixWidget: Image.asset(
                          "${AppAssets.iconsPath}/person.png",
                          width: 24,
                          height: 24,
                        ),
                        // prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.name,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Please enter your email";
                        //   }
                        //   return null;
                        // },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Email Address",
                        style: headingTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                    
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
                        // prefixIcon: Icons.lock_outline,
                        prefixWidget: Image.asset(
                          "${AppAssets.iconsPath}/password.png",
                          width: 24,
                          height: 24,
                        ),
                        obscureText: model.obscurePassword,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 32),

                     
                      CustomButton(
                        text: "Sign Up",
                        isLoading: model.state == ViewState.busy,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          model.signUp();
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: AlreadyHaveAccountText(
                          onTap: () {
                            // FocusScope.of(context).unfocus();

                            Get.to(
                              SignInScreen(),
                              transition: Transition.fadeIn,
                              duration: Duration(milliseconds: 500),
                            );
                            FocusScope.of(context).unfocus();
                          },
                          text1: "Already have an account?",
                          text2: "Sign In",
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
}

// Custom TextFormField for uniform styling
