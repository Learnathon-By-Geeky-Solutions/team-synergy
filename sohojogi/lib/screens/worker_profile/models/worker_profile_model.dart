import '../../../screens/service_searched/models/service_provider_model.dart';

class WorkerProfileModel extends ServiceProviderModel {
  final List<WorkerServiceModel> services;
  final List<String> skills;
  final List<WorkerAvailabilityDay> availability;
  final List<WorkerReviewModel> reviews;
  final List<WorkerPortfolioItem> portfolioItems;
  final List<WorkerQualification> qualifications;

  WorkerProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.profileImage,
    required super.location,
    required super.latitude,
    required super.longitude,
    required super.gender,
    required super.rating,
    required super.reviewCount,
    required super.serviceCategory,
    required super.bio,
    required super.completionRate,
    required super.jobsCompleted,
    required super.yearsOfExperience,
    required super.isVerified,
    super.categories = const [],
    required this.services,
    required this.skills,
    required this.availability,
    required this.reviews,
    required this.portfolioItems,
    required this.qualifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImage,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'gender': gender.index,
      'average_rating': rating,
      'review_count': reviewCount,
      'service_category': serviceCategory,
      'bio': bio,
      'completion_rate': completionRate,
      'jobs_completed': jobsCompleted,
      'years_of_experience': yearsOfExperience,
      'is_verified': isVerified,
      'services': services.map((service) => service.toJson()).toList(),
      'skills': skills,
      'availability': availability.map((day) => day.toJson()).toList(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'portfolio_items': portfolioItems.map((item) => item.toJson()).toList(),
      'qualifications': qualifications.map((qual) => qual.toJson()).toList(),
    };
  }

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    return WorkerProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image_url'] ?? 'https://via.placeholder.com/150',
      location: json['location'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      gender: Gender.values[json['gender'] as int],
      rating: json['average_rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      serviceCategory: json['service_category'],
      bio: json['bio'] ?? '',
      services: (json['services'] as List?)?.map((e) =>
          WorkerServiceModel.fromJson(e)).toList() ?? [],
      skills: List<String>.from(json['skills'] ?? []),
      availability: (json['availability'] as List?)?.map((e) =>
          WorkerAvailabilityDay.fromJson(e)).toList() ?? [],
      reviews: (json['reviews'] as List?)?.map((e) =>
          WorkerReviewModel.fromJson(e)).toList() ?? [],
      portfolioItems: (json['portfolio_items'] as List?)?.map((e) =>
          WorkerPortfolioItem.fromJson(e)).toList() ?? [],
      qualifications: (json['qualifications'] as List?)?.map((e) =>
          WorkerQualification.fromJson(e)).toList() ?? [],
      completionRate: json['completion_rate']?.toDouble() ?? 95.0,
      jobsCompleted: json['jobs_completed'] ?? 0,
      yearsOfExperience: json['years_of_experience'] ?? 1,
      isVerified: json['is_verified'] ?? false,
    );
  }}

class WorkerServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final bool isPopular;

  WorkerServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    this.isPopular = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'isPopular': isPopular,
    };
  }

  factory WorkerServiceModel.fromJson(Map<String, dynamic> json) {
    return WorkerServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': day.index,
      'is_available': available,
      'worker_time_slots': timeSlots.map((slot) => {
        'start_time': slot.start,
        'end_time': slot.end,
      }).toList(),
    };
  }

  factory WorkerAvailabilityDay.fromJson(Map<String, dynamic> json) {
    return WorkerAvailabilityDay(
      day: DayOfWeek.values[json['day_of_week'] as int],
      available: json['is_available'] as bool? ?? false,
      timeSlots: (json['worker_time_slots'] as List?)?.map((slot) => TimeSlot(
        start: slot['start_time'] as String,
        end: slot['end_time'] as String,
      )).toList() ?? [],
    );
  }
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class TimeSlot {
  final String start;
  final String end;

  TimeSlot({
    required this.start,
    required this.end,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'user_image': userImage,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'review_photos': photos?.map((url) => {'photo_url': url}).toList(),
    };
  }

  factory WorkerReviewModel.fromJson(Map<String, dynamic> json) {
    return WorkerReviewModel(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      userImage: json['user_image'] as String? ?? 'https://via.placeholder.com/150',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      photos: (json['review_photos'] as List?)?.map((e) => e['photo_url'] as String).toList(),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory WorkerPortfolioItem.fromJson(Map<String, dynamic> json) {
    return WorkerPortfolioItem(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class WorkerQualification {
  final String id;
  final String title;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;

  WorkerQualification({
    required this.id,
    required this.title,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issuer': issuer,
      'issue_date': issueDate.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
    };
  }

  factory WorkerQualification.fromJson(Map<String, dynamic> json) {
    return WorkerQualification(
      id: json['id'] as String,
      title: json['title'] as String,
      issuer: json['issuer'] as String,
      issueDate: DateTime.parse(json['issue_date'] as String),
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
    );
  }
}

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
    if (total == 0) return 0;
    switch (stars) {
      case 5: return (fiveStars / total) * 100;
      case 4: return (fourStars / total) * 100;
      case 3: return (threeStars / total) * 100;
      case 2: return (twoStars / total) * 100;
      case 1: return (oneStars / total) * 100;
      default: return 0;
    }
  }
}