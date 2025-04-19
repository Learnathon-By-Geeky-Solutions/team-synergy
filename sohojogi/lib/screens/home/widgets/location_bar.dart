import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/location/views/location_list_view.dart';
import 'package:sohojogi/screens/location/view_model/location_view_model.dart';

class LocationBar extends StatelessWidget {
  final String currentLocation;
  final Function(String) onLocationChanged;

  const LocationBar({
    super.key,
    required this.currentLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        final selectedLocation = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => LocationViewModel(),
              child: const LocationListView(),
            ),
          ),
        );

        if (selectedLocation != null) {
          onLocationChanged(selectedLocation);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        color: isDarkMode ? darkColor : lightColor,
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.redAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                currentLocation,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}