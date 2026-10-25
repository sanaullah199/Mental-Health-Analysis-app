import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color borderColor;
  final Color? backgroundColor;
  final double size;
  final String? iconPath;
  final Color iconColor ;

  const CustomBackButton({
    super.key,
    this.onTap,
    this.borderColor = primaryColor,
    this.backgroundColor,
    this.iconColor = primaryColor,
    this.size = 45,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
          color: backgroundColor ?? Colors.transparent,
        ),
        child: Image.asset(
          iconPath ?? "${AppAssets.iconsPath}/back_button.png",
          color: iconColor,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
