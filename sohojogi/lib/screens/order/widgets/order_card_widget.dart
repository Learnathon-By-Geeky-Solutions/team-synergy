import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';
import '../../utils/date_time_utils.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onMarkForReviewPressed;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTap,
    this.onCancelPressed,
    this.onMarkForReviewPressed,
  });

  String _formatTimeAgo(DateTime dateTime) {
    return formatTimeAgo(dateTime);
  }

  @override
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? darkColor : lightColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(isDarkMode),
              const SizedBox(height: 16),
              _buildOrderDetails(isDarkMode),
              const SizedBox(height: 12),
              _buildBottomDetails(isDarkMode),
              if (order.status != OrderStatus.pending) ...[
                const SizedBox(height: 16),
                _buildActionButton(order, isDarkMode) ?? const SizedBox.shrink(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 4),
              Text(
                order.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
                maxLines: null,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildStatusBadge(order, order.getStatusColor(isDarkMode)),
      ],
    );
  }

  Widget _buildOrderDetails(bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            order.serviceType,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '৳${order.price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomDetails(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 14,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            order.location,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.access_time,
          size: 14,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimeAgo(order.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
      ],
    );
  }

  Widget? _buildActionButton(OrderModel order, bool isDarkMode) {
    if (order.status == OrderStatus.pending && onCancelPressed != null) {
      return _buildFullWidthButton(
        onPressed: onCancelPressed!,
        label: 'Cancel',
        backgroundColor: Colors.redAccent,
      );
    }

    if (order.status == OrderStatus.completed && onMarkForReviewPressed != null) {
      return _buildFullWidthButton(
        onPressed: onMarkForReviewPressed!,
        label: 'Leave Review',
        backgroundColor: primaryColor,
      );
    }

    if (order.status == OrderStatus.toReview) {
      return _buildFullWidthButton(
        onPressed: onTap,
        label: 'Leave Review',
        backgroundColor: primaryColor,
        foregroundColor: isDarkMode ? darkColor : lightColor,
      );
    }

    return null;
  }

  Widget _buildFullWidthButton({
    required VoidCallback onPressed,
    required String label,
    required Color backgroundColor,
    Color? foregroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildStatusBadge(OrderModel order, Color statusColor) {
    if (order.status == OrderStatus.pending) {
      return Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor, width: 1),
        ),
        child: Text(
          order.statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        order.statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}