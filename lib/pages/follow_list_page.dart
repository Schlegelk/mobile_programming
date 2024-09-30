import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.inversePrimary,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              // test name
              title: const Text("Bob"),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),

              subtitle: const Text('@bob_01'),
              subtitleTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),

              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildUserList(List userList, String message) {
  return userList.isEmpty
      ? Center(
          child: Text(message),
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
