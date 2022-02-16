// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/authentication/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:fyp_app/models/the_user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<TheUser?>(context);
    print(user);

    // return either Home or Authentication widget
    return Authenticate();
  }
}