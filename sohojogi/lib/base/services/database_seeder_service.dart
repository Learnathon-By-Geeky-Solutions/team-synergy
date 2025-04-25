// lib/base/services/database_seeder_service.dart
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/data/location_seed_data.dart';

class DatabaseSeederService {
  final _supabase = Supabase.instance.client;
  final _random = Random();

  // Service categories to distribute workers across
  final List<String> _serviceCategories = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Painter',
    'House Cleaner',
    'Gardener',
    'AC Technician',
    'Driver',
    'Cook',
    'Tutor',
    'Beautician',
    'Mechanic',
  ];

  // Skills by category for realistic skill distribution
  final Map<String, List<String>> _skillsByCategory = {
    'Plumber': ['Pipe Fitting', 'Leak Repair', 'Bathroom Installation', 'Drain Cleaning', 'Water Heater Installation'],
    'Electrician': ['Wiring Installation', 'Circuit Repair', 'Lighting Setup', 'Appliance Installation', 'Safety Inspection'],
    'Carpenter': ['Furniture Assembly', 'Woodworking', 'Cabinet Installation', 'Door Repair', 'Custom Shelving'],
    'Painter': ['Interior Painting', 'Exterior Painting', 'Wall Texturing', 'Color Consultation', 'Wallpaper Installation'],
    'House Cleaner': ['Deep Cleaning', 'Regular Maintenance', 'Window Cleaning', 'Move-in/out Cleaning', 'Sanitization'],
    'Gardener': ['Lawn Maintenance', 'Planting', 'Pruning', 'Pest Control', 'Landscape Design'],
    'AC Technician': ['Installation', 'Repair', 'Maintenance', 'Gas Refilling', 'Duct Cleaning'],
    'Driver': ['City Driving', 'Long Distance', 'Delivery', 'Chauffeur Service', 'Tour Guide'],
    'Cook': ['Home Cooking', 'Event Catering', 'Meal Prep', 'Specialty Cuisine', 'Baking'],
    'Tutor': ['Mathematics', 'Science', 'Languages', 'Test Preparation', 'Computer Skills'],
    'Beautician': ['Haircuts', 'Makeup', 'Manicure/Pedicure', 'Facials', 'Hair Coloring'],
    'Mechanic': ['Engine Repair', 'Brake Service', 'Oil Change', 'Diagnostics', 'Tire Replacement'],
  };

  Future<void> seedDatabase() async {
    try {
      final locations = _extractAllLocations();

      // Process in much smaller batches of 3 workers at a time
      for (int batch = 0; batch < 20; batch++) {
        debugPrint('Processing workers ${batch * 3 + 1}-${(batch + 1) * 3} of 60...');

        // Process workers one by one with more breathing room
        for (int i = 0; i < 3; i++) {
          final index = batch * 3 + i;
          if (index >= 60) break;

          final location = locations[index % locations.length];
          final category = _serviceCategories[index % _serviceCategories.length];

          // Create worker
          final workerId = await _createWorker(location, category);
          // Longer delay after worker creation
          await Future.delayed(const Duration(milliseconds: 300));

          // Create services
          await _createWorkerServices(workerId, category);
          await Future.delayed(const Duration(milliseconds: 500));

          // Create skills
          await _createWorkerSkills(workerId, category);
          await Future.delayed(const Duration(milliseconds: 500));

          // Create qualifications
          await _createWorkerQualifications(workerId, category);
          await Future.delayed(const Duration(milliseconds: 500));

          // Create portfolio items
          await _createPortfolioItems(workerId);
          await Future.delayed(const Duration(milliseconds: 500));

          // Create availability with longer delay after
          await _createAvailabilitySchedule(workerId);
          await Future.delayed(const Duration(seconds: 1));

          // Create reviews with much longer delay after (heaviest operation)
          await _createReviews(workerId);

          // Much longer pause after completing a worker
          await Future.delayed(const Duration(seconds: 2));
        }

        // Extended delay between batches
        await Future.delayed(const Duration(seconds: 4));
      }
    } catch (e) {
      debugPrint('Error seeding database: $e');
      rethrow;
    }
  }


  List<Map<String, dynamic>> _extractAllLocations() {
    List<Map<String, dynamic>> allLocations = [];

    locationSeedData.forEach((country, countryData) {
      final states = countryData['states'] as Map<String, dynamic>;

      states.forEach((state, stateData) {
        if (stateData is Map && stateData.containsKey('cities')) {
          final cities = stateData['cities'] as Map<String, dynamic>;

          cities.forEach((city, cityData) {
            if (cityData is Map && cityData.containsKey('areas') && cityData['areas'] is List) {
              final areas = cityData['areas'] as List;

              for (var area in areas) {
                allLocations.add({
                  'country': country,
                  'state': state,
                  'city': city,
                  'area': area['name'],
                  'postal_code': area.containsKey('postal_code') ? area['postal_code'] : '',
                });
              }
            } else {
              // If no areas defined, add the city level
              allLocations.add({
                'country': country,
                'state': state,
                'city': city,
                'area': '',
                'postal_code': '',
              });
            }
          });
        } else {
          // If no cities defined, add the state level
          allLocations.add({
            'country': country,
            'state': state,
            'city': '',
            'area': '',
            'postal_code': '',
          });
        }
      });
    });

    return allLocations;
  }

  Future<String> _createWorker(Map<String, dynamic> location, String category) async {
    final gender = _random.nextBool() ? 'Male' : 'Female';
    final name = _generateRandomName(location['country'], gender);
    final locationString = _formatLocationString(location);

    // Generate random coordinates within reasonable range for the location
    final latitude = 23.0 + _random.nextDouble() * 10; // Random coordinates (simplified)
    final longitude = 72.0 + _random.nextDouble() * 10;

    final worker = {
      'name': name,
      'profile_image_url': _getRandomProfileImage(gender),
      'location': locationString,
      'latitude': latitude,
      'longitude': longitude,
      'service_category': category,
      'email': _generateEmail(name),
      'phone_number': _generatePhoneNumber(location['country']),
      'gender': gender,
      'bio': _generateBio(name, category, location['city']),
      'completion_rate': 85 + _random.nextDouble() * 15,
      'jobs_completed': _random.nextInt(200),
      'years_of_experience': 1 + _random.nextInt(10),
      'is_verified': _random.nextDouble() > 0.3, // 70% verified
      'average_rating': 3.5 + _random.nextDouble() * 1.5,
      'review_count': 3 + _random.nextInt(30),
    };

    final response = await _supabase.from('workers').insert(worker).select();
    return response[0]['id'] as String;
  }

  Future<void> _createWorkerServices(String workerId, String category) async {
    final serviceCount = 2 + _random.nextInt(4); // 2-5 services

    final List<Map<String, dynamic>> services = [];
    final baseServices = _getBaseServices(category);

    for (int i = 0; i < serviceCount; i++) {
      final service = baseServices[i % baseServices.length];

      // Add some price variation
      final price = service['base_price'] * (0.8 + _random.nextDouble() * 0.4);

      services.add({
        'worker_id': workerId,
        'name': service['name'],
        'description': service['description'],
        'price': price,
        'unit': service['unit'],
        'is_popular': i == 0, // Make the first service popular
      });
    }

    await _supabase.from('worker_services').insert(services);
  }

  Future<void> _createWorkerSkills(String workerId, String category) async {
    final skillCount = 3 + _random.nextInt(5); // 3-7 skills
    final availableSkills = _skillsByCategory[category] ?? [];
    final selectedSkills = <String>{};

    // Add category-specific skills
    while (selectedSkills.length < skillCount && availableSkills.isNotEmpty) {
      selectedSkills.add(availableSkills[_random.nextInt(availableSkills.length)]);
    }

    // Add general skills if needed
    final generalSkills = ['Customer Service', 'Time Management', 'Problem Solving'];
    while (selectedSkills.length < skillCount) {
      selectedSkills.add(generalSkills[_random.nextInt(generalSkills.length)]);
    }

    final skills = selectedSkills.map((skill) => {
      'worker_id': workerId,
      'skill_name': skill,
    }).toList();

    await _supabase.from('worker_skills').insert(skills);
  }

  Future<void> _createWorkerQualifications(String workerId, String category) async {
    final qualCount = 1 + _random.nextInt(3); // 1-3 qualifications
    final qualifications = _generateQualifications(category, qualCount);

    final List<Map<String, dynamic>> records = qualifications.map((qual) => {
      'worker_id': workerId,
      'title': qual['title'],
      'issuer': qual['issuer'],
      'issue_date': qual['issue_date'],
      'expiry_date': qual['expiry_date'],
      'certificate_url': qual['certificate_url'],
    }).toList();

    await _supabase.from('worker_qualifications').insert(records);
  }

  Future<void> _createPortfolioItems(String workerId) async {
    final itemCount = 2 + _random.nextInt(5); // 2-6 portfolio items

    final List<Map<String, dynamic>> items = [];
    for (int i = 0; i < itemCount; i++) {
      items.add({
        'worker_id': workerId,
        'image_url': 'https://source.unsplash.com/random/800x600?work',
        'title': _getRandomPortfolioTitle(),
        'description': 'Completed this project with great customer satisfaction.',
        'date': _getRandomPastDate(365 * 2), // Within last 2 years
      });
    }

    await _supabase.from('worker_portfolio_items').insert(items);
  }

  Future<void> _createAvailabilitySchedule(String workerId) async {
    final List<Map<String, dynamic>> availability = [];

    // Generate weekly schedule
    for (int day = 0; day < 7; day++) {
      final isAvailable = _random.nextDouble() > 0.2; // 80% available

      availability.add({
        'worker_id': workerId,
        'day_of_week': day,
        'is_available': isAvailable,
      });
    }

    final response = await _supabase.from('worker_availability').insert(availability).select();

    // Create time slots for available days
    for (final avail in response) {
      if (avail['is_available']) {
        await _createTimeSlots(avail['id']);
      }
    }
  }

  Future<void> _createTimeSlots(String availabilityId) async {
    final slotCount = 1 + _random.nextInt(2); // 1-2 time slots per day
    final List<Map<String, dynamic>> slots = [];

    // Common time slots
    final availableSlots = [
      {'start': '09:00', 'end': '12:00'},
      {'start': '13:00', 'end': '17:00'},
      {'start': '18:00', 'end': '21:00'},
    ];

    for (int i = 0; i < slotCount; i++) {
      slots.add({
        'availability_id': availabilityId,
        'start_time': availableSlots[i]['start'],
        'end_time': availableSlots[i]['end'],
      });
    }

    await _supabase.from('worker_time_slots').insert(slots);
  }

  Future<void> _createReviews(String workerId) async {
    final reviewCount = 3 + _random.nextInt(8); // 3-10 reviews

    // Process reviews individually with longer pauses
    for (int i = 0; i < reviewCount; i++) {
      final rating = 3 + _random.nextInt(3);
      final hasPhotos = _random.nextDouble() > 0.7;

      // Create review
      final reviewData = {
        'worker_id': workerId,
        'user_id': null,
        'user_name': _generateRandomName('Global', _random.nextBool() ? 'Male' : 'Female'),
        'user_image': 'https://i.pravatar.cc/150?img=${_random.nextInt(70)}',
        'rating': rating,
        'comment': _generateReviewComment(rating),
        'date': _getRandomPastDate(180),
      };

      final response = await _supabase.from('worker_reviews').insert(reviewData).select();
      final reviewId = response[0]['id'];

      // Important: Pause after each review creation
      await Future.delayed(const Duration(milliseconds: 300));

      // Create photos if needed
      if (hasPhotos) {
        final photoCount = 1 + _random.nextInt(3);

        for (int k = 0; k < photoCount; k++) {
          await _supabase.from('review_photos').insert({
            'review_id': reviewId,
            'photo_url': 'https://source.unsplash.com/random/800x600?work,service',
          });

          // Pause after each photo creation
          await Future.delayed(const Duration(milliseconds: 200));
        }

        // Additional pause after creating photos
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Longer pause after processing each review with its photos
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }


  // Helper methods for generating realistic data
  String _formatLocationString(Map<String, dynamic> location) {
    final parts = [
      location['area'],
      location['city'],
      location['state'],
      location['country']
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(', ');
  }

  String _generateRandomName(String country, String gender) {
    final firstNames = {
      'Pakistan': {
        'Male': ['Ali', 'Ahmed', 'Muhammad', 'Hassan', 'Faisal', 'Imran'],
        'Female': ['Fatima', 'Ayesha', 'Sara', 'Zainab', 'Maryam']
      },
      'Bangladesh': {
        'Male': ['Rahim', 'Karim', 'Abdul', 'Mohammed', 'Jahangir'],
        'Female': ['Farida', 'Nasreen', 'Shahana', 'Rabia', 'Sumaiya']
      },
      'India': {
        'Male': ['Raj', 'Amit', 'Vikram', 'Rahul', 'Sanjay'],
        'Female': ['Priya', 'Neha', 'Anjali', 'Sunita', 'Deepa']
      },
      'United Arab Emirates': {
        'Male': ['Mohammed', 'Ahmed', 'Omar', 'Khalid', 'Saeed'],
        'Female': ['Aisha', 'Fatima', 'Maryam', 'Noura', 'Hessa']
      },
      'Saudi Arabia': {
        'Male': ['Abdullah', 'Fahad', 'Mohammed', 'Salman', 'Khaled'],
        'Female': ['Aisha', 'Fatima', 'Noor', 'Layla', 'Sara']
      },
      'Global': {
        'Male': ['John', 'David', 'Michael', 'Robert', 'James'],
        'Female': ['Mary', 'Sarah', 'Jennifer', 'Lisa', 'Emma']
      }
    };

    final lastNames = {
      'Pakistan': ['Khan', 'Ahmed', 'Ali', 'Malik', 'Qureshi', 'Siddiqui'],
      'Bangladesh': ['Rahman', 'Islam', 'Hossain', 'Ahmed', 'Karim'],
      'India': ['Sharma', 'Patel', 'Singh', 'Verma', 'Gupta'],
      'United Arab Emirates': ['Al Maktoum', 'Al Nahyan', 'Al Qasimi', 'Al Mazrouei'],
      'Saudi Arabia': ['Al Saud', 'Al Sheikh', 'Al Ghamdi', 'Al Otaibi'],
      'Global': ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones']
    };

    // Get names for the country or use global if not available
    final countryFirstNames = firstNames[country]?[gender] ?? firstNames['Global']![gender]!;
    final countryLastNames = lastNames[country] ?? lastNames['Global']!;

    final firstName = countryFirstNames[_random.nextInt(countryFirstNames.length)];
    final lastName = countryLastNames[_random.nextInt(countryLastNames.length)];

    return '$firstName $lastName';
  }

  String _generateEmail(String name) {
    final normalizedName = name.toLowerCase().replaceAll(' ', '.');
    final domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com'];
    final domain = domains[_random.nextInt(domains.length)];

    return '$normalizedName${_random.nextInt(1000)}@$domain';
  }

  String _generatePhoneNumber(String country) {
    final countryCode = {
      'Pakistan': '+92',
      'Bangladesh': '+880',
      'India': '+91',
      'United Arab Emirates': '+971',
      'Saudi Arabia': '+966',
    }[country] ?? '+1';

    // Generate 10 random digits
    final number = List.generate(10, (_) => _random.nextInt(10)).join();

    return '$countryCode$number';
  }

  String _generateBio(String name, String category, String city) {
    final List<String> bios = [
      'Professional $category with extensive experience serving clients in $city and surrounding areas.',
      'Dedicated $category focused on quality and customer satisfaction. Available for all your needs in $city.',
      'Experienced and reliable $category providing prompt and professional service across $city.',
      'Hi, I\'m $name. I offer exceptional $category services with attention to detail and competitive rates.',
      'Trusted $category with a proven track record of excellence. Servicing all areas in $city.'
    ];

    return bios[_random.nextInt(bios.length)];
  }

  String _getRandomProfileImage(String gender) {
    final imageIndex = _random.nextInt(99) + 1;
    return 'https://i.pravatar.cc/300?img=$imageIndex';
  }

  List<Map<String, dynamic>> _getBaseServices(String category) {
    final Map<String, List<Map<String, dynamic>>> servicesByCategory = {
      'Plumber': [
        {'name': 'Pipe Repair', 'description': 'Fix leaking pipes quickly and effectively', 'base_price': 30.0, 'unit': 'per hour'},
        {'name': 'Drain Cleaning', 'description': 'Unclog drains and ensure proper water flow', 'base_price': 25.0, 'unit': 'per job'},
        {'name': 'Bathroom Installation', 'description': 'Complete bathroom fixture installation', 'base_price': 120.0, 'unit': 'per job'},
        {'name': 'Water Heater Service', 'description': 'Repair and installation of water heaters', 'base_price': 80.0, 'unit': 'per job'},
      ],
      'Electrician': [
        {'name': 'Wiring Installation', 'description': 'Safe and code-compliant wiring for your property', 'base_price': 40.0, 'unit': 'per hour'},
        {'name': 'Circuit Repair', 'description': 'Fix electrical circuits and prevent hazards', 'base_price': 50.0, 'unit': 'per job'},
        {'name': 'Lighting Setup', 'description': 'Install and configure lighting fixtures', 'base_price': 35.0, 'unit': 'per fixture'},
        {'name': 'Appliance Installation', 'description': 'Safe installation of electrical appliances', 'base_price': 60.0, 'unit': 'per appliance'},
      ],
      // Additional categories and their services would be defined similarly
    };

    // Fallback to generic services if category not defined
    if (!servicesByCategory.containsKey(category)) {
      return [
        {'name': 'Basic Service', 'description': 'Standard service package', 'base_price': 30.0, 'unit': 'per hour'},
        {'name': 'Premium Service', 'description': 'Premium service with additional features', 'base_price': 50.0, 'unit': 'per hour'},
        {'name': 'Emergency Service', 'description': 'Quick response for urgent needs', 'base_price': 70.0, 'unit': 'per job'},
        {'name': 'Consultation', 'description': 'Professional advice and assessment', 'base_price': 25.0, 'unit': 'per session'},
      ];
    }

    return servicesByCategory[category]!;
  }

  List<Map<String, dynamic>> _generateQualifications(String category, int count) {
    final List<Map<String, dynamic>> qualifications = [];

    final Map<String, List<String>> qualTitles = {
      'Plumber': ['Licensed Plumber', 'Plumbing Certificate', 'Water Systems Specialist'],
      'Electrician': ['Certified Electrician', 'Electrical Safety Certificate', 'Wiring Expert'],
      // Add more categories as needed
    };

    final List<String> issuers = [
      'National Trade Association',
      'City Technical Institute',
      'Professional Guild of Specialists',
      'Technical Training Center',
    ];

    final titles = qualTitles[category] ?? ['Professional Certificate', 'Technical Diploma', 'Service Excellence Award'];

    for (int i = 0; i < count; i++) {
      final issueYear = DateTime.now().year - _random.nextInt(10);
      final expiryYear = _random.nextBool() ? issueYear + 5 + _random.nextInt(5) : null;

      qualifications.add({
        'title': titles[i % titles.length],
        'issuer': issuers[_random.nextInt(issuers.length)],
        'issue_date': '$issueYear-${1 + _random.nextInt(12)}-${1 + _random.nextInt(28)}',
        'expiry_date': expiryYear != null ? '$expiryYear-${1 + _random.nextInt(12)}-${1 + _random.nextInt(28)}' : null,
        'certificate_url': 'https://example.com/certificate/${_random.nextInt(1000)}',
      });
    }

    return qualifications;
  }

  String _getRandomPortfolioTitle() {
    final List<String> titles = [
      'Residential Project',
      'Commercial Service',
      'Emergency Repair',
      'Major Installation',
      'Renovation Work',
      'Custom Solution',
    ];

    return titles[_random.nextInt(titles.length)];
  }

  String _getRandomPastDate(int daysBack) {
    final now = DateTime.now();
    final randomDays = _random.nextInt(daysBack);
    final date = now.subtract(Duration(days: randomDays));

    return date.toIso8601String().split('T')[0]; // YYYY-MM-DD format
  }

  String _generateReviewComment(int rating) {
    final List<String> positiveComments = [
      'Excellent service, very professional and efficient.',
      'Did a great job, arrived on time and completed the work perfectly.',
      'Very satisfied with the quality of work. Would definitely hire again.',
      'Friendly, professional and reasonably priced. Highly recommended!',
      'Great experience from start to finish. Very knowledgeable and helpful.',
    ];

    final List<String> neutralComments = [
      'Service was okay. Got the job done but took longer than expected.',
      'Decent work overall. Some minor issues but they were resolved.',
      'Average experience. Nothing outstanding but no major complaints.',
      'Reasonable service for the price. Could improve on communication.',
    ];

    final List<String> negativeComments = [
      'Disappointed with the service. Had to call them back to fix issues.',
      'Work was not up to standard. Wouldn\'t recommend.',
      'Showed up late and didn\'t complete everything as agreed.',
    ];

    if (rating >= 4) {
      return positiveComments[_random.nextInt(positiveComments.length)];
    } else if (rating == 3) {
      return neutralComments[_random.nextInt(neutralComments.length)];
    } else {
      return negativeComments[_random.nextInt(negativeComments.length)];
    }
  }
}