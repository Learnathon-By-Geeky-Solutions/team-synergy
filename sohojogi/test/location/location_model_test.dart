import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/location/models/location_model.dart';

void main() {
  group('LocationModel Tests', () {
    test('creates LocationModel with required parameters', () {
      final location = LocationModel(address: '123 Test St');

      expect(location.address, '123 Test St');
      expect(location.subAddress, '');
      expect(location.icon, null);
      expect(location.name, null);
      expect(location.isSaved, false);
      expect(location.latitude, null);
      expect(location.longitude, null);
      expect(location.streetAddress, null);
    });

    test('creates LocationModel with all parameters', () {
      final location = LocationModel(
        address: '123 Test St',
        subAddress: 'Apt 4B',
        icon: 'home',
        name: 'Home',
        isSaved: true,
        latitude: 23.8103,
        longitude: 90.4125,
        streetAddress: '123 Test St, Apt 4B',
      );

      expect(location.address, '123 Test St');
      expect(location.subAddress, 'Apt 4B');
      expect(location.icon, 'home');
      expect(location.name, 'Home');
      expect(location.isSaved, true);
      expect(location.latitude, 23.8103);
      expect(location.longitude, 90.4125);
      expect(location.streetAddress, '123 Test St, Apt 4B');
    });

    test('formattedAddress returns correct address', () {
      final location = LocationModel(
        address: '123 Test St, City, Country',
        subAddress: 'Apt 4B',
      );

      expect(location.formattedAddress, '123 Test St, City, Country');
    });
  });

  group('UserLocationModel Tests', () {
    test('creates UserLocationModel from JSON', () {
      final json = {
        'id': 1,
        'user_id': 'user123',
        'name': 'Home',
        'country_id': 1,
        'state_id': 2,
        'city_id': 3,
        'area_id': 4,
        'street_address': '123 Test St',
        'latitude': 23.8103,
        'longitude': 90.4125,
        'is_default': true,
        'is_saved': true,
        'icon': 'home',
        'countries': {'name': 'Bangladesh'},
        'states': {'name': 'Dhaka'},
        'cities': {'name': 'Dhaka City'},
        'areas': {'name': 'Gulshan'},
        'created_at': '2024-03-20T12:00:00Z',
      };

      final location = UserLocationModel.fromJson(json);

      expect(location.id, 1);
      expect(location.userId, 'user123');
      expect(location.name, 'Home');
      expect(location.countryId, 1);
      expect(location.stateId, 2);
      expect(location.cityId, 3);
      expect(location.areaId, 4);
      expect(location.streetAddress, '123 Test St');
      expect(location.latitude, 23.8103);
      expect(location.longitude, 90.4125);
      expect(location.isDefault, true);
      expect(location.isSaved, true);
      expect(location.icon, 'home');
      expect(location.countryName, 'Bangladesh');
      expect(location.stateName, 'Dhaka');
      expect(location.cityName, 'Dhaka City');
      expect(location.areaName, 'Gulshan');
    });

    test('formattedAddress combines address components correctly', () {
      final location = UserLocationModel(
        streetAddress: '123 Test St',
        countryId: 1,
        stateId: 1,
        cityId: 1,
        countryName: 'Bangladesh',
        stateName: 'Dhaka',
        cityName: 'Dhaka City',
        areaName: 'Gulshan',
      );

      expect(location.formattedAddress,
          '123 Test St, Gulshan, Dhaka City, Dhaka, Bangladesh');
    });

    test('formattedAddress handles missing components', () {
      final location = UserLocationModel(
        countryId: 1,
        stateId: 1,
        cityId: 1,
        cityName: 'Dhaka City',
        stateName: 'Dhaka',
      );

      expect(location.formattedAddress, 'Dhaka City, Dhaka');
    });
  });
}