import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [Tab(text: "Followers"), Tab(text: "Following")],
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              // test name
              title: Text("Bob"),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),

              subtitle: Text('@bob_01'),
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
