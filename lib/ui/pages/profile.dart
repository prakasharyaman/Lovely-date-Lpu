import 'package:flutter/material.dart';

import 'package:lovely/ui/widgets/profileForm.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Setup"),
        centerTitle: true,
      ),
      body: ProfileForm(),
    );
  }
}
