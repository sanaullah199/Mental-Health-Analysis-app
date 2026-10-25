import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_loader.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? destination;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool isLoading;
  final String? icon;
  final Color? iconColor;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final Border? border;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.destination,
    this.backgroundColor = primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 46.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
    this.margin = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.isLoading = false,
    this.icon,
    this.iconColor,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.transitionCurve = Curves.easeInOut,
    this.border,
  });

  void _handleTap() {
    if (isLoading) return;

    if (onPressed != null) {
      onPressed!();
    } else if (destination != null) {
      Get.to(
        () => destination!,
        transition: Transition.fadeIn,
        duration: transitionDuration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled =
        isLoading || (onPressed == null && destination == null);

    return GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          border: border ?? Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius),
          color: isDisabled
              ? backgroundColor.withOpacity(0.6)
              : backgroundColor,
        ),
        child: Center(
          child: isLoading
              ? CustomLoader(size: 24, color: textColor)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: headingTextStyle.copyWith(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    if (icon != null || AppAssets.forwardArrow != null) ...[
                      const SizedBox(width: 12),
                      icon == ""
                          ? SizedBox()
                          : Image.asset(
                              icon ?? AppAssets.forwardArrow,
                              color: iconColor ?? textColor,
                              width: 24,
                              height: 24,
                            ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
