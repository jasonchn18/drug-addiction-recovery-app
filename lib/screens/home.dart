// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/models/user_model.dart';
import 'package:fyp_app/services/auth.dart';
import 'package:fyp_app/services/database.dart';
import 'package:fyp_app/services/user_services.dart';
import 'package:fyp_app/user_list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel _currentUser = UserModel();

  final AuthService _auth = AuthService();

  Future getCurrentUserData() async {
    UserModel user = await UserService().getCurrentUserData();
    if(mounted){
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  getCurrentUserData();
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid:'').users,
      initialData: null,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(240,240,235,1.0),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              UserList(),
              Column(
                children: [
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: displayUserDisplayName(),
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

  Widget displayUserDisplayName() {
    return Text(
      ( _currentUser.displayName != null ? 
        ( _currentUser.type == 'T' ? 
          ('Hi Dr. ' + _currentUser.displayName! + '!') 
          : ('Hi ' + _currentUser.displayName! + '!') ) 
        : 'Hi!' ),
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }
  
}