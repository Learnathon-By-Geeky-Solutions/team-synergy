import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';

class WorkerProfileModel extends ServiceProviderModel {
  final String bio;
  final List<WorkerServiceModel> services;
  final List<String> skills;
  final List<WorkerAvailabilityDay> availability;
  final List<WorkerReviewModel> reviews;
  final List<WorkerPortfolioItem> portfolioItems;
  final List<WorkerQualification> qualifications;
  final double completionRate;
  final int jobsCompleted;
  final int yearsOfExperience;
  final bool isVerified;

  WorkerProfileModel({
    required super.id,
    required super.name,
    required super.profileImage,
    required super.location,
    required super.serviceCategory,
    required super.rating,
    required super.reviewCount,
    required super.email,
    required super.phoneNumber,
    required super.gender,
    required this.bio,
    required this.services,
    required this.skills,
    required this.availability,
    required this.reviews,
    required this.portfolioItems,
    required this.qualifications,
    required this.completionRate,
    required this.jobsCompleted,
    required this.yearsOfExperience,
    required this.isVerified,
  });
}

class WorkerServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit; // per hour, fixed, etc.
  final bool isPopular;

  WorkerServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    this.isPopular = false,
  });
}

class WorkerReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String>? photos;

  WorkerReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
    this.photos,
  });
}

class WorkerPortfolioItem {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final DateTime date;

  WorkerPortfolioItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
  });
}

class WorkerQualification {
  final String id;
  final String title;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? certificateUrl;

  WorkerQualification({
    required this.id,
    required this.title,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.certificateUrl,
  });
}

enum DayOfWeek { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class TimeSlot {
  final String start;
  final String end;

  TimeSlot({required this.start, required this.end});
}

class WorkerAvailabilityDay {
  final DayOfWeek day;
  final bool available;
  final List<TimeSlot> timeSlots;

  WorkerAvailabilityDay({
    required this.day,
    required this.available,
    required this.timeSlots,
  });
}

// Rating breakdown model
class RatingBreakdown {
  final int fiveStars;
  final int fourStars;
  final int threeStars;
  final int twoStars;
  final int oneStars;

  RatingBreakdown({
    required this.fiveStars,
    required this.fourStars,
    required this.threeStars,
    required this.twoStars,
    required this.oneStars,
  });

  int get total => fiveStars + fourStars + threeStars + twoStars + oneStars;

  double getPercentage(int stars) {
    if (total == 0) return 0.0;
    switch (stars) {
      case 5: return fiveStars / total * 100;
      case 4: return fourStars / total * 100;
      case 3: return threeStars / total * 100;
      case 2: return twoStars / total * 100;
      case 1: return oneStars / total * 100;
      default: return 0.0;
    }
  }
}