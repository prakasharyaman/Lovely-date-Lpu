import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget userGender(gender) {
  switch (gender) {
    case 'Male':
      return Icon(
        FontAwesomeIcons.mars,
      );

    case 'Female':
      return Icon(
        FontAwesomeIcons.venus,
      );

    case 'Transgender':
      return Icon(
        FontAwesomeIcons.transgender,
      );

    default:
      return Icon(FontAwesomeIcons.cloud);
  }
}
