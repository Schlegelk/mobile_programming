/* 

POST PAGE

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_post_tile.dart';
import 'package:social_media/helper/navigate_pages.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/services/database/database_provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // provider
  late final listeningProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  late final database = Provider.of<DatabaseProvider>(context, listen: false);

  // build ui
  @override
  Widget build(BuildContext context) {
    // listening comment to fetch into post
    final allComments = listeningProvider.getComments(widget.post.id);

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

          // comments
          allComments.isEmpty
              ? Center(child: Text('No comments'))
              : ListView.builder(
                  itemCount: allComments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = allComments[index];

                    // return comment tile UI
                    return Container(
                      child: Text(comment.message),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
