import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  final VoidCallback onTap;
  final String text1, text2;

  const AlreadyHaveAccountText({
    super.key,
    required this.onTap,
    this.text1 = "If you already have an account, ",
    this.text2 = "Sign in",
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text1,
        style: subBodyTextStyle,

        children: [
          TextSpan(
            text: text2,
            style: subBodyTextStyle.copyWith(
              color: textOrangeColor,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
