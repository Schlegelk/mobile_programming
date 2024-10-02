/*

COMMENT MODEL

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  // convert firestore data into comment object

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      postId: doc['postId'],
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }

  // map the comment to store into firebase
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
