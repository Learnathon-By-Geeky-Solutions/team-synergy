import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/signin_view.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    // Check if the user is logged in
    if (session != null) {
      return const HomeScreen(); // Redirect to home if logged in
    } else {
      return const SignInView(); // Redirect to sign-in if not logged in
    }
  }
}