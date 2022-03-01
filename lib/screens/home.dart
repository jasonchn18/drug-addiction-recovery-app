// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/auth.dart';
import 'package:fyp_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:fyp_app/screens/user_list.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid:'').users,
      initialData: null,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(240,240,235,1.0),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              UserList(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
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
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: TextButton.icon(
                          onPressed: () async {
                            await _auth.signOut();
                          }, 
                          icon: Icon(Icons.person), 
                          label: Text('Logout')
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}