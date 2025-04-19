import 'package:flutter/cupertino.dart';

class LocationModel {
  final String address;
  final String subAddress;
  final IconData? icon;
  final String? name;
  final bool isSaved;

  LocationModel({
    required this.address,
    this.subAddress = '',
    this.icon,
    this.name,
    this.isSaved = false,
  });
}