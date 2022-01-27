// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:fyp_app/pages/home.dart';
import 'package:fyp_app/pages/infohub.dart';
import 'package:fyp_app/pages/achievements.dart';
import 'package:fyp_app/pages/community.dart';
import 'package:fyp_app/pages/chat.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      // '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/infohub': (context) => InfoHub(),
      '/achievements': (context) => Achievements(),
      '/community': (context) => Community(),
      '/chat': (context) => Chat(),
    },
  ));
}