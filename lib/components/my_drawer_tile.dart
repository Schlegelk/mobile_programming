import 'package:flutter/material.dart';

/*

DRAWER TILE

This is a simple tile for each item in the menu drawer.

____________________________________________________________

To use this widget, you need:
- title ( e.g. "Home" )
- icon ( e.g. Icons.home )
- function ( e.g. goToHomePage() )

*/

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  // Build UI
  @override
  Widget build(BuildContext context) {
    // List tile
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      onTap: onTap,
    );
  }
}
