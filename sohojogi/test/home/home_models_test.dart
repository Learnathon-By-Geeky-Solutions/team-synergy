import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/home/models/home_models.dart';

void main() {
  group('BannerModel Tests', () {
    test('should create a BannerModel with correct properties', () {
      // Arrange & Act
      const title = 'Test Banner';
      final color = Colors.blue;
      final banner = BannerModel(title: title, color: color);

      // Assert
      expect(banner.title, title);
      expect(banner.color, color);
    });
  });

  group('ServiceModel Tests', () {
    test('should create a ServiceModel with correct properties', () {
      // Arrange & Act
      const name = 'Test Service';
      const icon = Icons.home;
      final service = ServiceModel(name: name, icon: icon);

      // Assert
      expect(service.name, name);
      expect(service.icon, icon);
    });
  });

  group('ProviderModel Tests', () {
    test('should create a ProviderModel with correct properties', () {
      // Arrange & Act
      const id = '123';
      const name = 'John Doe';
      const service = 'Plumbing';
      const rating = 4.5;
      const reviews = 10;
      const image = 'test_image.jpg';

      final provider = ProviderModel(
        id: id,
        name: name,
        service: service,
        rating: rating,
        reviews: reviews,
        image: image,
      );

      // Assert
      expect(provider.id, id);
      expect(provider.name, name);
      expect(provider.service, service);
      expect(provider.rating, rating);
      expect(provider.reviews, reviews);
      expect(provider.image, image);
    });
  });
}