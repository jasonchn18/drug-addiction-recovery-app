// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/authentication/login.dart';
import 'package:fyp_app/screens/authentication/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key }) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
    // reverse the current state of showSignIn
  }

  @override
  Widget build(BuildContext context) {
      if (showSignIn) {
        return Login(toggleView: toggleView);
      }
      else {
        return Register(toggleView: toggleView);
      }
    // return Scaffold(
    //   backgroundColor: Color.fromRGBO(240,240,235,1.0),
    //   body: SafeArea(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start, // align column's children to the left
    //       children: <Widget>[
    //         Login(),
    //       ],
    //     ),
    //   ),
    // );
  }
}