import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovely/addedFeatures/events.dart';
import 'package:lovely/addedFeatures/lovelyGram.dart';
import 'package:lovely/repositories/userRepository.dart';
import 'package:lovely/ui/pages/feedback.dart';
import 'package:lovely/ui/pages/help.dart';
import 'package:lovely/ui/pages/matches.dart';
import 'package:lovely/ui/pages/messages.dart';
import 'package:lovely/ui/pages/settings.dart';
import 'package:lovely/ui/widgets/profileView.dart';
import 'package:lovely/ui/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  late FirebaseMessaging messaging;
  String? notificationText;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");
    checkForInitialMessage();
    messaging.getToken().then((value) {
      print(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      print(event.data.values);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      print('Message clicked!');
      print(event.notification!.body);
      print(event.data.values);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  checkForInitialMessage() async {
    RemoteMessage? event = await FirebaseMessaging.instance.getInitialMessage();
    print('initial messages');
    if (event != null) {
      print(event.notification!.body);
      print(event.data.values);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    String userId = widget.userId;
    List<Widget> pages = <Widget>[
      Search(
        userId: userId,
      ),
      Matches(
        userId: userId,
      ),
      Messages(
        userId: userId,
      ),
    ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          'Lovely',
        ),
        centerTitle: true,
      ),
      body: pages.elementAt(_selectedIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: FlexColor.sakuraLightPrimary,
              ),
              child: Column(
                children: [
                  Container(
                    child: Flexible(
                      child: Image(
                        image: AssetImage('love.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Lovely LPU',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(
                            userId: widget.userId,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: const Text('Lovely-Gram'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LovelyGram()),
                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.user),
              title: const Text('Profile Setup'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileView(userId: userId)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: const Text('Events by Vertos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsFeature()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: const Text('Website'),
              onTap: () async {
                const url = 'https://lovelylpu.wixsite.com/lovelylpu';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: const Text('Share the App'),
              onTap: () {
                Share.share(
                    'Check out this Awesome Lovely App :https://play.google.com/store/apps/details?id=com.lovelyLpu.lovely',
                    subject: 'Lovely LPU App');
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpScreen()),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.exit_to_app),
            //   title: const Text('LogOut'),
            //   onTap: () {
            //     userRepository.signOut();
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Matches'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              label: 'Messages')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
