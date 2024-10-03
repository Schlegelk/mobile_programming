import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/pages/profile_page.dart';

class MyUserTile extends StatelessWidget {
  final UserProfile user;

  const MyUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inversePrimary,
            blurRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          // test name
          title: Text(user.name),
          titleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          subtitle: Text('@${user.username}'),
          subtitleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(uid: user.uid),
            ),
          ),
          trailing: Icon(Icons.arrow_forward,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
