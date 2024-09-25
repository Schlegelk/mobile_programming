import 'package:flutter/material.dart';
import 'package:social_media/components/my_button.dart';
import 'package:social_media/components/my_text_field.dart';
import 'package:social_media/main.dart';

/*
Login page
pada laman ini, user yang sudah terdaftar (existing user) dapat log in menggunakan :
-email
-password
yang sudah terdaftar sebelumnya
---------------------------------------------------------------------------------------
jika log in berhasil maka user akan dilanjutkan ke home page
jika user belum memiliki akun maka user dapat pergi ke register page
*/

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Icon / Logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 75,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                //welcome back message
                Text(
                  "Welcome to Mingl app!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // tempat untuk mengisi email
                MyTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // tempat untuk mengisi password
                MyTextField(
                  controller: pwController,
                  hintText: "Enter your password",
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: "Login",
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
