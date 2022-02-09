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
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align column's children to the left
          children: <Widget>[
            TextButton.icon(
              onPressed: () {}, 
              icon: Icon(
                Icons.chat_rounded,
                color: Colors.black,
              ),
              label: Text(
                'Chat screen',
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