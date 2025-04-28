import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:intl/intl.dart';

class CredentialsSectionWidget extends StatelessWidget {
  final List<WorkerQualification> qualifications;

  const CredentialsSectionWidget({
    super.key,
    required this.qualifications,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (qualifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isDarkMode),
          const SizedBox(height: 16),
          _buildQualificationsList(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Icons.verified_user_outlined,
          size: 20,
          color: isDarkMode ? lightColor : darkColor,
        ),
        const SizedBox(width: 8),
        Text(
          'Qualifications & Certifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQualificationsList(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: qualifications.length,
      itemBuilder: (context, index) => _buildQualificationCard(
        qualifications[index],
        isDarkMode,
      ),
    );
  }

  Widget _buildQualificationCard(WorkerQualification qualification, bool isDarkMode) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? grayColor.withValues(alpha: 0.3) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQualificationHeader(qualification, isDarkMode),
            const SizedBox(height: 12),
            _buildQualificationDates(qualification, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildQualificationHeader(WorkerQualification qualification, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                qualification.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                qualification.issuer,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
              ),
            ],
          ),
        ),
        _buildValidityBadge(qualification),
      ],
    );
  }

  Widget _buildValidityBadge(WorkerQualification qualification) {
    final bool isExpired = qualification.expiryDate != null &&
        qualification.expiryDate!.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpired
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExpired
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.green.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        isExpired ? 'Expired' : 'Valid',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isExpired ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  Widget _buildQualificationDates(WorkerQualification qualification, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        const SizedBox(width: 4),
        Text(
          'Issued: ${DateFormat('MMM yyyy').format(qualification.issueDate)}',
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
        if (qualification.expiryDate != null) ...[
          const SizedBox(width: 12),
          Text(
            'Expires: ${DateFormat('MMM yyyy').format(qualification.expiryDate!)}',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
          ),
        ],
      ],
    );
  }
}