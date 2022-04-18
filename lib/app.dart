// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/appointment.dart';
import 'package:fyp_app/screens/tracking.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/community.dart';
import 'package:fyp_app/screens/chat.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 1;  // set initial 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Color.fromRGBO(4, 98, 126,1.0),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          // primaryColor: Colors.red,
          textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: TextStyle(color: Colors.yellow)) // sets the inactive color of the `BottomNavigationBar`
        ), 
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) => setState((){_currentIndex = newIndex;}),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.event_rounded),
                label: 'Appointment'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.collections_bookmark_rounded),
                label: 'Tracking'
            ),
          ],
          // selectedItemColor: Colors.amber[800],
          unselectedItemColor: Color.fromRGBO(240,240,235,1.0),
          selectedItemColor: Color.fromRGBO(248,221,145,1.0),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Appointment(),
          Home(),
          Tracking(),
        ],
      ),
    );
  }
}