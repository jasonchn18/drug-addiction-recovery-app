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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Achievements'),
        centerTitle: true,
        elevation: 0.0, // remove drop shadow
      ), 
      body: Text('Achievements Screen'),
    );
  }
}