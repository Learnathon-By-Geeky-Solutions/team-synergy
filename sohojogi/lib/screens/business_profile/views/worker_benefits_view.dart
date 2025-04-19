import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class WorkerBenefitsView extends StatelessWidget {
  const WorkerBenefitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkColor : const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : const Color(0xFFFFF8EC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Worker Benefits',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Why Join Us?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover the advantages of becoming a skilled worker on our platform.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
              ),
              const SizedBox(height: 32),

              // Benefits list
              _buildBenefitItem(
                context,
                icon: Icons.attach_money,
                title: 'Competitive Earnings',
                description: 'Set your own rates and earn more than traditional employment options.',
                isDarkMode: isDarkMode,
              ),

              _buildBenefitItem(
                context,
                icon: Icons.schedule,
                title: 'Flexible Schedule',
                description: 'Work when you want, where you want. You control your availability.',
                isDarkMode: isDarkMode,
              ),

              _buildBenefitItem(
                context,
                icon: Icons.verified_user,
                title: 'Professional Growth',
                description: 'Access to training resources and opportunities to improve your skills.',
                isDarkMode: isDarkMode,
              ),

              _buildBenefitItem(
                context,
                icon: Icons.safety_check,
                title: 'Safety & Support',
                description: 'Our platform implements safety protocols and provides support when you need it.',
                isDarkMode: isDarkMode,
              ),

              _buildBenefitItem(
                context,
                icon: Icons.payments,
                title: 'Secure Payments',
                description: 'Get paid on time with our secure payment system.',
                isDarkMode: isDarkMode,
              ),

              _buildBenefitItem(
                context,
                icon: Icons.reviews,
                title: 'Build Your Reputation',
                description: 'Showcase your skills and positive reviews to grow your customer base.',
                isDarkMode: isDarkMode,
              ),

              _buildBenefitItem(
                context,
                icon: Icons.group,
                title: 'Join Our Community',
                description: 'Connect with other skilled professionals and share experiences.',
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 32),

              // Call to action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    foregroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Register Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required bool isDarkMode,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? lightGrayColor : grayColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}