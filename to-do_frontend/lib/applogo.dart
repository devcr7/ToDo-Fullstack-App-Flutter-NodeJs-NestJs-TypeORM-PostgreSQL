import 'package:flutter/material.dart';

class CommonLogo extends StatelessWidget {
  const CommonLogo({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network("https://pluspng.com/img-png/avengers-logo-png-avengers-logo-png-1376.png",width: 100,),
        const Text(
          "To-Do App",
          style: TextStyle(
            fontSize: 32.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Make A List of your task",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            letterSpacing: 2.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}