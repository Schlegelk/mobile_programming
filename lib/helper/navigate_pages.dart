// go to user page
import 'package:flutter/material.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/pages/account_settings_page.dart';
import 'package:social_media/pages/blocked_users_pages.dart';
import 'package:social_media/pages/post_page.dart';
import 'package:social_media/pages/profile_page.dart';

void goUserPage(BuildContext context, String uid) {
  // navigate to the page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

// go to post page
void goPostPage(BuildContext context, Post post) {
  // navigate to post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post),
    ),
  );
}

// go to blocked user apge
void goBlockedUsersPage(BuildContext context) {
  // navigate to page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlockedUsersPage(),
    ),
  );
}

// go to account settings
void goAccountSettingsPage(BuildContext context) {
  // navigate to page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AccountSettingsPage(),
    ),
  );
}
