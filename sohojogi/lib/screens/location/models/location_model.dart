class CountryModel {
  final int id;
  final String name;
  final String? flag;
  final String code;

  CountryModel({
    required this.id,
    required this.name,
    this.flag,
    required this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      name: json['name'],
      flag: json['flag'],
      code: json['code'] ?? '',
    );
  }
}

class StateModel {
  final int id;
  final int countryId;
  final String name;
  final String? code;

  StateModel({
    required this.id,
    required this.countryId,
    required this.name,
    this.code,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      countryId: json['country_id'],
      name: json['name'],
      code: json['code'],
    );
  }
}

class CityModel {
  final int id;
  final int stateId;
  final String name;
  final String? code;

  CityModel({
    required this.id,
    required this.stateId,
    required this.name,
    this.code,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      stateId: json['state_id'],
      name: json['name'],
      code: json['code'],
    );
  }
}

class AreaModel {
  final int id;
  final int cityId;
  final String name;
  final String? postalCode;

  AreaModel({
    required this.id,
    required this.cityId,
    required this.name,
    this.postalCode,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'],
      cityId: json['city_id'],
      name: json['name'],
      postalCode: json['postal_code'],
    );
  }
}

class LocationModel {
  final String address;
  final String subAddress;
  final String? icon;
  final String? name;
  final bool isSaved;
  final double? latitude;
  final double? longitude;
  final String? streetAddress;

  LocationModel({
    required this.address,
    this.subAddress = '',
    this.icon,
    this.name,
    this.isSaved = false,
    this.latitude,
    this.longitude,
    this.streetAddress,
  });

  String get formattedAddress => address;
}

class UserLocationModel {
  final int? id;
  final String? userId;
  final String? name;
  final int countryId;
  final int stateId;
  final int cityId;
  final int? areaId;
  final String? streetAddress;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final bool isSaved;
  final String? icon;
  final String? countryName;
  final String? stateName;
  final String? cityName;
  final String? areaName;
  final DateTime createdAt;

  UserLocationModel({
    this.id,
    this.userId,
    this.name,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    this.areaId,
    this.streetAddress,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.isSaved = false,
    this.icon,
    this.countryName,
    this.stateName,
    this.cityName,
    this.areaName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      countryId: json['country_id'],
      stateId: json['state_id'],
      cityId: json['city_id'],
      areaId: json['area_id'],
      streetAddress: json['street_address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['is_default'] ?? false,
      isSaved: json['is_saved'] ?? false,
      icon: json['icon'],
      countryName: json['countries']['name'],
      stateName: json['states']['name'],
      cityName: json['cities']['name'],
      areaName: json['areas'] != null ? json['areas']['name'] : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedAddress {
    final parts = <String>[];
    if (streetAddress != null && streetAddress!.isNotEmpty) parts.add(streetAddress!);
    if (areaName != null && areaName!.isNotEmpty) parts.add(areaName!);
    if (cityName != null) parts.add(cityName!);
    if (stateName != null) parts.add(stateName!);
    if (countryName != null) parts.add(countryName!);

    return parts.join(', ');
  }
}