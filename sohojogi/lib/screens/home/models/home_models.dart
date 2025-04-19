import 'package:flutter/material.dart';

class BannerModel {
  final String title;
  final Color color;

  BannerModel({required this.title, required this.color});
}

class ServiceModel {
  final String name;
  final IconData icon;

  ServiceModel({required this.name, required this.icon});
}

class ProviderModel {
  final String id;
  final String name;
  final String service;
  final double rating;
  final int reviews;
  final String image;

  ProviderModel({
    required this.name,
    required this.service,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.id,
  });
}