import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/notification/views/notification_list_view.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showBackButton;
  final String? userProfileImageUrl;
  final VoidCallback? onProfileTap;

  const AppAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showBackButton = false,
    this.userProfileImageUrl,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: isDarkMode ? darkColor : lightColor,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? lightColor : darkColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? lightColor : darkColor,
        ),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      actions: [
        // Notification button
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationListView(),
              ),
            );
          },
        ),

        // Profile image
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor.withOpacity(0.2),
              backgroundImage: userProfileImageUrl != null
                  ? NetworkImage(userProfileImageUrl!)
                  : null,
              child: userProfileImageUrl == null
                  ? Icon(
                Icons.person,
                size: 18,
                color: isDarkMode ? lightColor : darkColor,
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}