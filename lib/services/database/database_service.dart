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

  /*

  LIKES

  */

  /*

  COMMENT

  */

  /* 
  
  ACCOUNT STAFF
  
  */

  /*

  FOLLOW

  */

  /*

  SEARCH

  */
}
