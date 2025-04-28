import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../base/services/location_service.dart';
import '../../../constants/colors.dart';
import '../models/location_model.dart';

class MapLocationSelector extends StatefulWidget {
  const MapLocationSelector({super.key});

  @override
  State<MapLocationSelector> createState() => _MapLocationSelectorState();
}

class _MapLocationSelectorState extends State<MapLocationSelector> {
  final LocationService _locationService = LocationService();

  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(24.774265, 46.738586); // Default to central location
  LocationModel? _currentAddress;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _getAddressFromLatLng(_selectedLocation);

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLocation, 15),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not determine your location: $e';
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude
      );

      setState(() {
        _currentAddress = address;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not determine address: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    Widget _buildLocationStatusWidget(bool isDarkMode) {
      if (_isLoading) {
        return const LinearProgressIndicator();
      }

      if (_errorMessage != null) {
        return Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        );
      }

      return Text(
        _currentAddress?.address ?? 'Address not found',
        style: TextStyle(
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Location on Map',
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
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              setState(() {
                _selectedLocation = position.target;
              });
            },
            onCameraIdle: () {
              _getAddressFromLatLng(_selectedLocation);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),

          // Center marker
          const Center(
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),

          // Address panel at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? darkColor : lightColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Selected Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildLocationStatusWidget(isDarkMode),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.my_location, size: 18),
                          label: const Text('Current Location'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: const BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentAddress != null
                              ? () => Navigator.pop(context, _currentAddress)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Select Location'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}