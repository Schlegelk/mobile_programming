import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/components/my_settings_tile.dart';
import 'package:social_media/helper/navigate_pages.dart';
import 'package:social_media/themes/theme_provider.dart';

/*

SETTING PAGE

- Dark Mode
- Blocked users
- Account settings

*/

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        centerTitle: true,
        title: const Text("S E T T I N G S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Body
      body: Column(
        children: [
          // Dark mode tile
          MySettingsTile(
            title: "Dark Mode",
            action: CupertinoSwitch(
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
          ),
          // Block users tile
          MySettingsTile(
              title: "Blocked Users",
              action: IconButton(
                onPressed: () => goBlockedUsersPage(context),
                icon: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),

          // Account settings tile
          MySettingsTile(
              title: "Account Settings",
              action: IconButton(
                  onPressed: () => goAccountSettingsPage(context),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primary,
                  )))
          // Logout button
        ],
      ),
    );
  }
}
