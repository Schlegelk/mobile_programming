/* 

Account settings page
a page for user related settings such as deleting their account

*/

import 'package:flutter/material.dart';
import 'package:social_media/services/auth/auth_service.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // account deletion confirmation
  void confirmDeletion(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Account"),
              content:
                  const Text("Are you sure you want to delete your account?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    // delete account
                    await AuthService().deleteAccount();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', ((route) => false));
                  },
                  child: const Text("Delete"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Account Settings"),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),

        // body
        body: Column(
          children: [
            GestureDetector(
              onTap: () => confirmDeletion(context),
              child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text(
                    "Delete Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
            )
          ],
        ));
  }
}
