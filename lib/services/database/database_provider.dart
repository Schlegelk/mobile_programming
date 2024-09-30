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
import 'package:social_media/models/user.dart';
import 'package:social_media/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  /*
  
    SERVICES
  
  */

  // Get db & auth services
  final _db = DatabaseService();

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
}
