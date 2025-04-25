// lib/screens/worker_profile/view_model/worker_profile_view_model.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

import '../../../base/services/worker_service.dart';

class WorkerProfileViewModel extends ChangeNotifier {
  final WorkerDatabaseService _service = WorkerDatabaseService();

  WorkerProfileModel? _workerProfile;
  List<WorkerReviewModel> _reviews = [];
  RatingBreakdown? _ratingBreakdown;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isBookmarked = false;
  bool _hirePending = false;
  bool _isLoadingMoreReviews = false;
  bool _hasMoreReviews = true;
  int _currentPage = 0;
  int _selectedPortfolioIndex = 0;

  // Getters
  WorkerProfileModel? get workerProfile => _workerProfile;
  List<WorkerReviewModel> get paginatedReviews => _reviews;
  RatingBreakdown? get ratingBreakdown => _ratingBreakdown;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isBookmarked => _isBookmarked;
  bool get hirePending => _hirePending;
  bool get isLoadingMoreReviews => _isLoadingMoreReviews;
  bool get hasMoreReviews => _hasMoreReviews;
  int get selectedPortfolioIndex => _selectedPortfolioIndex;

  // Load worker profile data
  Future<void> loadWorkerProfile(String workerId) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final profile = await _service.getWorkerProfile(workerId);
      if (profile == null) {
        _hasError = true;
        _errorMessage = 'Worker profile not found';
      } else {
        _workerProfile = profile;

        // Reset reviews pagination
        _currentPage = 0;
        _reviews = [];
        _hasMoreReviews = true;

        // Load initial reviews
        await loadMoreReviews(workerId: workerId);

        // Load rating breakdown
        _ratingBreakdown = await _service.getRatingBreakdown(workerId);
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to load profile: ${e.toString()}';
      debugPrint('Error in loadWorkerProfile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more reviews with pagination
  Future<void> loadMoreReviews({String? workerId}) async {
    if (!_hasMoreReviews || _isLoadingMoreReviews) return;

    _isLoadingMoreReviews = true;
    notifyListeners();

    try {
      final String id = workerId ?? _workerProfile!.id;
      final newReviews = await _service.getWorkerReviews(id, page: _currentPage);

      if (newReviews.isEmpty) {
        _hasMoreReviews = false;
      } else {
        _reviews.addAll(newReviews);
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error loading more reviews: $e');
    } finally {
      _isLoadingMoreReviews = false;
      notifyListeners();
    }
  }

  // Toggle bookmark status
  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
    notifyListeners();
    // TODO: Implement actual bookmark functionality with database
  }

  // Select portfolio item
  void selectPortfolioItem(int index) {
    _selectedPortfolioIndex = index;
    notifyListeners();
  }

  // Initiate hiring process
  Future<bool> initiateHiring() async {
    _hirePending = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _hirePending = false;
    notifyListeners();

    // TODO: Implement actual hiring functionality with database
    return true;
  }
}