import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class AboutSectionWidget extends StatefulWidget {
  final String bio;

  const AboutSectionWidget({
    super.key,
    required this.bio,
  });

  @override
  State<AboutSectionWidget> createState() => _AboutSectionWidgetState();
}

class _AboutSectionWidgetState extends State<AboutSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final maxLines = _isExpanded ? null : 3;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.bio,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? lightGrayColor : grayColor,
              height: 1.5,
            ),
            maxLines: maxLines,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (widget.bio.split('\n').length > 3 || widget.bio.length > 150)
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Show Less' : 'Read More',
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}