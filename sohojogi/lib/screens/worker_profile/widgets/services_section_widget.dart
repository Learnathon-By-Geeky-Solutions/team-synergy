import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class ServicesSectionWidget extends StatelessWidget {
  final List<WorkerServiceModel> services;
  final List<WorkerServiceModel> selectedServices;
  final Function(WorkerServiceModel, bool) onServiceSelected;

  const ServicesSectionWidget({
    super.key,
    required this.services,
    required this.selectedServices,
    required this.onServiceSelected,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDarkMode),
          const SizedBox(height: 16),
          _buildServicesList(isDarkMode),
          if (selectedServices.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildTotalPrice(isDarkMode),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Services Offered',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            if (selectedServices.isNotEmpty)
              Text(
                '${selectedServices.length} selected',
                style: const TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Select services you want to hire',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
      ],
    );
  }

  Color _getServiceCardColor(bool isSelected, bool isDarkMode) {
    if (isSelected) {
      return primaryColor.withValues(alpha: 0.1);
    }
    return isDarkMode ? Colors.black12 : Colors.grey.shade100;
  }

  Widget _buildServicesList(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) => _buildServiceCard(services[index], isDarkMode),
    );
  }

  Widget _buildServiceCard(WorkerServiceModel service, bool isDarkMode) {
    final isSelected = selectedServices.any((s) => s.id == service.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: _getServiceCardColor(isSelected, isDarkMode),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: _buildServiceTile(service, isSelected, isDarkMode),
    );
  }

  Widget _buildServiceTile(WorkerServiceModel service, bool isSelected, bool isDarkMode) {
    return CheckboxListTile(
      value: isSelected,
      onChanged: (value) => onServiceSelected(service, value ?? false),
      activeColor: primaryColor,
      title: Text(
        service.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? lightColor : darkColor,
        ),
      ),
      subtitle: _buildServiceDetails(service, isDarkMode),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildServiceDetails(WorkerServiceModel service, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (service.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              service.description,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
            ),
          ),
        Text(
          '৳${service.price.toStringAsFixed(0)} per ${service.unit}',
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPrice(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Price:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
          Text(
            '৳${_calculateTotalPrice()}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTotalPrice() {
    return selectedServices
        .fold(0.0, (sum, item) => sum + item.price)
        .toStringAsFixed(0);
  }
}