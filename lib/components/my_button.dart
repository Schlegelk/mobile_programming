import 'package:flutter/material.dart';

/*
BUTTON
*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding inside
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          // warna tombol
          color: Theme.of(context).colorScheme.secondary,
          // curved box
          borderRadius: BorderRadius.circular(12),
        ),
        // text
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
