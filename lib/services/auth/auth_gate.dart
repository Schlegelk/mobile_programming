import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/pages/home_page.dart';
import 'package:social_media/services/auth/login_or_register.dart';

/*
AUTH GATE untuk mengecek apakah user sudah login atau tidak
- jika user sudah login maka akan langsung dialihkan ke home page
- jika belum maka user akan dialihkan ke halaman login atau register
*/

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user sudah login
            if (snapshot.hasData) {
              return const HomePage();
            }

            // user belum login
            else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
