import 'package:flutter/material.dart';

/*

Input Alert Box

Untuk User dapat mengetik di textfield.

Ini digunakan untuk edit Bio, posting Pesan dll

-----------------------------------------------

Widget memerlukan : 

-Text controller
-Hint text ( e.g. "Empty Bio")
-function (e.g. "Save Bio")
-Text untuk button (e.g. "Save")

*/

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({
    super.key,
    required this.textController,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
  });

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // Alert Dialog
    return AlertDialog(
      // Curve Corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),

      // Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // TextField (user types here)
      content: TextField(
        controller: textController,

        // Let's limit the max character
        maxLength: 140,
        maxLines: 3,

        decoration: InputDecoration(
          // Border when textfield is unselected
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),

          // Border when textfield is selected
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),

          // Hint text
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

          // Color inside the TextField
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          // Counter style
          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),

      // Buttons
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            // Close box
            Navigator.pop(context);

            // Clear controller
            textController.clear();
          },
          child: const Text("Cancel"),
        ),

        // Yes button
        TextButton(
          onPressed: () {
            //close box
            Navigator.pop(context);

            //execute function
            onPressed!();

            //clear controller
            textController.clear();
          },
          child: Text(onPressedText),
        )
      ],
    );
  }
}
