import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/services/database/database_provider.dart';

class FollowListPage extends StatefulWidget {
  const FollowListPage({super.key});

  @override
  State<FollowListPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FollowListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [Tab(text: "Followers"), Tab(text: "Following")],
            labelColor: Color.fromARGB(255, 135, 183, 222),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
            return ListTile(
              title: Text(user.name),
            );
          },
        );
}
