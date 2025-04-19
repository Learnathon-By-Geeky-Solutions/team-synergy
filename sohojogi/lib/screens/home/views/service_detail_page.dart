import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  final String service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service)),
      body: Center(child: Text('$service service details')),
    );
  }
}