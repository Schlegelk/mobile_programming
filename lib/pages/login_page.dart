import 'package:flutter/material.dart';
import 'package:social_media/components/my_button.dart';
import 'package:social_media/components/my_loading_circle.dart';
import 'package:social_media/components/my_text_field.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // access auth service
  final _auth = AuthService();

  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // login method
  void login() async {
    // loading circle
    showLoadingCircle(context);

    try {
      // try login
      await _auth.loginEmailPassword(emailController.text, pwController.text);

      // succeed login then loading circle disappear
      if (mounted) hideLoadingCircle(context);
    }

    // catch errors
    catch (e) {
      // finished loading
      if (mounted) hideLoadingCircle(context);

      // let user know if there is error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Icon / Logo
                  CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Mingl",
                    style: GoogleFonts.pacifico(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 60),

                  //welcome back message
                  Text(
                    "Welcome to Mingl app!",
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // tempat untuk mengisi email
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // tempat untuk mengisi password
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter password",
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
                    onTap: login,
                  ),

                  const SizedBox(height: 50),

                  //Not a member? Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 5),

                      //pengguna dapat menekan tombol register page
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
