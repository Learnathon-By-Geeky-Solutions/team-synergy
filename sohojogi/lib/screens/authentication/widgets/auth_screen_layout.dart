import 'package:flutter/material.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_widgets.dart';

class AuthScreenLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? bottomNavigationWidget;
  final int? currentStep;
  final int? totalSteps;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthScreenLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.bottomNavigationWidget,
    this.currentStep,
    this.totalSteps,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              if (showBackButton)
                IconButton(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              const SizedBox(height: 40),
              buildAuthHeader(
                title: title,
                subtitle: subtitle,
                theme: theme,
              ),
              const SizedBox(height: 40),
              ...children,
              const SizedBox(height: 24),
              if (currentStep != null && totalSteps != null)
                buildProgressIndicator(
                  currentStep: currentStep!,
                  totalSteps: totalSteps!,
                  theme: theme,
                ),
              if (bottomNavigationWidget != null)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: bottomNavigationWidget,
                ),
            ],
          ),
        ),
      ),
    );
  }
}