import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MyProfileStats extends StatelessWidget {
  final String postCount;
  final int followerCount;
  final int followingCount;

  const MyProfileStats(
      {super.key,
      required this.postCount,
      required this.followerCount,
      required this.followingCount});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // dummy amounts
        Column(
          //post
          children: [Text("6"), Text("Posts")],
        ),

        // followers
        Column(
          children: [Text("10"), Text("Followers")],
        ),

        // following
        Column(
          children: [Text("20"), Text("Following")],
        ),
      ],
    );
  }
}
