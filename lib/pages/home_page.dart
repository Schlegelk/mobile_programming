import 'package:flutter/material.dart';
import 'package:social_media/components/my_drawer.dart';
import 'package:social_media/components/my_input_alert_box.dart';

/*

HOME PAGE

*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final _messageController = TextEditingController();

  // show post message dialog box
  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: _messageController,
        hintText: "What's on your mind?",
        onPressed: () {},
        onPressedText: "Post",
      ),
    );
  }

  // post

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),

      // App Bar
      appBar: AppBar(
        centerTitle: true,
        title: Text("H O M E"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: Icon(Icons.add),
      ),
    );
  }
}
