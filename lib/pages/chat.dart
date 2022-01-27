// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({ Key? key }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Chat'),
        centerTitle: true,
        elevation: 0.0, // remove drop shadow
      ), 
      body: Text('Chat Screen'),
    );
  }
}