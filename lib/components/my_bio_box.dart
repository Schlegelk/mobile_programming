import 'package:flutter/material.dart';

/*

USER BIO BOX

This is a simple box with text inside. We will use it for the user bio on 
their profile pages.

----------------------------------------------------------------------

-text


*/

class MyBioBox extends StatelessWidget {
  final String text;

  const MyBioBox({super.key, required this.text});

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //Container
    return Container(
      decoration: BoxDecoration(
        //color
        color: Theme.of(context).colorScheme.secondary,

        //curve corners
        borderRadius: BorderRadius.circular(8),
      ),

      //padding inside
      padding: const EdgeInsets.all(25),

      //Text
      child: Text(
        text.isNotEmpty ? text : "Empty bio...",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
