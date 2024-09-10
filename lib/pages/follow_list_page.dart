import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [Tab(text: "Followers"), Tab(text: "Following")],
            ),
          ),
          body: TabBarView(
            children: [Text("followers"), Text("following")],
          )),
    );
  }
}
