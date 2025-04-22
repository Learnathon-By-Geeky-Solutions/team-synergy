import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';
import '../../utils/date_time_utils.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTap,
  });

  String _formatTimeAgo(DateTime dateTime) {
    // Don't cast the Duration to DateTime - just pass the original dateTime
    return formatTimeAgo(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color statusColor = order.getStatusColor(isDarkMode);

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
              Row(
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? lightGrayColor : grayColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: order.status == OrderStatus.pending ?
                      Colors.transparent : statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      order.statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Order details
              Row(
                children: [
                  // Service type
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

                  // Price
                  Text(
                    '৳${order.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Bottom details
              Row(
                children: [
                  // Location
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

                  // Time ago
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
              ),

              // Review button for toReview status
              if (order.status == OrderStatus.toReview) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: isDarkMode ? darkColor : lightColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Leave Review'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}