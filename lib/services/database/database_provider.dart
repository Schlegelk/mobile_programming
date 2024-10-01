/*

DATABASE PROVIDER

This Provider is to separate the Firestore data handling and the UI of our app.

- The database service class handles data to and from Firebase.
- The database provider class processes the data to display in our app.

This is to make our code more modular, cleaner, and easier to read and test.
Particularly as the number of pages grows, we need this provider to properly manage 
the different states of the app.

- Also, if one day we decide to change our backend (from Firebase to something else),
then it's much easier to manage and switch out different databases.

*/

import 'package:flutter/foundation.dart';
import 'package:social_media/models/comment.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/services/auth/auth_service.dart';
import 'package:social_media/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  /*
  
    SERVICES
  
  */

  // Get db & auth services
  final _db = DatabaseService();
  final _auth = AuthService();

  /*
  
    USER PROFILE 
  
  */

  // Get user profile given uid
  Future<UserProfile?> getUserProfile(String uid) =>
      _db.getUserFromFirebase(uid);

  // Update User Bio
  Future<void> updateBio(String bio) async {
    await _db.updateUserBioInFirebase(bio);
  }

  /*

  POSTS

  */

  // local list of posts
  List<Post> _allPosts = [];

  // get posts
  List<Post> get allPosts => _allPosts;

  // post message
  Future<void> postMessage(String message) async {
    // post message in firebase
    await _db.postMessageInFirebase(message);

    // reload
    await loadAllPosts();
  }

  // fetch all posts
  Future<void> loadAllPosts() async {
    // get all posts from Firebase
    final allPosts = await _db.getAllPostsFromFirebase();

    // update local data
    _allPosts = allPosts;

    // initialize local like data
    initializeLikeMap();

    // update UI
    notifyListeners();
  }

  // filter and return post given uid
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    // delete from firebase
    await _db.deletePostFromFirebase(postId);

    // reload data from firebase
    await loadAllPosts();
  }

  /*
  LIKES
  */

  // local map to track like counts for each post
  Map<String, int> _likeCounts = {
    // for each post id: like count
  };

  // local list to track the posts liked by current user
  List<String> _likedPosts = [];

  // does current user like this post?
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  // initialize like map locally
  void initializeLikeMap() {
    // get current user id
    final currentUserID = _auth.getCurrentUid();

    // clear liked posts (for new user sign in, clear local data) sehingga new user dapat me-like postnya
    _likedPosts.clear();

    // for each post get like data
    for (var post in _allPosts) {
      // update like count map
      _likeCounts[post.id] = post.likeCount;

      // if the current user already likes this post
      if (post.likedBy.contains(currentUserID)) {
        // add this post id to local list of liked posts
        _likedPosts.add(post.id);
      }
    }
  }

  // toggle like
  Future<void> toggleLike(String postId) async {
    // this part will update local values first sehingga ui nya lebih smooth saat merespon

    //store original values in case it fails
    final likedPostsOriginal = _likedPosts;
    final likeCountsOriginal = _likeCounts;

    // perform like / unlike
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    //update UI locally
    notifyListeners();

    // update likes in our database

    // attempt like in database
    try {
      await _db.toggleLikeInFirebase(postId);
    }

    // revert back to initial state if update fails
    catch (e) {
      _likedPosts = likedPostsOriginal;
      _likeCounts = likeCountsOriginal;

      // update the UI
      notifyListeners();
    }
  }

  /*
  COMMENTS
  {
  postId1 : [comments1, comment2, ..],
  postId2 : [comments1, comment2, ..],
  postId3 : [comments1, comment2, ..],
  }

  */
  // comment local list
  final Map<String, List<Comment>> _comments = {};

  // get comment as local
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  // fetch comment from firebase
  Future<void> loadComments(String postId) async {
    final allComments = await _db.getCommentsFromFirebase(postId);
    _comments[postId] = allComments;

    // update local data
    _comments[postId] = allComments;

    // update user view
    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, String message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    await _db
        .deleteCommentFromFirebase(commentId); // delete comment from firebase
    await loadComments(postId); // refresh comment
  }
}
