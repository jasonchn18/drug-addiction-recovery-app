// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:fyp_app/pages/home.dart';
import 'package:fyp_app/pages/infohub.dart';
import 'package:fyp_app/pages/achievements.dart';
import 'package:fyp_app/pages/community.dart';
import 'package:fyp_app/pages/chat.dart';

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

void main() {
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
    return MaterialApp(
      initialRoute: '/app',
      routes: {
        '/app': (context) => App(),
        // '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/infohub': (context) => InfoHub(),
        '/article': (context) => Article(),
        '/achievements': (context) => Achievements(),
        '/community': (context) => Community(),
        '/chat': (context) => Chat(),
      },
      debugShowCheckedModeBanner: false,  // to hide debug logo at top right of screen when debugging
    );
  }
}