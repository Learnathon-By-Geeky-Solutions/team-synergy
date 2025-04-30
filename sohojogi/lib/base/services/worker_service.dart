import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:flutter/foundation.dart';

class WorkerDatabaseService {
  final _supabase = Supabase.instance.client;

  // Load worker profile with all related data
  Future<WorkerProfileModel?> getWorkerProfile(String workerId) async {
    try {
      // Get basic worker information
      final workerResponse = await _supabase
          .from('workers')
          .select()
          .eq('id', workerId)
          .single();

      // Parse gender enum
      Gender gender = Gender.other;
      if (workerResponse['gender'] == 'male') {
        gender = Gender.male;
      } else if (workerResponse['gender'] == 'female') {
        gender = Gender.female;
      }

      // Get worker services
      final servicesResponse = await _supabase
          .from('worker_services')
          .select()
          .eq('worker_id', workerId);

      List<WorkerServiceModel> services = servicesResponse.map<WorkerServiceModel>((service) {
        return WorkerServiceModel(
          id: service['id'],
          name: service['name'],
          description: service['description'] ?? '',
          price: service['price'].toDouble(),
          unit: service['unit'],
          isPopular: service['is_popular'] ?? false,
        );
      }).toList();

      // Get worker skills
      final skillsResponse = await _supabase
          .from('worker_skills')
          .select()
          .eq('worker_id', workerId);

      List<String> skills = skillsResponse.map<String>((skill) {
        return skill['skill_name'];
      }).toList();

      // Get worker availability
      final availabilityResponse = await _supabase
          .from('worker_availability')
          .select('*, worker_time_slots(*)')
          .eq('worker_id', workerId);

      List<WorkerAvailabilityDay> availability = [];
      for (var day in availabilityResponse) {
        DayOfWeek dayEnum = DayOfWeek.values[day['day_of_week']];

        List<TimeSlot> timeSlots = [];
        if (day['worker_time_slots'] != null) {
          for (var slot in day['worker_time_slots']) {
            timeSlots.add(TimeSlot(
              start: slot['start_time'],
              end: slot['end_time'],
            ));
          }
        }

        availability.add(WorkerAvailabilityDay(
          day: dayEnum,
          available: day['is_available'] ?? false,
          timeSlots: timeSlots,
        ));
      }

      // Get worker qualifications
      final qualificationsResponse = await _supabase
          .from('worker_qualifications')
          .select()
          .eq('worker_id', workerId);

      List<WorkerQualification> qualifications = qualificationsResponse.map<WorkerQualification>((qual) {
        return WorkerQualification(
          id: qual['id'],
          title: qual['title'],
          issuer: qual['issuer'],
          issueDate: DateTime.parse(qual['issue_date']),
          expiryDate: qual['expiry_date'] != null ? DateTime.parse(qual['expiry_date']) : null,
        );
      }).toList();

      // Get worker portfolio items
      final portfolioResponse = await _supabase
          .from('worker_portfolio_items')
          .select()
          .eq('worker_id', workerId);

      List<WorkerPortfolioItem> portfolioItems = portfolioResponse.map<WorkerPortfolioItem>((item) {
        return WorkerPortfolioItem(
          id: item['id'],
          imageUrl: item['image_url'],
          title: item['title'],
          description: item['description'] ?? '',
          date: DateTime.parse(item['date']),
        );
      }).toList();

      // Create the worker profile model
      return WorkerProfileModel(
        id: workerResponse['id'],
        name: workerResponse['name'],
        profileImage: workerResponse['profile_image_url'] ?? 'https://via.placeholder.com/150',
        location: workerResponse['location'],
        latitude: workerResponse['latitude']?.toDouble() ?? 0.0,
        longitude: workerResponse['longitude']?.toDouble() ?? 0.0,
        serviceCategory: workerResponse['service_category'],
        rating: workerResponse['average_rating'].toDouble(),
        reviewCount: workerResponse['review_count'],
        email: workerResponse['email'],
        phoneNumber: workerResponse['phone_number'],
        gender: gender,
        bio: workerResponse['bio'] ?? 'No bio available',
        services: services,
        skills: skills,
        availability: availability,
        reviews: [],
        portfolioItems: portfolioItems,
        qualifications: qualifications,
        completionRate: workerResponse['completion_rate'].toDouble(),
        jobsCompleted: workerResponse['jobs_completed'],
        yearsOfExperience: workerResponse['years_of_experience'],
        isVerified: workerResponse['is_verified'] ?? false,
      );    } catch (e) {
      debugPrint('Error fetching worker profile: $e');
      return null;
    }
  }

  // Get reviews with pagination
  Future<List<WorkerReviewModel>> getWorkerReviews(
      String workerId,
      {int page = 0, int limit = 10}
      ) async {
    try {
      final reviewsResponse = await _supabase
          .from('worker_reviews')
          .select('*, review_photos(*)')
          .eq('worker_id', workerId)
          .order('date', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      return reviewsResponse.map<WorkerReviewModel>((review) {
        List<String> photos = [];
        if (review['review_photos'] != null) {
          photos = (review['review_photos'] as List)
              .map<String>((photo) => photo['photo_url'] as String)
              .toList();
        }

        return WorkerReviewModel(
          id: review['id'],
          userName: review['user_name'],
          userImage: review['user_image'] ?? 'https://via.placeholder.com/150',
          rating: review['rating'].toDouble(),
          comment: review['comment'] ?? '',
          date: DateTime.parse(review['date']),
          photos: photos,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching worker reviews: $e');
      return [];
    }
  }

  // Get rating breakdown data
  Future<RatingBreakdown> getRatingBreakdown(String workerId) async {
    try {
      final oneStars = await _countRatingsByStars(workerId, 1);
      final twoStars = await _countRatingsByStars(workerId, 2);
      final threeStars = await _countRatingsByStars(workerId, 3);
      final fourStars = await _countRatingsByStars(workerId, 4);
      final fiveStars = await _countRatingsByStars(workerId, 5);

      return RatingBreakdown(
        oneStars: oneStars,
        twoStars: twoStars,
        threeStars: threeStars,
        fourStars: fourStars,
        fiveStars: fiveStars,
      );
    } catch (e) {
      debugPrint('Error fetching rating breakdown: $e');
      return RatingBreakdown(
        oneStars: 0,
        twoStars: 0,
        threeStars: 0,
        fourStars: 0,
        fiveStars: 0,
      );
    }
  }

  // Helper to count reviews by star rating
  Future<int> _countRatingsByStars(String workerId, int stars) async {
    final response = await _supabase
        .from('worker_reviews')
        .select('id')
        .eq('worker_id', workerId)
        .eq('rating', stars);

    return response.count ?? 0;
  }
}

extension on PostgrestList {
  get count => null;
}