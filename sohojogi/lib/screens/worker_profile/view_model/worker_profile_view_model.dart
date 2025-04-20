import 'package:flutter/material.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class WorkerProfileViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  WorkerProfileModel? _workerProfile;
  bool _hirePending = false;
  int _selectedPortfolioIndex = 0;
  bool _isBookmarked = false;
  int _reviewPage = 1;
  final int _reviewsPerPage = 3;
  bool _hasMoreReviews = true;
  bool _isLoadingMoreReviews = false;
  RatingBreakdown? _ratingBreakdown;

  // Getters
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  WorkerProfileModel? get workerProfile => _workerProfile;
  bool get hirePending => _hirePending;
  int get selectedPortfolioIndex => _selectedPortfolioIndex;
  bool get isBookmarked => _isBookmarked;
  bool get hasMoreReviews => _hasMoreReviews;
  bool get isLoadingMoreReviews => _isLoadingMoreReviews;
  RatingBreakdown? get ratingBreakdown => _ratingBreakdown;

  List<WorkerReviewModel> get paginatedReviews {
    if (_workerProfile == null) return [];
    final end = _reviewPage * _reviewsPerPage;
    return _workerProfile!.reviews.take(end < _workerProfile!.reviews.length ?
    end : _workerProfile!.reviews.length).toList();
  }

  // Methods
  Future<void> loadWorkerProfile(String workerId) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would fetch from API: final data = await api.getWorkerProfile(workerId);
      _workerProfile = _getMockWorkerProfile(workerId);
      _ratingBreakdown = _getMockRatingBreakdown();
      _hasMoreReviews = _workerProfile!.reviews.length > _reviewsPerPage;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load worker profile. Please try again.';
      notifyListeners();
    }
  }

  Future<void> loadMoreReviews() async {
    if (!_hasMoreReviews || _isLoadingMoreReviews) return;

    _isLoadingMoreReviews = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    _reviewPage++;
    _hasMoreReviews = _reviewPage * _reviewsPerPage < _workerProfile!.reviews.length;
    _isLoadingMoreReviews = false;
    notifyListeners();
  }

  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
    notifyListeners();
    // In a real app: api.saveBookmark(workerId, isBookmarked);
  }

  Future<bool> initiateHiring() async {
    _hirePending = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would communicate with your backend: final result = await api.initiateHiring(workerId);
    const bool success = true;

    _hirePending = false;
    notifyListeners();
    return success;
  }

  void selectPortfolioItem(int index) {
    _selectedPortfolioIndex = index;
    notifyListeners();
  }

  // Get mock data (in real app, replace with API calls)
  WorkerProfileModel _getMockWorkerProfile(String workerId) {
    return WorkerProfileModel(
      id: workerId,
      name: 'John Smith',
      profileImage: 'https://randomuser.me/api/portraits/men/32.jpg',
      location: 'Dhanmondi, Dhaka',
      serviceCategory: 'Electrician',
      rating: 4.8,
      reviewCount: 243,
      email: 'john.smith@example.com',
      phoneNumber: '+880 1712345678',
      gender: Gender.male,
      bio: 'Professional electrician with 8+ years of experience. Specialized in residential and commercial electrical installations, repairs, and maintenance. I provide high-quality service with a focus on safety and customer satisfaction.',
      services: [
        WorkerServiceModel(
          id: 's1',
          name: 'Electrical Wiring Installation',
          description: 'Complete house wiring, industrial wiring, and circuit installation',
          price: 2500,
          unit: 'per job',
          isPopular: true,
        ),
        WorkerServiceModel(
          id: 's2',
          name: 'Circuit Breaker Repair',
          description: 'Diagnosis and repair of faulty circuit breakers',
          price: 800,
          unit: 'fixed',
        ),
        WorkerServiceModel(
          id: 's3',
          name: 'Light Fixture Installation',
          description: 'Installation of various light fixtures including ceiling fans',
          price: 600,
          unit: 'per fixture',
        ),
        WorkerServiceModel(
          id: 's4',
          name: 'Electrical Troubleshooting',
          description: 'Diagnosis and resolution of electrical issues',
          price: 500,
          unit: 'per hour',
        ),
      ],
      skills: [
        'Electrical Wiring',
        'Circuit Installation',
        'Electrical Repairs',
        'Lighting Systems',
        'Power Distribution',
        'Safety Inspection',
        'Fault Diagnosis',
      ],
      availability: [
        WorkerAvailabilityDay(
          day: DayOfWeek.monday,
          available: true,
          timeSlots: [
            TimeSlot(start: '09:00', end: '17:00'),
          ],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.tuesday,
          available: true,
          timeSlots: [
            TimeSlot(start: '09:00', end: '17:00'),
          ],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.wednesday,
          available: true,
          timeSlots: [
            TimeSlot(start: '09:00', end: '17:00'),
          ],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.thursday,
          available: true,
          timeSlots: [
            TimeSlot(start: '09:00', end: '17:00'),
          ],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.friday,
          available: false,
          timeSlots: [],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.saturday,
          available: true,
          timeSlots: [
            TimeSlot(start: '10:00', end: '15:00'),
          ],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.sunday,
          available: false,
          timeSlots: [],
        ),
      ],
      reviews: _getMockReviews(),
      portfolioItems: [
        WorkerPortfolioItem(
          id: 'p1',
          imageUrl: 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4',
          title: 'Residential Rewiring',
          description: 'Complete rewiring of a 3-bedroom apartment',
          date: DateTime.now().subtract(const Duration(days: 30)),
        ),
        WorkerPortfolioItem(
          id: 'p2',
          imageUrl: 'https://images.unsplash.com/photo-1598257006458-087169a1f08d',
          title: 'Commercial Installation',
          description: 'Electrical installation for a new office space',
          date: DateTime.now().subtract(const Duration(days: 45)),
        ),
        WorkerPortfolioItem(
          id: 'p3',
          imageUrl: 'https://images.unsplash.com/photo-1629139847512-6265ecoverview',
          title: 'Security Lighting',
          description: 'Outdoor security lighting installation for a villa',
          date: DateTime.now().subtract(const Duration(days: 60)),
        ),
      ],
      qualifications: [
        WorkerQualification(
          id: 'q1',
          title: 'Certified Electrician',
          issuer: 'Bangladesh Technical Education Board',
          issueDate: DateTime(2015, 6, 10),
        ),
        WorkerQualification(
          id: 'q2',
          title: 'Safety Standards Certification',
          issuer: 'National Association of Electrical Contractors',
          issueDate: DateTime(2017, 3, 5),
          expiryDate: DateTime(2025, 3, 5),
        ),
      ],
      completionRate: 97.5,
      jobsCompleted: 342,
      yearsOfExperience: 8,
      isVerified: true,
    );
  }

  List<WorkerReviewModel> _getMockReviews() {
    List<WorkerReviewModel> reviews = [];
    for (int i = 1; i <= 15; i++) {
      reviews.add(
        WorkerReviewModel(
          id: 'r$i',
          userName: 'Customer $i',
          userImage: 'https://randomuser.me/api/portraits/${i % 2 == 0 ? 'women' : 'men'}/${20 + i}.jpg',
          rating: 3 + (i % 3),
          comment: i % 3 == 0
              ? 'Excellent service! Very professional and efficient. Completed the work on time and left everything clean.'
              : i % 3 == 1
              ? 'Good job overall. The electrician was knowledgeable and solved our problems quickly.'
              : 'Satisfied with the service. Fixed our electrical issues and gave useful advice for maintenance.',
          date: DateTime.now().subtract(Duration(days: i * 3)),
          photos: i % 5 == 0 ? ['https://images.unsplash.com/photo-1558002038-40a443e7dd52'] : null,
        ),
      );
    }
    return reviews;
  }

  RatingBreakdown _getMockRatingBreakdown() {
    return RatingBreakdown(
      fiveStars: 180,
      fourStars: 42,
      threeStars: 15,
      twoStars: 4,
      oneStars: 2,
    );
  }
}