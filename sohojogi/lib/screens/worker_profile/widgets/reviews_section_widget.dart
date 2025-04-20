import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:intl/intl.dart';

class ReviewsSectionWidget extends StatelessWidget {
  final List<WorkerReviewModel> reviews;
  final bool isLoadingMore;
  final bool hasMoreReviews;

  const ReviewsSectionWidget({
    super.key,
    required this.reviews,
    required this.isLoadingMore,
    required this.hasMoreReviews,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'No reviews yet',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == reviews.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColor,
                  ),
                ),
              );
            }

            final review = reviews[index];
            return _buildReviewItem(review, context, isDarkMode);
          },
        ),

        if (hasMoreReviews && !isLoadingMore)
          Center(
            child: TextButton(
              onPressed: () {
                // This will trigger loadMoreReviews via scroll listener
                // when reaching bottom of the page
              },
              child: Text(
                'View more reviews',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewItem(WorkerReviewModel review, BuildContext context, bool isDarkMode) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? grayColor.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review header - user info and rating
          Row(
            children: [
              // User avatar
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(review.userImage),
              ),

              const SizedBox(width: 8),

              // User name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? lightColor : darkColor,
                      ),
                    ),
                    Text(
                      dateFormat.format(review.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              _buildRatingStars(review.rating),
            ],
          ),

          const SizedBox(height: 12),

          // Review content
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? lightColor.withOpacity(0.9) : darkColor.withOpacity(0.9),
            ),
          ),

          // Review photos
          if (review.photos != null && review.photos!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.photos!.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.photos![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, size: 14, color: Colors.amber);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, size: 14, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 14, color: Colors.amber);
        }
      }),
    );
  }
}