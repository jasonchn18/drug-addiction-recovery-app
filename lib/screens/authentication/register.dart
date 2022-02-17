// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fyp_app/services/auth.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  // Text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Register to App'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            // Email text field:
            TextFormField(
              onChanged: (val) {  
                // val represents whatever is in the form field
                // onChanged means everytime something is typed or deleted from the form field
                setState(() => email = val);
              },
            ),
            SizedBox(height: 20.0),
            // Password text field:
            TextFormField(
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                print(email);
                print(password);
              }, 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Register'),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink[400]),
                textStyle: MaterialStateProperty.all(TextStyle(color:Colors.white))
              ),
            ),
          ],
        )
      )
    );
  }
}