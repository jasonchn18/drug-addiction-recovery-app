// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/models/the_user.dart';
import 'package:fyp_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'wrapper.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/appointment.dart';
import 'package:fyp_app/screens/achievements.dart';
import 'package:fyp_app/screens/community.dart';
import 'package:fyp_app/screens/chat.dart';

// void main() {
//   runApp(MaterialApp(
//     initialRoute: '/home',
//     routes: {
//       // '/': (context) => Loading(),
//       '/home': (context) => Home(),
//       '/infohub': (context) => InfoHub(),
//       '/achievements': (context) => Achievements(),
//       '/community': (context) => Community(),
//       '/chat': (context) => Chat(),
//     },
//   ));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({ Key? key }) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (newIndex) => setState((){_currentIndex = newIndex;}),
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.add),
//               label: 'Info Hub'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.location_on),
//               label: 'Achievements'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.people),
//               label: 'Home'
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: <Widget>[
//           InfoHub(),
//           Achievements(),
//           Home(),
//         ],
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        // home: Wrapper(),
        initialRoute: '/wrapper',
        // initialRoute: '/app',
        routes: {
          '/app': (context) => App(),
          '/wrapper': (context) => Wrapper(),
          // '/': (context) => Loading(),
          '/home': (context) => Home(),
          '/appointment': (context) => Appointment(),
          '/achievements': (context) => Achievements(),
          '/community': (context) => Community(),
          '/chat': (context) => Chat(),
        },
        debugShowCheckedModeBanner: false,  // to hide debug logo at top right of screen when debugging
      ),
    );
  }
}