import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';

class CustomOnboarding extends StatelessWidget {
  final String imagePath;
  final String step;
  final String title;
  //final Color tagColor;
  final String highlighted;
  final Color highlightedTextColor;
  final Color textColor;
  final Color? tagColor;
  final Color? tagTextColor;
  final Color? subtitleColor;

  final String subtitle;
  //final GestureTapCallback onTap;

  const CustomOnboarding({
    super.key,
    required this.imagePath,
    required this.step,
    required this.title,
    this.tagColor,
    this.tagTextColor,
    required this.highlighted,
    required this.subtitle,
    this.subtitleColor,
    required this.highlightedTextColor,
    required this.textColor,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Illustration
        Image.asset(imagePath, fit: BoxFit.contain, width: double.infinity),

        // Bottom Curved Section
        Positioned(
          top: 340, // adjust to position right below the image
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipPath(
            clipper: TopArcClipper(factor: 15),
            child: Container(
              color: scafoledBgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          tagColor ??
                          highlightedTextColor.withOpacity(0.3), // 20% opacity,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      step,
                      style: headingTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: tagTextColor ?? highlightedTextColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Title + Highlighted + Subtitle
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$title ',
                            style: headingTextStyle.copyWith(color: textColor),
                          ),
                          TextSpan(
                            text: '$highlighted ',
                            style: headingTextStyle.copyWith(
                              color: highlightedTextColor,
                            ),
                          ),
                          TextSpan(text: subtitle, style: headingTextStyle),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // const SizedBox(height: 30),

                  // Next Button
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopArcClipper extends CustomClipper<Path> {
  final double factor; // How deep the curve goes

  TopArcClipper({this.factor = 20}); // default factor

  @override
  Path getClip(Size size) {
    final path = Path();
    // Start at top-left
    path.moveTo(0, size.height * (factor / 100));
    // Curve to top-right
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * (factor / 2 / 100),
      size.width,
      size.height * (factor / 100),
    );
    // Right side down
    path.lineTo(size.width, size.height);
    // Bottom side
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
