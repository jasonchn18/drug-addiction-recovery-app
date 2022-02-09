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
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align column's children to the left
          children: <Widget>[
            TextButton.icon(
              onPressed: () {
                // Navigator.pushNamed(context, '/home');
              }, 
              icon: Icon(
                Icons.home_rounded,
                color: Colors.black,
              ),
              label: Text(
                'Home screen',
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