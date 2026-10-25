import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/ui/screens/assessment/assessment_view_model.dart';

class MedicationsAssessment extends StatelessWidget {
  final AssessmentViewModel model;
  const MedicationsAssessment(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Are you taking any medications or supplements?",
            textAlign: TextAlign.center,
            style: headingTextStyle,
          ),
        ),
        SizedBox(height: 20),
        buildMedicationGrid(model),
      ],
    );
  }
}

Widget buildMedicationGrid(AssessmentViewModel model) {
  return GridView.builder(
    shrinkWrap: true,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.9,
    ),
    itemCount: model.medicationOptions.length,
    itemBuilder: (_, index) {
      final item = model.medicationOptions[index];

      final isSelected = model.selectedOption == item["value"];

      return MedicationOptionCard(
        icon: item["icon"],
        title: item["title"],
        isSelected: isSelected,
        onTap: () => model.selectOption(item["value"]),
      );
    },
  );
}

class MedicationOptionCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String icon;
  final String title;

  const MedicationOptionCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        // height: 164,
        // width: 164,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9BB068) : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
              color: isSelected ? whiteColor : primaryColor,
            ),

            Text(
              title,
              style: headingTextStyle.copyWith(
                fontSize: 16,
                color: isSelected ? whiteColor : primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
