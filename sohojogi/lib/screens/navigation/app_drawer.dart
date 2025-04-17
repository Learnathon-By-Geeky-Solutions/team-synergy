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
            _buildSection(context, 'Account', [
              'Business Profile',
              'Payment Methods',
              'Saved Address',
              'Bookmark',
              'Membership',
            ], isDarkMode),
            Divider(color: isDarkMode ? lightColor : lightGrayColor),
            _buildSection(context, 'Offers', [
              'Offers & Promos',
              'Refer & Discount',
            ], isDarkMode),
            Divider(color: isDarkMode ? lightColor : lightGrayColor),
            _buildSection(context, 'Settings', [
              'Theme',
              'Language',
              'Account Security',
              'Terms & Privacy',
              'Permissions',
            ], isDarkMode),
            Divider(color: isDarkMode ? lightColor : lightGrayColor),
            _buildSection(context, 'More', [
              'Help Center',
              'Log Out',
            ], isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items, bool isDarkMode) {
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
        ...items.map((item) => ListTile(
          title: Text(item, style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            // Handle menu item tap
          },
        )),
      ],
    );
  }
}