import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovely/models/user.dart';
import 'package:lovely/repositories/searchRepository.dart';
import 'package:lovely/ui/widgets/iconWidget.dart';
import 'package:lovely/ui/widgets/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({required this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  final int _currentDate = DateTime.now().day;
  int _day = 0;
  int _searchchaces = 0;
  Future<bool> _chances() async {
    try {
      print('fetching local data');
      _day = await sharedPreferencesHelper.getInt('day') ?? 0;
      _searchchaces = await sharedPreferencesHelper.getInt('chances') ?? 0;
      if (_currentDate != _day) {
        await sharedPreferencesHelper.setInt('day', _currentDate);
        await sharedPreferencesHelper.setInt('chances', 0);
        _searchchaces = 0;
      } else if (_day == _currentDate) {
        _searchchaces = await sharedPreferencesHelper.getInt('chances');
        print(_searchchaces);
      }
      return true;
    } on Exception catch (e) {
      print('preferences failed');
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('creating widgets');
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, SearchRepository searchRepository, _) {
      switch (searchRepository.searchstate) {
        case SearchState.SearchingUser:
          searchRepository.findUsers(uid: widget.userId);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Finding Users'),
                ),
              ],
            ),
          );
        case SearchState.LoadUser:
          User _user = searchRepository.showUser;
          User _currentUser = searchRepository.showCurrentUser;
          if (_user.name == "") {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.pink[100]!,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Sorry !' +
                          '\n' +
                          '\n' +
                          ' No New Users Found ' +
                          '\n' +
                          '\n' +
                          'Come Back Later ;)',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return FutureBuilder<bool>(
                future: _chances(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    print(_searchchaces);
                    if (_searchchaces < 5) {
                      return Scaffold(
                        body: profileWidget(
                          padding: size.height * 0.020,
                          photoHeight: size.height * 0.824,
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
                                        (DateTime.now().year -
                                                int.parse(_user.age))
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    iconWidget(Icons.clear, () {
                                      print('pass user initiated');

                                      searchRepository.passUser(
                                          currentUserId: widget.userId,
                                          selectedUserId: _user.uid);
                                      sharedPreferencesHelper.setInt(
                                          'chances', _searchchaces + 1);
                                      _searchchaces = sharedPreferencesHelper
                                          .getInt('chances');
                                      print('chances left ' +
                                          _searchchaces.toString());
                                    }, size.height * 0.08, Colors.blue),
                                    iconWidget(FontAwesomeIcons.solidHeart, () {
                                      searchRepository.chooseUser(
                                          currentUserId: widget.userId,
                                          name: _currentUser.name,
                                          photoUrl: _currentUser.photo,
                                          selectedUserId: _user.uid);
                                      sharedPreferencesHelper.setInt(
                                          'chances', _searchchaces + 1);
                                      _searchchaces = sharedPreferencesHelper
                                          .getInt('chances');
                                      print('chances left ' +
                                          _searchchaces.toString());
                                    }, size.height * 0.06, Colors.red),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (_searchchaces >= 5) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                            color: Colors.pink[100]!,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                                child: Text(
                              'Sorry !' +
                                  '\n' +
                                  '\n' +
                                  ' Maximum Searches are limited to 5 ' +
                                  '\n' +
                                  '\n' +
                                  'Come Back Later Tomorrow ;)',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            ))),
                      ));
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                          color: Colors.pink[100]!,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                              child: Text(
                            'Sorry !' +
                                '\n' +
                                '\n' +
                                ' Something Bad Happened ' +
                                '\n' +
                                '\n' +
                                'We are Trying to Resolve it ;)',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                    ));
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Finding Users'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Waiting ... '),
                        ),
                      ],
                    ),
                  );
                });
          }
      }
    });
  }
}

class SharedPreferencesHelper {
  getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }
}
