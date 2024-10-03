import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_bio_box.dart';
import 'package:social_media/components/my_input_alert_box.dart';
import 'package:social_media/components/my_post_tile.dart';
import 'package:social_media/helper/navigate_pages.dart';
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
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

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
    // get user posts
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);

    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // AppBar
      appBar: AppBar(
        centerTitle: true,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (user != null && user!.uid == currentUserId) 
                    GestureDetector(
                      onTap: _showEditBioBox,
                      child: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Bio box
            MyBioBox(
              text: _isLoading ? '...' : user?.bio ?? '',
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25.0),
              child: Text(
                "Posts",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),

            // list of posts from user
            allUserPosts.isEmpty
                ?

                // user post is empty
                const Center(
                    child: Text("No posts yet.."),
                  )
                :

                // user post is not empty
                ListView.builder(
                    itemCount: allUserPosts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // get invidiual post
                      final post = allUserPosts[index];

                      // post tile UI
                      return MyPostTile(
                        post: post, 
                        onUserTap: () {},
                        onPostTap: () => goPostPage(context, post),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
