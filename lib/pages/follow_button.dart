import 'package:flutter/material.dart';

class MyFollowButton extends StatelessWidget {
  const MyFollowButton({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          padding: const EdgeInsets.all(25),
          onPressed: onPressed,
          color: const Color.fromARGB(255, 130, 189, 237),
          child: Text(
            "Follow",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    ;
  }
}
