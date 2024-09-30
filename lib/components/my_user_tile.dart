import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inversePrimary,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          // test name
          title: const Text("Bob"),
          titleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.inversePrimary),

          subtitle: const Text('@bob_01'),
          subtitleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),

          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
