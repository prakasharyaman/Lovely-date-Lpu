import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LovelyGram extends StatelessWidget {
  const LovelyGram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/introduction_animation/lovely_gram.png',
              fit: BoxFit.fill,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontFamily: 'Agne',
                  ),
                  textAlign: TextAlign.center,
                  child: AnimatedTextKit(animatedTexts: [
                    TypewriterAnimatedText(
                        'This feature will be available very soon :)'),
                    TypewriterAnimatedText('Press Back To Return'),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
