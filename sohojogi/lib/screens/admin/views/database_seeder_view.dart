// lib/screens/admin/views/database_seeder_view.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/database_seeder_service.dart';
import 'package:sohojogi/constants/colors.dart';

class DatabaseSeederView extends StatefulWidget {
  const DatabaseSeederView({super.key});

  @override
  State<DatabaseSeederView> createState() => _DatabaseSeederViewState();
}

class _DatabaseSeederViewState extends State<DatabaseSeederView> {
  final DatabaseSeederService _seederService = DatabaseSeederService();
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _seedDatabase() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Seeding database...';
    });

    try {
      await _seederService.seedDatabase();
      setState(() {
        _statusMessage = 'Database seeded successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
        title: const Text('Database Seeder'),
    ),
    body: Center(
    child: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.storage,
    size: 80,
    color: primaryColor,
    ),
    const SizedBox(height: 24),
    Text(
    'Worker Database Seeder',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: isDarkMode ? lightColor : darkColor,
    ),
    ),
    const SizedBox(height: 16),
    Text(
    'This will generate 60 workers with services, skills, availability, and reviews across all locations.',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 16,
    color: isDarkMode ? lightGrayColor : grayColor,
    ),
    ),
    const SizedBox(height: 32),
    ElevatedButton(
    onPressed: _isLoading ? null : _seedDatabase,
    style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: _isLoading
    ? const SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(
    color: Colors.white,
    strokeWidth: 2,
    ),
    )
        : const Text(
    'Seed Database',
    style: TextStyle(fontSize: 16, color: Colors.white),
    ),
    ),
    const SizedBox(height: 24),
    if (_statusMessage.isNotEmpty)
    Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: _statusMessage.contains('Error')
    ? Colors.red.withOpacity(0.1)
        : Colors.green.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
    color: _statusMessage.contains('Error')
    ? Colors.red.withOpacity(0.3)
        : Colors.green.withOpacity(0.3),
    ),
    ),
    child: Text(
    _statusMessage,
    style: TextStyle(
    fontSize: 16,
    color: _statusMessage.contains('Error')
    ? Colors.red
        : Colors.green,
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}