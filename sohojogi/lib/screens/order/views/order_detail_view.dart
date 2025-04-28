import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../view_model/order_view_model.dart';
import '../../../constants/colors.dart';
import 'order_list_view.dart';

class OrderDetailView extends StatefulWidget {
  final OrderModel order;
  static const String cancelOrder = "Cancel Order";

  const OrderDetailView({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  bool isLoading = false;
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5.0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final viewModel = Provider.of<OrderViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order details card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        widget.order.description,
                        maxLines: null,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Status', widget.order.statusText, widget.order.getStatusColor(isDarkMode)),
                    _buildInfoRow('Date', _formatDate(widget.order.createdAt), null),
                    _buildInfoRow('Service', widget.order.serviceType, null),
                    _buildInfoRow('Price', '৳${widget.order.price.toStringAsFixed(0)}', null),
                    _buildInfoRow('Location', widget.order.location, null),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons based on order status
            if (widget.order.status == OrderStatus.pending || widget.order.status == OrderStatus.confirmed)
              _buildActionButton(
                'Cancel Order',
                Icons.cancel,
                Colors.red,
                    () => _showCancelOrderDialog(context, viewModel),
              ),

            if (widget.order.status == OrderStatus.completed)
              _buildActionButton(
                'View Receipt',
                Icons.receipt_long,
                primaryColor,
                    () => _showReceipt(context),
              ),

            if (widget.order.status == OrderStatus.toReview)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave a review',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Rating: '),
                      ...List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Review text field
                  TextField(
                    controller: _reviewController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience with this service...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _submitReview(context, viewModel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Submit Review'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 1, // Limit to one line
              textAlign: TextAlign.right, // Align text to the right
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context, OrderViewModel viewModel) {
    final TextEditingController reasonController = TextEditingController();
    // Store references before async gap
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(OrderDetailView.cancelOrder),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for cancellation:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Reason for cancellation',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Please provide a reason')),
                );
                return;
              }

              navigator.pop(); // Close dialog
              setState(() {
                isLoading = true;
              });

              final success = await viewModel.cancelOrder(
                widget.order.id,
                reasonController.text.trim(),
              );

              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

              if (success) {
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const OrderListView()),
                      (route) => false,
                );
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Order cancelled successfully')),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Failed to cancel order')),
                );
              }
            },
            child: const Text(OrderDetailView.cancelOrder, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview(BuildContext context, OrderViewModel viewModel) async {
    // Store references before async gap
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_reviewController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please enter a review')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final success = await viewModel.submitReview(
      widget.order.id,
      _rating,
      _reviewController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      navigator.pop();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to submit review'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showReceipt(BuildContext context) {
    // Implement receipt view
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}