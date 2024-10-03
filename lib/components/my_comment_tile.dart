/*

A comment tile widget for each comment in the post page.

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/models/comment.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:social_media/services/database/database_provider.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTile(
      {super.key, required this.comment, required this.onUserTap});

  // show commnt options
  void _showOptions(BuildContext context) {
    // check if this post is owned by the user or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;

    // show options button
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // this post belongs to current user
              if (isOwnComment)

                // delete commnt button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    // pop option box
                    Navigator.pop(context);

                    //handle delete action
                    await Provider.of<DatabaseProvider>(context, listen: false)
                        .deleteComment(comment.id, comment.postId);
                  },
                )

              // if this comment doesn't belong to current user
              else ...[
                // report comment button
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    // pop option box
                    Navigator.pop(context);

                    // handle report action
                  },
                ),

                // block user button
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    // pop option box
                    Navigator.pop(context);

                    // handle block action

                  },
                )
              ],

              // cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding outside
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      // padding inside
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        // color
        color: Theme.of(context).colorScheme.tertiary,
        // curve corners
        borderRadius: BorderRadius.circular(8),
      ),

      // column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section
          GestureDetector(
            onTap: onUserTap,
            child: Row(
              children: [
                // profile pic
                Icon(Icons.person,
                    color: Theme.of(context).colorScheme.primary),

                const SizedBox(width: 10),

                // name
                Expanded(
                  child: Text(comment.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis),
                ),

                const SizedBox(width: 5),

                // username handle
                Expanded(
                  child: Text(
                    '@${comment.username}',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Spacer(),

                //button => more options: delete
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _showOptions(context),
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Message
          Text(
            comment.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
