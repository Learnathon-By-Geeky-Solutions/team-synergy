import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/signin_view.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    // Check if the user is logged in
    if (session != null) {
      return ChangeNotifierProvider(
        create: (_) {
          final viewModel = ProfileViewModel();
          // Load profile data immediately
          viewModel.loadProfile(session.user.id);
          return viewModel;
        },
        child: const HomeScreen(),
      );
    } else {
      return const SignInView();
    }
  }
}
