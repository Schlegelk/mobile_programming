import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_drawer.dart';
import 'package:social_media/components/my_input_alert_box.dart';
import 'package:social_media/components/my_post_tile.dart';
import 'package:social_media/helper/navigate_pages.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/services/database/database_provider.dart';

/*

HOME PAGE

*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // text controllers
  final _messageController = TextEditingController();

  // on startup
  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  // load all posts
  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  // show post message dialog box
  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: _messageController,
        hintText: "What's on your mind?",
        onPressed: () async {
          // post in db
          await postMessage(_messageController.text);
        },
        onPressedText: "Post",
      ),
    );
  }

  // user wants to post message
  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: MyDrawer(),

        // App Bar
        appBar: AppBar(
          centerTitle: true,
          title: Text("H O M E"),
          foregroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            tabs: [Tab(text: "For You"), Tab(text: "Following")],
            labelColor: Color.fromARGB(255, 135, 183, 222),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorColor: Theme.of(context).colorScheme.secondary,
          ),
        ),

        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: _openPostMessageBox,
          child: Icon(Icons.add),
        ),

        // Body: list of all posts
        body: TabBarView(children: [
          _buildPostList(listeningProvider.allPosts),
          _buildPostList(listeningProvider.followingPosts)
        ]),
      ),
    );
  }

  // build list UI given a list of posts
  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ?

        // post list is empty
        Center(
            child: Text("Nothing here.."),
          )
        :

        // post list is NOT empty
        ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // get each individual post
              final post = posts[index];

              // return post to tile ui
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
