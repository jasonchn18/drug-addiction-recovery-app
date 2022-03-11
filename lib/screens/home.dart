// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/auth.dart';
import 'package:fyp_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:fyp_app/user_list.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
String _displayName = "";

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

  Future getUserDisplayName() async {
    // String displayName = "";
    // var db = FirebaseFirestore.instance;
    // db.collection('users').doc(user!.uid).get();
    // var docRef = db.collection("users").doc(user!.uid);
    await FirebaseFirestore.instance.collection('users')
      .doc(user!.uid)
      .get().then((query) {
        _displayName = query.get('displayName');
      });

    // docRef.get().then((doc) => {
    //   if (doc.exists) {
    //     displayName = doc.get('displayName')
    //   }
    // });
    // return displayName;
  }

  Widget displayUserDisplayName() {
    getUserDisplayName();
    return Text(
      'Hi ' + _displayName,
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

}