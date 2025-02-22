import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sohojogi/ui/login_signup/startup_page.dart';
import 'package:sohojogi/ui/root_page.dart';


class auth_check extends StatelessWidget {
  const auth_check({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return RootPage();
            }
            else{
              return startup_page();
            }
          }
      ),
    );
  }
}
