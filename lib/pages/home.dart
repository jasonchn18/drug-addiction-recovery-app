// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align column's children to the left
          children: <Widget>[
            TextButton.icon(
              onPressed: () {}, 
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: Text(
                'Home page',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/infohub');
              }, 
              icon: Icon(
                Icons.menu_book_rounded,
                color: Colors.black,
              ),
              label: Text(
                'Go to Info Hub',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/achievements');
              }, 
              icon: Icon(
                Icons.celebration_outlined,
                color: Colors.black,
              ),
              label: Text(
                'Go to Achievements',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/community');
              }, 
              icon: Icon(
                Icons.group,
                color: Colors.black,
              ),
              label: Text(
                'Go to Community',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              }, 
              icon: Icon(
                Icons.chat_rounded,
                color: Colors.black,
              ),
              label: Text(
                'Go to Chat',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}