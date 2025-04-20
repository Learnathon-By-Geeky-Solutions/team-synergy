import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class RatingBreakdownWidget extends StatelessWidget {
  final RatingBreakdown ratingBreakdown;
  final double overallRating;

  const RatingBreakdownWidget({
    super.key,
    required this.ratingBreakdown,
    required this.overallRating,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? grayColor.withValues(alpha: 0.3) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Overall rating
          Row(
            children: [
              Text(
                overallRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStars(overallRating),
                  const SizedBox(height: 4),
                  Text(
                    '${ratingBreakdown.total} ratings',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? lightGrayColor : grayColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating breakdown bars
          _buildRatingBar(5, ratingBreakdown.getPercentage(5), ratingBreakdown.fiveStars, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar(4, ratingBreakdown.getPercentage(4), ratingBreakdown.fourStars, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar(3, ratingBreakdown.getPercentage(3), ratingBreakdown.threeStars, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar(2, ratingBreakdown.getPercentage(2), ratingBreakdown.twoStars, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar(1, ratingBreakdown.getPercentage(1), ratingBreakdown.oneStars, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildStars(double rating) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.amber);
        }
      }),
    );
  }

  Widget _buildRatingBar(int stars, double percentage, int count, bool isDarkMode) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Row(
            children: [
              Text(
                '$stars',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.star, size: 12, color: Colors.amber),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: isDarkMode ? grayColor.withValues(alpha: 0.3) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getBarColor(stars),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? lightGrayColor : grayColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Color _getBarColor(int stars) {
    switch (stars) {
      case 5: return Colors.green;
      case 4: return Colors.lightGreen;
      case 3: return Colors.amber;
      case 2: return Colors.orange;
      case 1: return Colors.red;
      default: return Colors.grey;
    }
  }
}