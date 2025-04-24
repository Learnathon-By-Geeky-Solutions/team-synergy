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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Database Management',
          style: TextStyle(
            color: isDarkMode ? lightColor : darkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? darkColor : lightColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: isDarkMode ? darkColor : lightColor,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location Database',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? lightColor : darkColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Populate location data for Pakistan, UAE, Saudi Arabia, India, and Bangladesh.',
                      style: TextStyle(
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _seederService.isSeeding,
                      builder: (context, isSeeding, _) {
                        return ValueListenableBuilder<String>(
                          valueListenable: _seederService.progressNotifier,
                          builder: (context, progressText, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: isSeeding
                                      ? null
                                      : () => _seederService.seedLocationData(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 48),
                                  ),
                                  child: Text(isSeeding
                                      ? 'Populating Database...'
                                      : 'Populate Location Database'),
                                ),
                                if (progressText.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    progressText,
                                    style: TextStyle(
                                      color: isDarkMode ? lightColor : darkColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ValueListenableBuilder<double>(
                                    valueListenable: _seederService.progressValue,
                                    builder: (context, progress, _) {
                                      return LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: isDarkMode
                                            ? grayColor
                                            : Colors.grey[200],
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          primaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}