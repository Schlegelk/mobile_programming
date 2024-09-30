/* 

POST PAGE

*/

import 'package:flutter/material.dart';
import 'package:social_media/components/my_post_tile.dart';
import 'package:social_media/helper/navigate_pages.dart';
import 'package:social_media/models/post.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // build ui
  @override
  Widget build(BuildContext context) {
    // scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // app bar
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Body
      body: ListView(
        children: [
          // Post
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),

          // Comments
        ],
      ),
    );
  }
}
