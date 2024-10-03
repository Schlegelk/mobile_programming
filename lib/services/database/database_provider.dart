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

    // get blocked user ids
    final blockedUserIds = await _db.getBlockedUsersFromFirebase();
    _allPosts =
        allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

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
    // update user view
    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    await _db
        .deleteCommentFromFirebase(commentId); // delete comment from firebase
    await loadComments(postId); // refresh comment
  }

  /*
    account methods
  */
  // local list of blocked users
  List<UserProfile> _blockedUsers = [];

  // get list of blocked users
  List<UserProfile> getBlockedUsers() => _blockedUsers;

  // fetch blocked users
  Future<void> loadBlockedUsers() async {
    final blockedUserIds = await _db.getBlockedUsersFromFirebase();

    final blockedUsersData = await Future.wait(
        blockedUserIds.map((userId) => _db.getUserFromFirebase(userId)));

    // return as list
    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  // block user
  Future<void> blockUser(String userId) async {
    await _db.blockUserInFirebase(userId);
    await loadBlockedUsers();
    await loadAllPosts();
    notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String userId) async {
    await _db.unblockUserInFirebase(userId);
    await loadBlockedUsers();
    await loadAllPosts();
    notifyListeners();
  }

  // report user & post
  Future<void> reportUser(String postId, userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }

  /*

  FOLLOW

  Everything below is done with uids (String)

  Each user id has a list of:
  -following uid
  -followers uid
  */

  // Local Maps
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followerCount = {};
  final Map<String, int> _followingCount = {};

  // get counts for followers & following locally: given a uid
  int getFollowerCount(String uid) => _followerCount[uid] ?? 0;
  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  // load followers
  Future<void> loadUserFollowers(String uid) async {
    final listOfFollowerUids = await _db.getFollowerUidsFromFirebase(uid);

    _followers[uid] = listOfFollowerUids;
    _followerCount[uid] = listOfFollowerUids.length;

    notifyListeners();
  }

  // load following
  Future<void> loadUserFollowing(String uid) async {
    final listOfFollowingUids = await _db.getFollowingUidsFromFirebase(uid);

    _following[uid] = listOfFollowingUids;
    _followingCount[uid] = listOfFollowingUids.length;

    notifyListeners();
  }

  // follow user
  Future<void> followUser(String targetUserId) async {
    /*

    currently logged in user wants to follow target user

    */

    // get current uid
    final currentUserId = _auth.getCurrentUid();

    // initialize with empty lists if null
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    /*

    Optimistic UI changes: Update local data & revert back if database request fails
    
    */

    // follow if current user is not one of the target user's followers
    if (!_followers[targetUserId]!.contains(currentUserId)) {
      // add current user to target user's follower list
      _followers[targetUserId]?.add(currentUserId);

      // update follower count
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      // add target user to current user
      _following[currentUserId]?.add(targetUserId);

      // update following count
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
    }

    // update UI
    notifyListeners();

    /*
     UI has been optimistically updated above with local data
     */

    try {
      // follow user in firebase
      await _db.followUserInFirebase(targetUserId);

      // reload current user's followers
      await loadUserFollowers(currentUserId);

      // reload current user's following
      await loadUserFollowing(currentUserId);
    }
    // reverting back to original if there's an error
    catch (e) {
      _followers[targetUserId]?.remove(currentUserId);

      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

      _following[currentUserId]?.remove(targetUserId);

      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      // update UI
      notifyListeners();
    }
  }

  // unfollow user
  Future<void> unfollowUser(String targetUserId) async {
    /*

    currently logged in user wants to unfollow target user

    */

    // get current uid
    final currentUserId = _auth.getCurrentUid();

    // initialize with empty lists if null
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    /*

    Optimistic UI changes: Update local data & revert back if database request fails
    
    */

    // unfollow if current user is one of the target user's following
    if (!_followers[targetUserId]!.contains(currentUserId)) {
      // remove current user to target user's follower list
      _followers[targetUserId]?.remove(currentUserId);

      // update follower count
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 1) - 1;

      // remove target user from current user's following list
      _following[currentUserId]?.remove(targetUserId);

      // update following count
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 1) - 1;
    }

    // update UI
    notifyListeners();

    /*
     UI has been optimistically updated above with local data
     */

    try {
      // unfollow user in firebase
      await _db.unfollowUserInFirebase(targetUserId);

      // reload current user's followers
      await loadUserFollowers(currentUserId);

      // reload current user's following
      await loadUserFollowing(currentUserId);
    }
    // reverting back to original if there's an error
    catch (e) {
      _followers[targetUserId]?.add(currentUserId);

      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);

      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;

      // update UI
      notifyListeners();
    }
  }

  // is current user following target user?
  bool isFollowing(String uid) {
    final currentUserId = _auth.getCurrentUid();
    return _followers[uid]?.contains(currentUserId) ?? false;
  }

  /*

  MAP OF PROFILES

  for a given uid:

  - list of follower profiles
  - list of following profiles

  */

  final Map<String, List<UserProfile>> _followersProfile = {};
  final Map<String, List<UserProfile>> _followingProfile = {};

  // get list of follower profiles for a given user
  List<UserProfile> getListOfFollowersProfile(String uid) =>
      _followersProfile[uid] ?? [];

  // get list of following profiles for a given user
  List<UserProfile> getListOfFollowingProfile(String uid) =>
      _followingProfile[uid] ?? [];

  // load follower profiles for a given uid
  Future<void> loadUserFollowerProfiles(String uid) async {
    try {
      final followerIds = await _db.getFollowerUidsFromFirebase(uid);

      List<UserProfile> followerProfiles = [];

      for (String followerId in followerIds) {
        UserProfile? followerProfile =
            await _db.getUserFromFirebase(followerId);

        // add to follower profile
        if (followerProfile != null) {
          followerProfiles.add(followerProfile);
        }
      }

      // update local data
      _followersProfile[uid] = followerProfiles;

      // update UI
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadUserFollowingProfiles(String uid) async {
    try {
      final followingIds = await _db.getFollowingUidsFromFirebase(uid);

      List<UserProfile> followingProfiles = [];

      for (String followingId in followingIds) {
        UserProfile? followingProfile =
            await _db.getUserFromFirebase(followingId);

        // add to following profile
        if (followingProfile != null) {
          followingProfiles.add(followingProfile);
        }
      }

      // update local data
      _followingProfile[uid] = followingProfiles;

      // update UI
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
