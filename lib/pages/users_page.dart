import 'package:flutter/material.dart';
import 'package:social_media/components/user_tile.dart';
import 'package:social_media/pages/chat_page.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:social_media/services/chat/chat_service.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  // chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading ..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ...");
        }

        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    return UserTile(
      text: userData["email"],
      onTap: () {
        // tapped on a user -> go to chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"],
            ),
          ),
        );
      },
    );
  }
}
