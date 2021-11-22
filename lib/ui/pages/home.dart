import 'package:flutter/material.dart';
import 'package:lovely/introduction/introduction_animation_screen.dart';
import 'package:lovely/repositories/userRepository.dart';
import 'package:lovely/ui/pages/login.dart';
import 'package:lovely/ui/pages/profile.dart';
import 'package:lovely/ui/pages/splash.dart';
import 'package:lovely/ui/pages/tabs.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository userRepository, _) {
        switch (userRepository.status) {
          case Status.Unintialised:
            return Splash();
          case Status.Authenticated:
            return Tabs(
              userId: userRepository.getUser(),
            );

          case Status.Authenticating:

          case Status.Unauthenticated:
            return Login();
          case Status.AuthenticatedButNoProfile:
            return Profile();
          case Status.FirstTimeApp:
            return IntroductionAnimationScreen();
        }
      },
    );
  }
}
