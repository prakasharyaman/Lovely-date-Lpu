import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:lovely/repositories/matchesRepository.dart';
import 'package:lovely/repositories/profileRepository.dart';
import 'package:lovely/repositories/searchRepository.dart';
import 'package:lovely/repositories/userRepository.dart';
import 'package:lovely/ui/pages/home.dart';
import 'package:provider/provider.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(Lovely());
}

class Lovely extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserRepository.instance(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileRepository(),
        ),
        ChangeNotifierProvider(create: (context) => MatchesRepository()),
        ChangeNotifierProvider(
          create: (context) => SearchRepository(),
        )
      ],
      child: MaterialApp(
        theme: FlexColorScheme.light(scheme: FlexScheme.sakura).toTheme,
        // The Mandy red, dark theme.
        darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mandyRed).toTheme,
        home: Home(),
      ),
    );
  }
}
// }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:lovely/ui/pages/home.dart';
// import 'package:lovely/ui/widgets/signInThroughPhone.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         debugShowCheckedModeBanner: false,
//         home: InitializerWidget());
//   }
// }

// class InitializerWidget extends StatefulWidget {
//   @override
//   _InitializerWidgetState createState() => _InitializerWidgetState();
// }

// class _InitializerWidgetState extends State<InitializerWidget> {
//   FirebaseAuth? _auth;

//   User? _user;

//   bool isLoading = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _auth = FirebaseAuth.instance;
//     _user = _auth!.currentUser;
//     isLoading = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//         : _user == null
//             ? PhoneLogin()
//             : Home();
//   }
// }
