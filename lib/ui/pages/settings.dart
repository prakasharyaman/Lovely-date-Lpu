import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lovely/repositories/userRepository.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';

class Settings extends StatefulWidget {
  final String userId;

  const Settings({Key? key, required this.userId}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final InAppReview inAppReview = InAppReview.instance;
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    String userId = widget.userId;
    final userRepository = Provider.of<UserRepository>(context);
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Common',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: 'English',
              leading: Icon(Icons.language),
              onPressed: (context) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('The app is only available in English')));
              },
            ),
            SettingsTile(
              title: 'Encryption Key',
              subtitle: userId,
              leading: Icon(Icons.lock),
              onPressed: (context) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Encrypted - ' + userId)));
              },
            ),
            // CustomTile(
            //   child: Container(
            //     color: Color(0xFFEFEFF4),
            //     padding: EdgeInsetsDirectional.only(
            //       start: 14,
            //       top: 12,
            //       bottom: 30,
            //       end: 14,
            //     ),
            //     child: Text(
            //       'You can setup the language you want',
            //       style: TextStyle(
            //         color: Colors.grey.shade700,
            //         fontWeight: FontWeight.w400,
            //         fontSize: 13.5,
            //         letterSpacing: -0.5,
            //       ),
            //     ),
            //   ),
            // ),
            SettingsTile(
              title: 'Data',
              subtitle: 'Encrypted',
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Data'),
                        content: Text(
                            'Your Data Has Been Protected by using State of The Art Google Firebase servers which makes it imposiible to tamper with them .' +
                                '\n' +
                                '\n' +
                                '- The Creator is commited to protect your data'),
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
              },
              leading: Icon(
                Icons.cloud_queue,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Data'),
                          content: Text(
                              'We Are So Sorry To See You Go .In Order To Delete Your Account,You have to Send us Your Unique User Id which is given in the Settings Page and email it to lovelylpu@yahoo.com   ,' +
                                  '\n' +
                                  '\n' +
                                  '- Click on Copy Unique Id To copy it to Your ClipBoard'),
                          actions: [
                            TextButton(
                              child: Text("Copy-Id"),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: userId));
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Copied - ' + userId)));
                              },
                            ),
                          ],
                        );
                      });
                },
                title: 'Delete Account ',
                leading: Icon(Icons.account_circle)),
            SettingsTile(
              title: 'Email to Lovely ',
              leading: Icon(Icons.email),
              onPressed: (context) async {
                const url = 'mailto:lovelylpu@yahoo.com';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            SettingsTile(
              title: 'Sign out',
              leading: Icon(Icons.exit_to_app),
              onPressed: (context) {
                userRepository.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Security',
          tiles: [
            // SettingsTile.switchTile(
            //   title: 'Lock app in background',
            //   leading: Icon(Icons.phonelink_lock),
            //   switchValue: lockInBackground,
            //   onToggle: (bool value) {
            //     setState(() {
            //       lockInBackground = value;
            //       notificationsEnabled = value;
            //     });
            //   },
            // ),
            // SettingsTile.switchTile(
            //   title: 'Use fingerprint',
            //   subtitle: 'Allow application to access stored fingerprint IDs.',
            //   leading: Icon(Icons.fingerprint),
            //   onToggle: (bool value) {},
            //   switchValue: false,
            // ),
            // SettingsTile.switchTile(
            //   title: 'Change password',
            //   leading: Icon(Icons.lock),
            //   switchValue: true,
            //   onToggle: (bool value) {},
            // ),
            SettingsTile.switchTile(
              title: 'Enable Notifications',
              enabled: notificationsEnabled,
              leading: Icon(Icons.notifications_active),
              switchValue: true,
              onToggle: (value) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Misc',
          tiles: [
            SettingsTile(
                title: 'Terms of Service',
                leading: Icon(Icons.description),
                onPressed: (context) async {
                  const url =
                      'https://lovelylpu.wixsite.com/lovelylpu/down-for-maintenance';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
            SettingsTile(
              title: 'Licenses',
              leading: Icon(Icons.collections_bookmark),
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Data'),
                        content: Text(
                            'The app is Liscensed to Lovely Lpu Creator SkyLark.' +
                                '\n' +
                                '\n' +
                                'The Creator'),
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
              },
            ),
            SettingsTile(
                title: 'About The Creator',
                leading: Icon(Icons.info),
                onPressed: (context) async {
                  const url = 'https://lovelylpu.wixsite.com/lovelylpu/about-5';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
            SettingsTile(
                title: 'Rate - Us',
                leading: Icon(FontAwesomeIcons.appStore),
                onPressed: (context) async {
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                }),
            SettingsTile(
                title: 'Share This App',
                leading: Icon(FontAwesomeIcons.share),
                onPressed: (context) async {
                  Share.share(
                      'Check out this Awesome Lovely App :https://play.google.com/store/apps/details?id=com.lovelyLpu.lovely',
                      subject: 'Lovely LPU App');
                }),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Image.asset(
                  'assets/settings.png',
                  height: 50,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              ),
              Text(
                'Version: 1.0.4 (4)',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
