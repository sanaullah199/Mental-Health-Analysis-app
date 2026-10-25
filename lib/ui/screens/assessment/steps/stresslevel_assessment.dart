import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';

class StresslevelAssessment extends StatelessWidget {
  final AssessmentViewModel model;
  const StresslevelAssessment(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "How would you rate your stress level?",
            textAlign: TextAlign.center,
            style: headingTextStyle,
          ),
        ),
        SizedBox(height: 40),
        // Big Number
        Text(
          model.selected.toString(),
          style: headingTextStyle.copyWith(fontSize: 180, color: primaryColor),
        ),
        //const SizedBox(height: 30),

        // Selection Bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              int number = i + 1;
              return RatingCircle(
                number: number,
                isSelected: model.selected == number,
                onTap: () => model.select(number),
              );
            }),
          ),
        ),
        SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: Text(
            model.stressDescription,
            key: ValueKey(model.stressDescription),
            textAlign: TextAlign.center,
            style: headingTextStyle.copyWith(
              fontSize: 20,
              color: Color(0xff1F160F).withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class RatingCircle extends StatelessWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const RatingCircle({
    super.key,
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 56,
        height: 56,
        duration: const Duration(milliseconds: 200),
        // padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFFFE814B) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Color(0xFFFE814B) : primaryColor,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: headingTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : primaryColor,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
