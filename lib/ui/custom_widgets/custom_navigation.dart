import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavigation extends StatelessWidget {
  final Widget destination;
  final Widget child;
  final Duration duration;

  const CustomNavigation({
    super.key,
    required this.destination,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Smooth navigation with fade transition
        Get.to(
          () => destination,
          transition: Transition.fade, // you can choose: fade, rightToLeft, downToUp, etc.
          duration: duration,
        );
      },
      child: child,
    );
  }
}
