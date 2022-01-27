// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class InfoHub extends StatefulWidget {
  const InfoHub({ Key? key }) : super(key: key);

  @override
  _InfoHubState createState() => _InfoHubState();
}

class _InfoHubState extends State<InfoHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Info Hub'),
        centerTitle: true,
        elevation: 0.0, // remove drop shadow
      ), 
      body: Text('Info Hub Screen'), 
    );
  }
}