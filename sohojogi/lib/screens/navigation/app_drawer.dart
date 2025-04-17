import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: isDarkMode ? darkColor : lightColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user_image.png'), // Replace with actual user image
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                      ),
                      Text(
                        '135 Credits',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode ? lightColor : lightGrayColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: isDarkMode ? lightColor : lightGrayColor),
                      Text(
                        'Expire in 21 days',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDarkMode ? lightColor : lightGrayColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildTitleSection(context, 'Account', [
              _buildMenuItem(context, 'Business Profile'),
              _buildMenuItem(context, 'Payment Methods'),
              _buildMenuItem(context, 'Saved Address'),
              _buildMenuItem(context, 'Bookmark'),
              _buildMenuItem(context, 'Membership'),
            ], isDarkMode),
            Divider(color: isDarkMode ? lightColor : lightGrayColor),
            _buildTitleSection(context, 'Offers', [
              _buildMenuItem(context, 'Offers & Promos'),
              _buildMenuItem(context, 'Refer & Discount'),
            ], isDarkMode),
            Divider(color: isDarkMode ? lightColor : lightGrayColor),
            _buildTitleSection(context, 'Settings', [
              _buildMenuItem(context, 'Theme'),
              _buildMenuItem(context, 'Language'),
              _buildMenuItem(context, 'Account Security'),
              _buildMenuItem(context, 'Terms & Privacy'),
              _buildMenuItem(context, 'Permissions'),
            ], isDarkMode),
            Divider(color: isDarkMode ? lightColor : lightGrayColor),
            _buildTitleSection(context, 'More', [
              _buildMenuItem(context, 'Help Center'),
              _buildMenuItem(context, 'Log Out'),
            ], isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, String title, List<Widget> items, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDarkMode ? lightColor : lightGrayColor,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      onTap: () {
        // Handle menu item tap
      },
    );
  }
}