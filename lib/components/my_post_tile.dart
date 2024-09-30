/*

POST TILE

_________________________________________________

- the post

- a function for onPostTap

*/

import 'package:flutter/material.dart';
import 'package:social_media/models/post.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile({super.key, required this.post, required this.onUserTap, required this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  // build ui
  @override
  Widget build(BuildContext context) {
    // container
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        // padding outside
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      
        // padding inside
        padding: const EdgeInsets.all(20),
      
        decoration: BoxDecoration(
          // color
          color: Theme.of(context).colorScheme.secondary,
          // curve corners
          borderRadius: BorderRadius.circular(8),
        ),
      
        // column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // profile pic
                  Icon(Icons.person,
                      color: Theme.of(context).colorScheme.primary),
      
                  const SizedBox(width: 10),
      
                  // name
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      
                  const SizedBox(width: 5),
      
                  // username handle
                  Text(
                    '@${widget.post.username}',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 10),
      
            // Message
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
