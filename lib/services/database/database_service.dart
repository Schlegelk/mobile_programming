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
          int currentLikeCount = postSnapshot['likes'];

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
            'likes': currentLikeCount,
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

  /* 
  
  ACCOUNT STAFF
  
  */

  /*

  FOLLOW

  */

  // Follow User
  Future<void> followUserInFirebase(String uid) async {
    final currentUserId = _auth.currentUser!.uid;

    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("Following")
        .doc(uid)
        .set({});

    await _db
        .collection("Users")
        .doc(uid)
        .collection("Followers")
        .doc(currentUserId)
        .set({});
  }

  // Unfollow User
  Future<void> unfollowUserInFirebase(String uid) async {
    final currentUserId = _auth.currentUser!.uid;

    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("Following")
        .doc(uid)
        .delete();

    await _db
        .collection("Users")
        .doc(uid)
        .collection("Followers")
        .doc(currentUserId)
        .delete();
  }

  // Get a user's followers: uid list
  Future<List<String>> getFollowerUidsFromFirebase(String uid) async {
    final snapshot =
        await _db.collection("Users").doc(uid).collection("Followers").get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Get a user's following: uid list
  Future<List<String>> getFollowingUidsFromFirebase(String uid) async {
    final snapshot =
        await _db.collection("Users").doc(uid).collection("Following").get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /*

  SEARCH

  */
}
