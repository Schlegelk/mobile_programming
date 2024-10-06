import 'package:flutter/material.dart';

class MyUserList extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyUserList({
    super.key,
    required this.text,
    required this.onTap,
  });

  // User list for chat page
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // icon
            Icon(Icons.person, color: Theme.of(context).colorScheme.primary),

            const SizedBox(width: 20),

            // user name
            Expanded(
              child: Text(
                text, 
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
                )
              ),
          ],
        ),
      ),
    );
  }
}
