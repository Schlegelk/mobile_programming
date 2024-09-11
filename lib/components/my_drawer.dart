import 'package:flutter/material.dart';
import 'package:social_media/components/my_drawer_tile.dart';
import 'package:social_media/pages/settings_page.dart';

/*

DRAWER

This is a menu drawer which is usually access on the left side of app bar

_____________________________________________________________

Contains 5 menu options:

- Home
- Profile
- Search
- Settings
- Logout

*/

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Drawer
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // app logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // divider line
              Divider(color: Theme.of(context).colorScheme.secondary),

              const SizedBox(height: 10),

              // home list tile
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  // pop menu drawer since we are already at home
                  Navigator.pop(context);
                },
              ),

              // profile list tile

              // search list tile

              // settings list tile
              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);

                  // go to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),

              // logout list tile
            ],
          ),
        ),
      ),
    );
  }
}
