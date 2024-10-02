/*

DATABASE SERVICE

This class handles all the data from and to firebase,

-----------------------------------------------------------------------

- User Profile
- Post Message
- Likes
- Comment
- Account staff
- Follow / Unfollow
- Search user

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/models/comment.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/services/auth/auth_service.dart';

class DatabaseService {
  // Get instance of Firestore DB & Auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*

  USER PROFILE

  When a new user registers, we create an account for them.
  Let's also store their details in the database to display on their profile page.

  */

  // Save user info
  Future<void> saveUserInfoInFirebase({
    required String name,
    required String email,
  }) async {
    // Get current user id
    String uid = _auth.currentUser!.uid;

    // Extract username from email
    String username = email.split('@')[0];

    // Create user profile
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // Convert user into a map so that we can store it in Firebase
    final userMap = user.toMap();

    // Save user info in Firebase
    await _db.collection('Users').doc(uid).set(userMap);
  }

  // Get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // Retrieve user doc from Firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      // Convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update User Bio
  Future<void> updateUserBioInFirebase(String bio) async {
    // Get current id
    String uid = AuthService().getCurrentUid();

    // Attempt to update in Firebase
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  // delete user info
  Future<void> deleteUserInfoFromFirebase(String uid) async {
    WriteBatch batch = _db.batch();

    // delete user doc
    DocumentReference userDoc = _db.collection("Users").doc(uid);
    batch.delete(userDoc);

    // delete user post
    QuerySnapshot userPosts =
        await _db.collection("Posts").where("uid", isEqualTo: uid).get();

    for (var post in userPosts.docs) {
      batch.delete(post.reference);
    }

    // delete user comments
    QuerySnapshot userComments =
        await _db.collection("Comments").where("uid", isEqualTo: uid).get();

    for (var comment in userComments.docs) {
      batch.delete(comment.reference);
    }

    // delete likes from user
    QuerySnapshot allPosts = await _db.collection("Posts").get();

    for (QueryDocumentSnapshot post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      var likedBy = postData['likedBy'] as List<dynamic>? ?? [];

      if (likedBy.contains(uid)) {
        batch.update(post.reference, {
          'likedBy': FieldValue.arrayRemove([uid]),
          'liked': FieldValue.increment(-1),
        });
      }
    }

    // update followers countr for other users

    // commit batch
    await batch.commit();
  }

  /* 

  POST MESSAGE

  */

  // post a Message
  Future<void> postMessageInFirebase(String message) async {
    // try to post message
    try {
      // get current id
      String uid = _auth.currentUser!.uid;

      // use this uid to get the user's profile
      UserProfile? user = await getUserFromFirebase(uid);

      // create a new post object
      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );

      // convert post object -> map
      Map<String, dynamic> newPostMap = newPost.toMap();

      // add to firebase
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  // delete a post
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  // get all post from firebase
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      // get all posts from firebase
      QuerySnapshot snapshot = await _db

          // go to collection -> Posts
          .collection("Posts")
          // chronological order
          .orderBy("timestamp", descending: true)
          // get this data
          .get();
      // return as a list of posts
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }
  // get individual post

  /*

  LIKES

  */
  //Like a post
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      // get current user id
      String uid = _auth.currentUser!.uid;

      // go to teh doc for this post
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      // execute like
      await _db.runTransaction(
        (transaction) async {
          // get post data
          DocumentSnapshot postSnapshot = await transaction.get(postDoc);

          // get like of users who likes this posts
          List<String> likedBy =
              List<String>.from(postSnapshot['likedBy'] ?? []);

          // get like count
          int currentLikeCount = postSnapshot['likeCount'];

          // if user has not liked this post yet -> then like
          if (!likedBy.contains(uid)) {
            // add user to like list
            likedBy.add(uid);

            // increment the like count
            currentLikeCount++;
          }

          // if user already liked the post -> then unlike
          else {
            // remove user from like list on the post
            likedBy.remove(uid);

            // decrement like count
            currentLikeCount--;
          }

          // update in firebase
          transaction.update(postDoc, {
            'likeCount': currentLikeCount,
            'likedBy': likedBy,
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }
  /*

  COMMENT

  */

  // adding comment
  Future<void> addCommentInFirebase(String postId, String message) async {
    try {
      // get current user id
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      // create comment object
      Comment newComment = Comment(
        id: '', // generated by firebase
        postId: postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
      );

      // map the comment
      Map<String, dynamic> newCommentMap = newComment.toMap();

      // store data inside firebase
      await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  // delete comment
  Future<void> deleteCommentFromFirebase(String commentId) async {
    try {
      await _db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  // fetch comment
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      // get comment from firebase
      QuerySnapshot snapshot = await _db
          .collection("Comments")
          .where("postId", isEqualTo: postId)
          .get();
      // return as data from firebase as list of comments
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  /* 
  
  ACCOUNT STAFF
  
  */

  // report post
  Future<void> reportUserInFirebse(String postId, userId) async {
    // get user id
    final currentUserId = _auth.currentUser!.uid;

    // create report map
    final report = {
      'reportedBy': currentUserId,
      'messageId': postId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // update firestore
    await _db.collection("Reports").add(report);
  }

  // block user
  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;

    // create a block map
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
  }

  // unblockk user
  Future<void> unblockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;

    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(userId)
        .delete();
  }

  // get list of blocked user
  Future<List<String>> getBlockedUsers() async {
    final currentUserId = _auth.currentUser!.uid;
    final snapshot = await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /*

  FOLLOW

  */

  /*

  SEARCH

  */
}
