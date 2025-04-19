// lib/screens/worker_profile/widgets/skills_section_widget.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class SkillsSectionWidget extends StatelessWidget {
  final List<String> skills;

  const SkillsSectionWidget({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Expertise',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => _buildSkillChip(skill, isDarkMode)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, bool isDarkMode) {
    return Chip(
      label: Text(
        skill,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? darkColor : lightColor,
        ),
      ),
      backgroundColor: primaryColor.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}