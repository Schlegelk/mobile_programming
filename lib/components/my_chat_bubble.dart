import 'package:flutter/material.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const MyChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  // Chat bubble layout
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isCurrentUser
              ? Color.fromARGB(255, 130, 189, 237)
              : Colors.blueGrey.shade300,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(message),
    );
  }
}
