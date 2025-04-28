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

  void _handleCurrentLocation(BuildContext context, LocationViewModel viewModel) {
    // Capture navigator before async gap
    final navigator = Navigator.of(context);

    viewModel.useCurrentLocation().then((location) {
      if (location != null && mounted) {
        navigator.pop(location.address);
      }
    });
  }

  void _handleConfirmLocation(BuildContext context, LocationViewModel viewModel, String address) {
    // Capture navigator before potential async operation
    final navigator = Navigator.of(context);

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
        if (mounted) {
          navigator.pop(address);
        }
      });
    } else {
      navigator.pop(address);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocationViewModel>(context);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      appBar: _buildAppBar(context, isDarkMode),
      body: _buildBody(context, viewModel, isDarkMode),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
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
    );
  }

  Widget _buildBody(BuildContext context, LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(context, viewModel, isDarkMode),
            const SizedBox(height: 24),
            _buildLocationSelectors(viewModel, isDarkMode),
            const SizedBox(height: 24),
            _buildSaveLocationSection(viewModel, isDarkMode),
            const SizedBox(height: 32),
            _buildConfirmButton(context, viewModel, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelectors(LocationViewModel viewModel, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCountrySection(viewModel, isDarkMode),
        _buildStateSection(viewModel, isDarkMode),
        _buildCitySection(viewModel, isDarkMode),
        _buildAreaSection(viewModel, isDarkMode),
        _buildStreetSection(viewModel, isDarkMode),
      ],
    );
  }

  Widget _buildCountrySection(LocationViewModel viewModel, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Country', isDarkMode),
        _buildCountryDropdown(viewModel, isDarkMode),
      ],
    );
  }

  Widget _buildStateSection(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.selectedCountry == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSectionTitle('State/Province', isDarkMode),
        _buildStateDropdown(viewModel, isDarkMode),
      ],
    );
  }

  Widget _buildCitySection(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.selectedState == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSectionTitle('City/District', isDarkMode),
        _buildCityDropdown(viewModel, isDarkMode),
      ],
    );
  }

  Widget _buildAreaSection(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.selectedCity == null || viewModel.areas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSectionTitle('Area/Locality', isDarkMode),
        _buildAreaDropdown(viewModel, isDarkMode),
      ],
    );
  }

  Widget _buildStreetSection(LocationViewModel viewModel, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSectionTitle('Street Address', isDarkMode),
        _buildStreetAddressField(viewModel, isDarkMode),
      ],
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
                onPressed: () => _handleCurrentLocation(context, viewModel),
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
          value: viewModel.countries.contains(viewModel.selectedCountry)
              ? viewModel.selectedCountry
              : null, // Ensure the selected value is in the list
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
        )
      ),
    );
  }

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
        _buildSaveLocationCheckbox(),
        if (_isSaving) ...[
          const SizedBox(height: 8),
          _buildLocationNameField(isDarkMode),
          const SizedBox(height: 16),
          _buildIconSelector(isDarkMode),
        ],
      ],
    );
  }

  Widget _buildSaveLocationCheckbox() {
    return Row(
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
    );
  }

  Widget _buildLocationNameField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildIconSelector(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Icon', isDarkMode),
        Wrap(
          spacing: 12,
          children: _buildIconOptions(isDarkMode),
        ),
      ],
    );
  }

  List<Widget> _buildIconOptions(bool isDarkMode) {
    return _iconOptions.entries.map((entry) {
      final bool isSelected = _selectedIconKey == entry.key;
      final Color iconColor = _getIconColor(isSelected, isDarkMode);

      return InkWell(
        onTap: () => _handleIconSelection(entry.key),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: _buildIconDecoration(isSelected),
          child: Icon(
            entry.value,
            color: iconColor,
            size: 24,
          ),
        ),
      );
    }).toList();
  }

  void _handleIconSelection(String key) {
    setState(() {
      _selectedIconKey = key;
    });
  }

  BoxDecoration _buildIconDecoration(bool isSelected) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
      border: Border.all(
        color: isSelected ? primaryColor : Colors.grey[400]!,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  Color _getIconColor(bool isSelected, bool isDarkMode) {
    if (isSelected) {
      return primaryColor;
    }
    return isDarkMode ? lightGrayColor : grayColor;
  }

  Widget _buildConfirmButton(BuildContext context, LocationViewModel viewModel, bool isDarkMode) {
    final bool isFormValid = viewModel.selectedCountry != null &&
        viewModel.selectedState != null;

    final String address = _buildFormattedAddress(viewModel);

    return ElevatedButton(
      onPressed: isFormValid
          ? () => _handleConfirmLocation(context, viewModel, address)
          : null,
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