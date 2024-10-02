import 'package:flutter/material.dart';
import 'package:social_media/components/my_loading_circle.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:social_media/services/database/database_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

/*
REGISTER PAGE
pengguna dapat membuat akun dengan mengisi :

-nama
-email
-password
-confirm password
*/

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
// access auth service
  final _auth = AuthService();
  final _db = DatabaseService();

// text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirPwController = TextEditingController();

// register button tapped
  void register() async {
// password match -> create an user
    if (pwController.text == confirPwController.text) {
// show loading circle
      showLoadingCircle(context);

// attempt to register new user
      try {
//trying to register
        await _auth.registerEmailPassword(
          emailController.text,
          pwController.text,
        );

// succeed register
        if (mounted) hideLoadingCircle(context);

//once regristered,create and save user profile in database
        await _db.saveUserInfoInFirebase(
            name: nameController.text, email: emailController.text);
      }

// catch errors
      catch (e) {
// finished register
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

// password didn't match -> show error
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
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
                  Icon(
                    Icons.person,
                    size: 75,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 50),

                  // create an account message
                  Text(
                    "Let's create an account",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // tempat untuk mengisi nama
                  MyTextField(
                    controller: nameController,
                    hintText: "Name",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

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

                  // tempat untuk mengisi confirm password
                  MyTextField(
                    controller: confirPwController,
                    hintText: "Confirm password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // sign up button
                  MyButton(
                    text: "Register",
                    onTap: register,
                  ),

                  const SizedBox(height: 50),

                  // already a member? Login here!
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 5),

                      //pengguna dapat menekan tombol login page
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login",
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
