import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/business_profile/views/business_profile_list_view.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';
import 'package:sohojogi/screens/profile/views/profile_edit_view.dart';
import 'package:sohojogi/screens/profile/views/profile_list_view.dart';
import '../business_profile/view_model/worker_registration_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/signin_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Create a local provider if none is found above
    return Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, _) {
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
                      child: InkWell(
                        onTap: () => _navigateToProfile(context),
                        child: Row(
                          children: [
                            _buildProfileAvatar(profileViewModel, isDarkMode),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileViewModel.profileData.fullName.isEmpty
                                        ? 'Set up profile'
                                        : profileViewModel.profileData.fullName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? lightColor : darkColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '135 Credits',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDarkMode ? lightColor : lightGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, 
                                    color: isDarkMode ? lightColor : lightGrayColor,
                                    size: 20,
                                  ),
                                  Text(
                                    'Expire in 21d',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: isDarkMode ? lightColor : lightGrayColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildSection(context, 'Account', [
                      'Profile',
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
    );
  }

  Widget _buildProfileAvatar(ProfileViewModel viewModel, bool isDarkMode) {
    // If user has set a new profile image
    if (viewModel.newProfileImage != null) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: FileImage(viewModel.newProfileImage!),
      );
    }
    // If user has an existing profile photo URL
    else if (viewModel.profileData.profilePhotoUrl != null &&
        viewModel.profileData.profilePhotoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(viewModel.profileData.profilePhotoUrl!),
      );
    }
    // Default placeholder avatar
    else {
      return CircleAvatar(
        radius: 30,
        backgroundColor: isDarkMode ? lightGrayColor : grayColor.withValues(alpha: 0.3),
        child: Icon(
          Icons.person,
          size: 30,
          color: isDarkMode ? darkColor : lightColor,
        ),
      );
    }
  }

  void _navigateToProfile(BuildContext context) {
    // Close the drawer first
    Navigator.pop(context);

    // Navigate to profile edit page without creating a new ViewModel instance
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileListView(
          onBackPressed: () => Navigator.pop(context),
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
          title: Text(item, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDarkMode ? lightColor : darkColor,
          )),
          onTap: () => _handleNavigation(context, item),
        )),
      ],
    );
  }

  static const String paymentMethods = "Payment Methods";
  static const String savedAddress = "Saved Address";
  static const String accountSecurity = "Account Security";
  static const String helpCenter = "Help Center";
  static const String logOut = "Log Out";

  void _handleNavigation(BuildContext context, String item) {
    // Close drawer first
    Navigator.pop(context);

    // Map item to actions
    final navigationActions = {
      'Profile': () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => ProfileViewModel(),
                child: ProfileListView(
                  onBackPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
      'Business Profile': () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => WorkerRegistrationViewModel(),
                child: BusinessProfileListView(
                  onBackPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
      paymentMethods: () => _showComingSoonSnackBar(context, paymentMethods),
      savedAddress: () => _showComingSoonSnackBar(context, savedAddress),
      'Bookmark': () => _showComingSoonSnackBar(context, 'Bookmarks'),
      'Membership': () => _showComingSoonSnackBar(context, 'Membership Plans'),
      'Offers & Promos': () => _showComingSoonSnackBar(context, 'Offers & Promotions'),
      'Refer & Discount': () => _showComingSoonSnackBar(context, 'Referral Program'),
      'Theme': () => _showThemeSelectionDialog(context),
      'Language': () => _showLanguageSelectionDialog(context),
      accountSecurity: () => _showComingSoonSnackBar(context, accountSecurity),
      'Terms & Privacy': () => _showComingSoonSnackBar(context, 'Terms and Privacy Policy'),
      'Permissions': () => _showComingSoonSnackBar(context, 'App Permissions'),
      helpCenter: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HelpCenterScreen(),
            ),
          ),
      logOut: () => _showLogoutConfirmationDialog(context),
    };

    // Execute the corresponding action if it exists
    navigationActions[item]?.call();
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Light'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Light theme selected')),
                );
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dark theme selected')),
                );
              },
            ),
            ListTile(
              title: const Text('System Default'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('System default theme selected')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('English language selected')),
                );
              },
            ),
            ListTile(
              title: const Text('Arabic'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Arabic language selected')),
                );
              },
            ),
            ListTile(
              title: const Text('Bengali'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bengali language selected')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Perform logout logic
              await Supabase.instance.client.auth.signOut();

              // Show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );

              // Navigate to the SignInView
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInView()),
                    (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

}

// Simple Help Center screen
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: isDarkMode ? darkColor : lightColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpItem(
            context,
            'FAQs',
            'Get answers to common questions',
            Icons.help_outline,
            isDarkMode,
          ),
          _buildHelpItem(
            context,
            'Contact Support',
            'Reach out to our support team',
            Icons.support_agent,
            isDarkMode,
          ),
          _buildHelpItem(
            context,
            'Report an Issue',
            'Let us know about any problems',
            Icons.bug_report,
            isDarkMode,
          ),
          _buildHelpItem(
            context,
            'Request a Feature',
            'Suggest improvements to our app',
            Icons.lightbulb_outline,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      bool isDarkMode,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDarkMode ? darkColor.withValues(alpha: 0.8) : lightColor,
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title page coming soon')),
          );
        },
      ),
    );
  }
}

