import 'package:flutter/material.dart';
import 'package:lovely/repositories/userRepository.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("WELCOME PAGE"),
              Text(userRepository.getUser().toString()),
              ElevatedButton(
                onPressed: () {
                  context.read<UserRepository>().signOut();
                },
                child: Text("Sign out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
