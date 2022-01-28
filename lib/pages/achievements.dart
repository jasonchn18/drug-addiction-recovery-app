// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Achievements extends StatefulWidget {
  const Achievements({ Key? key }) : super(key: key);

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align column's children to the left
          children: <Widget>[
            TextButton.icon(
              onPressed: () {}, 
              icon: Icon(
                Icons.collections_bookmark_rounded,
                color: Colors.black,
              ),
              label: Text(
                'Achievements screen',
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