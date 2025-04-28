// lib/screens/worker_profile/view_model/worker_profile_view_model.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

import '../../../base/services/order_service.dart';
import '../../../base/services/worker_service.dart';

class WorkerProfileViewModel extends ChangeNotifier {
  final WorkerDatabaseService _service = WorkerDatabaseService();
  final OrderService _orderService = OrderService();
  final WorkerDatabaseService _workerService = WorkerDatabaseService();

  // Getters
  WorkerProfileModel? workerProfile;
  RatingBreakdown? ratingBreakdown;
  List<WorkerReviewModel> paginatedReviews = [];
  WorkerProfileModel? _workerProfile;
  final List<WorkerReviewModel> _reviews = [];
  WorkerProfileModel? worker;
  List<WorkerServiceModel> selectedServices = [];
  bool isLoading = true;
  bool isHiring = false;
  String? errorMessage;
  bool _isBookmarked = false;
  bool _isLoadingMoreReviews = false;
  bool _hasMoreReviews = true;
  int _currentPage = 0;
  bool hasError = false;
  bool hirePending = false;
  bool isBookmarked = false;
  bool isLoadingMoreReviews = false;
  bool hasMoreReviews = true;
  int currentReviewPage = 0;
  int selectedPortfolioIndex = 0;

  // Load worker profile data
  Future<void> loadWorkerProfile(String workerId) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Load worker profile data
      final profile = await _workerService.getWorkerProfile(workerId);
      if (profile != null) {
        workerProfile = profile;

        // Load initial reviews
        paginatedReviews = await _workerService.getWorkerReviews(workerId, page: 0);
        hasMoreReviews = paginatedReviews.length >= 10; // Assuming page size of 10

        // Load rating breakdown
        ratingBreakdown = await _workerService.getRatingBreakdown(workerId);
      } else {
        hasError = true;
      }
    } catch (e) {
      debugPrint('Error loading worker profile: $e');
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleServiceSelection(WorkerServiceModel service, bool isSelected) {
    if (isSelected) {
      selectedServices.add(service);
    } else {
      selectedServices.removeWhere((s) => s.id == service.id);
    }
    notifyListeners();
  }

  double get totalPrice {
    return selectedServices.fold(0, (sum, service) => sum + service.price);
  }

  Future<bool> hireWorker() async {
    if (selectedServices.isEmpty || worker == null) {
      errorMessage = 'Please select at least one service';
      notifyListeners();
      return false;
    }

    isHiring = true;
    notifyListeners();

    try {
      // Format services for the API
      final services = selectedServices.map((service) => {
        'service_id': service.id,
        'quantity': 1,
        'price': service.price,
        'subtotal': service.price,
      }).toList();

      // Create the order
      final orderId = await _orderService.createOrder(
          OrderRequest(
            workerId: worker!.id,
            title: 'Service from ${worker!.name}',
            description: 'Services: ${selectedServices.map((s) => s.name).join(", ")}',
            totalPrice: totalPrice,
            serviceType: worker!.serviceCategory,
            location: worker!.location,
            services: services,
          )
      );

      isHiring = false;
      if (orderId != null) {
        selectedServices.clear();
        notifyListeners();
        return true;
      } else {
        errorMessage = 'Failed to create order';
        notifyListeners();
        return false;
      }
    } catch (e) {
      isHiring = false;
      errorMessage = 'Error: ${e.toString()}';
      notifyListeners();
      return false;
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
    // implement actual bookmark functionality with database
  }

  // Select portfolio item
  void selectPortfolioItem(int index) {
    selectedPortfolioIndex = index;
    notifyListeners();
  }

  // Initiate hiring process
  Future<bool> initiateHiring() async {
    if (workerProfile == null) return false;

    // Check if services are selected
    if (selectedServices.isEmpty) {
      errorMessage = 'Please select at least one service';
      notifyListeners();
      return false;
    }

    hirePending = true;
    notifyListeners();

    try {
      // Get the selected services and calculate total price
      final totalPrice = selectedServices.fold(0.0, (sum, service) => sum + service.price);

      // Create order with selected services
      final services = selectedServices.map((service) => {
        'service_id': service.id,
        'quantity': 1,
        'price': service.price,
        'subtotal': service.price,
      }).toList();

      final orderId = await _orderService.createOrder(
          OrderRequest(
            workerId: workerProfile!.id,
            title: "Hire ${workerProfile!.name} for ${workerProfile!.serviceCategory}",
            description: "Services: ${selectedServices.map((s) => s.name).join(", ")}",
            totalPrice: totalPrice,
            serviceType: workerProfile!.serviceCategory,
            location: workerProfile!.location,
            services: services,
          )
      );

      // Clear selected services after successful order
      if (orderId != null) {
        selectedServices.clear();
      }

      return orderId != null;
    } catch (e) {
      debugPrint('Error initiating hiring: $e');
      return false;
    } finally {
      hirePending = false;
      notifyListeners();
    }
  }
}