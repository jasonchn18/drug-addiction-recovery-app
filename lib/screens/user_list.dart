import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({ Key? key }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<QuerySnapshot?>(context);
    // print(brews.docs);
    if (users != null) {
      // for (var doc in users.docs) {
      //   print('print #1:');
      //   print(doc.data());
      // }
    }

    return Container(
      
    );
  }
}