import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class EventsFeature extends StatelessWidget {
  const EventsFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/introduction_animation/event.png',
              fit: BoxFit.fill,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                child: DefaultTextStyle(
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontFamily: 'Agne',
                      fontWeight: FontWeight.bold),
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
