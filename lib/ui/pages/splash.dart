import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image(
            image: AssetImage(
              "love.png",
            ),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
