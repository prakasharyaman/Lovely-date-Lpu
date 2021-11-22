import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovely/models/user.dart';
import 'package:lovely/repositories/profileRepository.dart';
import 'package:lovely/ui/widgets/iconWidget.dart';
import 'package:lovely/ui/widgets/profile.dart';
import 'package:lovely/ui/widgets/profileViewEdit.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String userId;
  const ProfileView({required this.userId});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var profileREpo = Provider.of<ProfileRepository>(context);

    switch (profileREpo.searchstate) {
      case ProfileState.SearchingUser:
        profileREpo.findUsers(uid: widget.userId);
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Loading ..'),
                ),
              ],
            ),
          ),
        );

      case ProfileState.LoadUser:
        User _user = profileREpo.showCurrentUser;
        return Scaffold(
            appBar: AppBar(
              title: Text('Your profile'),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    print('Profile Edit Pressed');
                    print(widget.userId);
                    if (widget.userId != '') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileViewEdit(
                                  currentuserid: widget.userId)));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      Text('.. Edit'),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      'Click on edit to edit profile ,' +
                          '\n' +
                          'Changes are shown once you close and Reopen the app ',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                profileWidget(
                  padding: size.height * 0.020,
                  photoHeight: size.height * 0.8,
                  photoWidth: size.width * 0.95,
                  photo: _user.photo,
                  clipRadius: size.height * 0.02,
                  containerHeight: size.height * 0.3,
                  containerWidth: size.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                                flex: 2,
                                child: Text(
                                  _user.name.toString() + ", ",
                                  style: TextStyle(color: Colors.white),
                                )),
                            Flexible(
                              flex: 1,
                              child: Text(
                                (DateTime.now().year - int.parse(_user.age))
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.05),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _user.about.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            iconWidget(Icons.clear, () {}, size.height * 0.08,
                                Colors.blue),
                            iconWidget(FontAwesomeIcons.solidHeart, () {},
                                size.height * 0.06, Colors.red),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
    }
  }
}
