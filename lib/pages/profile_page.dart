import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_bio_box.dart';
import 'package:social_media/components/my_input_alert_box.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:social_media/services/database/database_provider.dart';

/*
This is the profile page for a given uid
*/

class ProfilePage extends StatefulWidget {
  // User id
  final String uid;

  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Providers
  late final DatabaseProvider databaseProvider;

  // User info
  UserProfile? user;
  final String currentUserId = AuthService().getCurrentUid();

  // Text Controller for bio
  final bioTextController = TextEditingController();

  // Loading state
  bool _isLoading = true;

  // On startup
  @override
  void initState() {
    super.initState();
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    loadUser();
  }

  Future<void> loadUser() async {
    // Get the user profile info
    user = await databaseProvider.getUserProfile(widget.uid);

    // Finished loading
    setState(() {
      _isLoading = false;
    });
  }

  // Show edit bio box
  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: bioTextController,
        hintText: "Edit bio...",
        onPressed: saveBio,
        onPressedText: "Save",
      ),
    );
  }

  //save Updated Bio
  Future<void> saveBio() async {
    // start loading ..
    setState(() {
      _isLoading = true;
    });

    // Update Bio
    await databaseProvider.updateBio(bioTextController.text);

    //Reload User
    await loadUser();

    //done loading..
    setState(() {
      _isLoading = false;
    });
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // AppBar
      appBar: AppBar(
        title: Text(_isLoading ? '' : user?.name ?? ''), // Null-aware operator
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          children: [
            // Username handle
            Center(
              child: Text(
                _isLoading
                    ? ''
                    : '@${user?.username ?? ''}', // Null-aware operator
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Profile picture
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(25),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Edit bio section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bio",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Bio box
            MyBioBox(
              text: _isLoading ? '...' : user?.bio ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
