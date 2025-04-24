import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/location_view_model.dart';
import '../models/location_model.dart';
import '../../../constants/colors.dart';

class LocationSelectorView extends StatefulWidget {
  const LocationSelectorView({super.key});

  @override
  State<LocationSelectorView> createState() => _LocationSelectorViewState();
}

class _LocationSelectorViewState extends State<LocationSelectorView> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  String? _selectedIconKey;

  final Map<String, IconData> _iconOptions = {
    'home': Icons.home,
    'work': Icons.work,
    'favorite': Icons.favorite,
    'store': Icons.store,
    'location': Icons.location_on,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationViewModel>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _streetController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocationViewModel>(context);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Select Location',
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
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick actions
              _buildQuickActions(context, viewModel, isDarkMode),

              const SizedBox(height: 24),

              // Country selection
              _buildSectionTitle('Country', isDarkMode),
              _buildCountryDropdown(viewModel, isDarkMode),

              const SizedBox(height: 16),

              // State selection (only if country is selected)
              if (viewModel.selectedCountry != null) ...[
                _buildSectionTitle('State/Province', isDarkMode),
                _buildStateDropdown(viewModel, isDarkMode),

                const SizedBox(height: 16),
              ],

              // City selection (only if state is selected)
              if (viewModel.selectedState != null) ...[
                _buildSectionTitle('City/District', isDarkMode),
                _buildCityDropdown(viewModel, isDarkMode),

                const SizedBox(height: 16),
              ],

              // Area selection (only if city is selected)
              if (viewModel.selectedCity != null && viewModel.areas.isNotEmpty) ...[
                _buildSectionTitle('Area/Locality', isDarkMode),
                _buildAreaDropdown(viewModel, isDarkMode),

                const SizedBox(height: 16),
              ],

              // Street address
              _buildSectionTitle('Street Address', isDarkMode),
              _buildStreetAddressField(viewModel, isDarkMode),

              const SizedBox(height: 24),

              // Save location option
              _buildSaveLocationSection(viewModel, isDarkMode),

              const SizedBox(height: 32),

              // Confirm button
              _buildConfirmButton(viewModel, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, LocationViewModel viewModel, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick Options', isDarkMode),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final location = await viewModel.useCurrentLocation();
                  if (location != null) {
                    Navigator.pop(context, location.address);
                  }
                },
                icon: const Icon(Icons.my_location, size: 18),
                label: const Text('Use Current Location'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? lightColor : darkColor,
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(LocationViewModel viewModel, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : lightColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? grayColor : Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CountryModel>(
          isExpanded: true,
          value: viewModel.selectedCountry,
          hint: Text(
            'Select Country',
            style: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: isDarkMode ? lightColor : darkColor, fontSize: 16),
          onChanged: (CountryModel? newValue) {
            if (newValue != null) {
              viewModel.selectCountry(newValue);
            }
          },
          items: viewModel.countries.map<DropdownMenuItem<CountryModel>>((CountryModel country) {
            return DropdownMenuItem<CountryModel>(
              value: country,
              child: Row(
                children: [
                  if (country.flag != null) ...[
                    Text(country.flag!, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                  ],
                  Text(country.name),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

// Completing the _buildStateDropdown() function and adding remaining widgets
  Widget _buildStateDropdown(LocationViewModel viewModel, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : lightColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? grayColor : Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<StateModel>(
          isExpanded: true,
          value: viewModel.selectedState,
          hint: Text(
            'Select State/Province',
            style: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: isDarkMode ? lightColor : darkColor, fontSize: 16),
          onChanged: (StateModel? newValue) {
            if (newValue != null) {
              viewModel.selectState(newValue);
            }
          },
          items: viewModel.states.map<DropdownMenuItem<StateModel>>((StateModel state) {
            return DropdownMenuItem<StateModel>(
              value: state,
              child: Text(state.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCityDropdown(LocationViewModel viewModel, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : lightColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? grayColor : Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CityModel>(
          isExpanded: true,
          value: viewModel.selectedCity,
          hint: Text(
            'Select City/District',
            style: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: isDarkMode ? lightColor : darkColor, fontSize: 16),
          onChanged: (CityModel? newValue) {
            if (newValue != null) {
              viewModel.selectCity(newValue);
            }
          },
          items: viewModel.cities.map<DropdownMenuItem<CityModel>>((CityModel city) {
            return DropdownMenuItem<CityModel>(
              value: city,
              child: Text(city.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAreaDropdown(LocationViewModel viewModel, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : lightColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? grayColor : Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AreaModel>(
          isExpanded: true,
          value: viewModel.selectedArea,
          hint: Text(
            'Select Area/Locality',
            style: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: isDarkMode ? lightColor : darkColor, fontSize: 16),
          onChanged: (AreaModel? newValue) {
            if (newValue != null) {
              viewModel.selectArea(newValue);
            }
          },
          items: viewModel.areas.map<DropdownMenuItem<AreaModel>>((AreaModel area) {
            return DropdownMenuItem<AreaModel>(
              value: area,
              child: Text(area.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStreetAddressField(LocationViewModel viewModel, bool isDarkMode) {
    return TextField(
      controller: _streetController,
      onChanged: viewModel.setStreetAddress,
      decoration: InputDecoration(
        hintText: 'Enter street address, house no., landmark, etc.',
        hintStyle: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
        filled: true,
        fillColor: isDarkMode ? darkColor : lightColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDarkMode ? grayColor : Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: TextStyle(color: isDarkMode ? lightColor : darkColor),
    );
  }

  Widget _buildSaveLocationSection(LocationViewModel viewModel, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isSaving,
              onChanged: (value) {
                setState(() {
                  _isSaving = value ?? false;
                });
              },
              activeColor: primaryColor,
            ),
            const Text('Save this location'),
          ],
        ),
        if (_isSaving) ...[
          const SizedBox(height: 8),
          _buildSectionTitle('Location Name', isDarkMode),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'e.g. Home, Work, etc.',
              hintStyle: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
              filled: true,
              fillColor: isDarkMode ? darkColor : lightColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDarkMode ? grayColor : Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: TextStyle(color: isDarkMode ? lightColor : darkColor),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Icon', isDarkMode),
          Wrap(
            spacing: 12,
            children: _iconOptions.entries.map((entry) {
              final isSelected = _selectedIconKey == entry.key;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedIconKey = entry.key;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey[400]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Icon(
                    entry.value,
                    color: isSelected ? primaryColor : (isDarkMode ? lightGrayColor : grayColor),
                    size: 24,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmButton(LocationViewModel viewModel, bool isDarkMode) {
    final bool isFormValid = viewModel.selectedCountry != null &&
        viewModel.selectedState != null &&
        viewModel.selectedCity != null;

    final String address = _buildFormattedAddress(viewModel);

    return ElevatedButton(
      onPressed: isFormValid ? () {
        if (_isSaving) {
          if (_nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a name for this location')),
            );
            return;
          }

          final location = LocationModel(
            address: address,
            name: _nameController.text,
            icon: _selectedIconKey,
            isSaved: true,
          );

          viewModel.saveLocation(location).then((_) {
            Navigator.pop(context, address);
          });
        } else {
          Navigator.pop(context, address);
        }
      } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[400],
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Confirm Location'),
    );
  }

  String _buildFormattedAddress(LocationViewModel viewModel) {
    final parts = <String>[];

    if (_streetController.text.isNotEmpty) parts.add(_streetController.text);
    if (viewModel.selectedArea != null) parts.add(viewModel.selectedArea!.name);
    if (viewModel.selectedCity != null) parts.add(viewModel.selectedCity!.name);
    if (viewModel.selectedState != null) parts.add(viewModel.selectedState!.name);
    if (viewModel.selectedCountry != null) parts.add(viewModel.selectedCountry!.name);

    return parts.join(', ');
  }
}