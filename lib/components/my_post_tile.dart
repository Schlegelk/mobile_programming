/*

POST TILE

_________________________________________________

- the post

- a function for onPostTap

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_input_alert_box.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:social_media/services/database/database_provider.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile(
      {super.key,
      required this.post,
      required this.onUserTap,
      required this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // widget startup
  @override
  void initState() {
    super.initState();

    _loadComments();
  }

  /*
LIKES BUTTON
  */

  // User tapped like (or unlike)
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  /*

  Comment

  */

  // comment text controller
  final _commentController = TextEditingController();

  // create new comment
  void _openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
            textController: _commentController,
            hintText: "Type a comment...",
            onPressed: () async {
              // add post to firebase
              await _addComment();
              // load new comment
              await _loadComments();
            },
            onPressedText: "Post"));
  }

  // user tapping the post to add comment
  Future<void> _addComment() async {
    // does nothing if text is empty
    if (_commentController.text.trim().isEmpty) return;

    // attempt to add comment
    try {
      await databaseProvider.addComment(
          widget.post.id, _commentController.text.trim());
    } catch (e) {
      print(e);
    }
  }

  // load comments inside the post
  Future<void> _loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
  }

  /*
  SHOW OPTIONS:
  case 1: this post belongs to current user
  case 2: this post doesn't belong to current user
  */

  //show options for post (titik tiga samping username)
  void _showOptions() {
    // check if this post is owned by the user or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    // show options button
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // this post belongs to current user
              if (isOwnPost)

                // delete message button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    // pop option box
                    Navigator.pop(context);

                    //handle delete action
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )

              // if this post doesn't belong to current user
              else ...[
                // report post button
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    // pop option box
                    Navigator.pop(context);

                    // handle report action
                    _reportPostConfirmationBox();
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
                    _blockUserConfirmationBox();
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

  // report post confirmation
  void _reportPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Post"),
              content: const Text("Are you sure you want to report this post?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    // report user
                    await databaseProvider.reportUser(
                        widget.post.id, widget.post.uid);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Blocked")));
                  },
                  child: const Text("Report"),
                ),
              ],
            ));
  }

  // block user
  void _blockUserConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text("Block User"),
                content:
                    const Text("are you sure you want to block this user?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await databaseProvider.blockUser(widget.post.uid);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User Blocked")));
                    },
                    child: const Text("Block"),
                  )
                ]));
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    // does current user like this post
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    // listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // listen to comment count
    int commentCount = listeningProvider.getComments(widget.post.id).length;

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
                  Expanded(
                    child: Text(widget.post.name,
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
                      '@${widget.post.username}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const Spacer(),

                  //button => more options: delete
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _showOptions,
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
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 20),

            // buttons -> like & comment
            Row(
              children: [
                // like row
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      // like button
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),

                      const SizedBox(width: 5),

                      // like count
                      Text(
                        likeCount != 0 ? likeCount.toString() : '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),

                // comment row
                Row(
                  children: [
                    // comment button
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 5),

                    // coment count
                    Text(
                      commentCount != 0 ? commentCount.toString() : '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
