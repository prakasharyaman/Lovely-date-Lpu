import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovely/models/user.dart';
import 'package:lovely/repositories/matchesRepository.dart';
import 'package:lovely/ui/pages/messaging.dart';
import 'package:lovely/ui/widgets/iconWidget.dart';
import 'package:lovely/ui/widgets/pageTurn.dart';
import 'package:lovely/ui/widgets/profile.dart';
import 'package:provider/provider.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({required this.userId});

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, MatchesRepository matchesRepo, _) {
      switch (matchesRepo.getMatchState) {
        case MatchState.FindingMatches:
          matchesRepo.createMatchList(userid: widget.userId);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Finding Matches'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    ' This Takes Time' +
                        '\n' +
                        ' feel free to go ahead' +
                        '\n' +
                        'and check your conversations...' +
                        '\n' +
                        '>',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        case MatchState.LoadMatches:
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                title: Text(
                  "Matched Vertos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: matchesRepo.matchListgetter,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                  if (snapshot.data != null) {
                    final user = snapshot.data!.docs;

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await matchesRepo
                                  .getUserDetails(user[index].id);
                              User currentUser = await matchesRepo
                                  .getUserDetails(widget.userId);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: profileWidget(
                                    padding: size.height * 0.005,
                                    photoHeight: size.height * 0.60,
                                    photoWidth: size.width,
                                    photo: selectedUser.photo,
                                    clipRadius: size.height * 0.02,
                                    containerHeight: size.height * 0.3,
                                    containerWidth: size.width * 0.9,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  selectedUser.name.toString() +
                                                      "," +
                                                      (DateTime.now().year -
                                                              int.parse(
                                                                  selectedUser
                                                                      .age))
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          size.height * 0.03),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  selectedUser.about.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: iconWidget(Icons.message,
                                                    () {
                                                  currentUser.uid =
                                                      widget.userId;
                                                  matchesRepo.openChat(
                                                      currentUserId:
                                                          widget.userId,
                                                      selectedUserId:
                                                          selectedUser.uid);
                                                  pageTurn(
                                                      Messaging(
                                                          currentUser:
                                                              currentUser,
                                                          selectedUser:
                                                              selectedUser),
                                                      context);
                                                }, size.height * 0.04,
                                                    Colors.pink),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: profileWidget(
                              padding: size.height * 0.004,
                              photoHeight: size.height * 0.50,
                              photoWidth: size.width,
                              photo: user[index]['photoUrl'],
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.2,
                              containerWidth: size.width * 0.8,
                              child: Text(" "),
                            ),
                          );
                        },
                        childCount: user.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                },
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                pinned: true,
                title: Text(
                  "Someone Likes You",
                  style: TextStyle(
                    color: Colors.pink,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: matchesRepo.selectedList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                  if (snapshot.data != null) {
                    final user = snapshot.data!.docs;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await matchesRepo
                                  .getUserDetails(user[index].id);
                              User currentUser = await matchesRepo
                                  .getUserDetails(widget.userId);

                              // ignore: missing_return
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: profileWidget(
                                    padding: size.height * 0.005,
                                    photoHeight: size.height * 0.60,
                                    photoWidth: size.width,
                                    photo: selectedUser.photo,
                                    clipRadius: size.height * 0.02,
                                    containerHeight: size.height * 0.3,
                                    containerWidth: size.width * 0.9,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  selectedUser.name.toString() +
                                                      "," +
                                                      (DateTime.now().year -
                                                              int.parse(
                                                                  selectedUser
                                                                      .age))
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          size.height * 0.03),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  selectedUser.about.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              iconWidget(Icons.clear, () {
                                                if (widget.userId != '' &&
                                                    selectedUser.uid != '') {
                                                  matchesRepo.deleteUser(
                                                      widget.userId,
                                                      selectedUser.uid);
                                                  Navigator.of(context).pop();
                                                } else {
                                                  print('delete User failed');
                                                }
                                              }, size.height * 0.08,
                                                  Colors.blue),
                                              SizedBox(
                                                width: size.width * 0.05,
                                              ),
                                              iconWidget(
                                                  FontAwesomeIcons.solidHeart,
                                                  () {
                                                if (widget.userId != '' &&
                                                    selectedUser.uid != '' &&
                                                    currentUser.name != '' &&
                                                    currentUser.photo != '' &&
                                                    selectedUser.uid != '' &&
                                                    selectedUser.photo != '') {
                                                  matchesRepo.selectUser(
                                                      widget.userId,
                                                      selectedUser.uid,
                                                      currentUser.name,
                                                      currentUser.photo,
                                                      selectedUser.uid,
                                                      selectedUser.photo);
                                                  Navigator.of(context).pop();
                                                } else {
                                                  print('select user failed');
                                                }
                                              }, size.height * 0.06,
                                                  Colors.red),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: profileWidget(
                              padding: size.height * 0.01,
                              photo: user[index]['photoUrl'],
                              photoWidth: size.width * 0.6,
                              photoHeight: size.height * 0.4,
                              clipRadius: size.height * 0.02,
                              containerHeight: size.height * 0.04,
                              containerWidth: size.width * 0.6,
                              child: Text(
                                "  " + user[index]['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        childCount: user.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                    );
                  } else
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                },
              ),
            ],
          );
      }
    });
  }
}
