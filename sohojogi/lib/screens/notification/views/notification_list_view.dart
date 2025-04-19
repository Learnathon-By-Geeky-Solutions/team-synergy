import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/notification/widgets/notification_card_widget.dart';
import '../view_model/notification_view_model.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({super.key});

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationViewModel>(context, listen: false).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : lightColor,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, viewModel, isDarkMode),
      bottomNavigationBar: const AppNavBar(),
    );
  }

  Widget _buildBody(BuildContext context, NotificationViewModel viewModel, bool isDarkMode) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                viewModel.errorMessage,
                style: TextStyle(
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: viewModel.loadNotifications,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'You\'ll be notified about your orders and announcements',
                style: TextStyle(
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadNotifications,
      color: primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: viewModel.notifications.length,
        itemBuilder: (context, index) {
          return NotificationCardWidget(
            notification: viewModel.notifications[index],
            onTap: () => viewModel.markAsRead(viewModel.notifications[index]),
          );
        },
      ),
    );
  }
}