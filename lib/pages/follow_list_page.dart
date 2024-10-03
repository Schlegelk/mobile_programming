import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_user_tile.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/services/database/database_provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;

  const FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FollowListPage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // on startup,
  @override
  void initState() {
    super.initState();
    // load follower list
    loadFollowerList();
    // load following list
    loadFollowingList();
  }

  Future<void> loadFollowerList() async {
    await databaseProvider.loadUserFollowerProfiles(widget.uid);
  }

  Future<void> loadFollowingList() async {
    await databaseProvider.loadUserFollowingProfiles(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = listeningProvider.getListOfFollowersProfile(widget.uid);
    final following = listeningProvider.getListOfFollowingProfile(widget.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.primary,
            bottom: TabBar(
              dividerColor: Colors.transparent,
              tabs: [Tab(text: "Followers"), Tab(text: "Following")],
              labelColor: Color.fromARGB(255, 135, 183, 222),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          body: TabBarView(
            children: [
              _buildUserList(followers, "No followers.."),
              _buildUserList(following, "No following.."),
            ],
          )),
    );
  }
}

Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
  return userList.isEmpty
      ? Center(
          child: Text(emptyMessage),
        )
      : ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            // getting user list from user profile
            // return a List Tile based on index
            final user = userList[index];
            return MyUserTile(
              user: user,
            );
          },
        );
}
