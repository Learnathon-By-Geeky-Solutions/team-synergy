import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:intl/intl.dart';

class PortfolioSectionWidget extends StatelessWidget {
  final List<WorkerPortfolioItem> portfolioItems;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const PortfolioSectionWidget({
    super.key,
    required this.portfolioItems,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (portfolioItems.isEmpty) {
      return _buildEmptyState(isDarkMode);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? darkColor : lightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDarkMode),
          const SizedBox(height: 16),
          if (_hasValidSelectedIndex()) ...[
            _buildSelectedItemPreview(isDarkMode),
            const SizedBox(height: 16),
          ],
          _buildThumbnailGrid(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? darkColor : lightColor,
      child: Center(
        child: Text(
          'No portfolio items available',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Text(
      'Portfolio',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? lightColor : darkColor,
      ),
    );
  }

  bool _hasValidSelectedIndex() {
    return selectedIndex >= 0 && selectedIndex < portfolioItems.length;
  }

  Widget _buildSelectedItemPreview(bool isDarkMode) {
    final item = portfolioItems[selectedIndex];
    final dateFormat = DateFormat('MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPreviewImage(item.imageUrl),
        const SizedBox(height: 8),
        _buildPreviewDetails(item, dateFormat, isDarkMode),
      ],
    );
  }

  Widget _buildPreviewImage(String imageUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewDetails(WorkerPortfolioItem item, DateFormat dateFormat, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateFormat.format(item.date),
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.description,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? lightColor.withValues(alpha: 0.9) : darkColor.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailGrid(bool isDarkMode) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: portfolioItems.length,
      itemBuilder: (context, index) => _buildThumbnailItem(index),
    );
  }

  Widget _buildThumbnailItem(int index) {
    final item = portfolioItems[index];
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: primaryColor, width: 2) : null,
          image: DecorationImage(
            image: NetworkImage(item.imageUrl),
            fit: BoxFit.cover,
            colorFilter: isSelected ? null : ColorFilter.mode(
              Colors.black.withValues(alpha: 0.2),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }
}