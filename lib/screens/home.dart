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

  final AuthService _auth = AuthService();
  String _displayName = "";

  @override
  Widget build(BuildContext context) {
  // print(_displayName);
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
    getUserDisplayName();
    return Text(
      // 'Hi ' + getUserDisplayName() + '!',
      'Hi' + _displayName + '!',
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

  Future getUserDisplayName() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    UserModel userData = await UserService().getCurrentUserData();
    // String displayName = '';

    // var db = FirebaseFirestore.instance;
    // db.collection('users').doc(user!.uid).get();
    // var docRef = db.collection("users").doc(user!.uid);
    // await FirebaseFirestore.instance.collection('users')
    // .doc(user!.uid)
    // .get().then((query) {
    //   if(query.get('type') == 'T') {
    //     displayName = 'Dr. ' + query.get('displayName');
    //   }
    //   else {
    //     displayName = query.get('displayName');
    //   }
    // });

    if (mounted) {
      setState(() {
        _displayName = ' ' + userData.displayName!;
      });
    }
    // var displayName = user!.displayName;
    
    // if(displayName != null){
    //   return displayName;
    // }
    // else {
    //   return '';
    // }

    // docRef.get().then((doc) => {
    //   if (doc.exists) {
    //     displayName = doc.get('displayName')
    //   }
    // });
    // return displayName;
  }

}