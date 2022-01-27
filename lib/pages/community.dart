// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  const Community({ Key? key }) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Community'),
        centerTitle: true,
        elevation: 0.0, // remove drop shadow
      ), 
      body: Text('Community Screen'),
    );
  }
}