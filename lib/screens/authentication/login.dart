// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fyp_app/services/auth.dart';
import 'package:fyp_app/shared/constants.dart';

class Login extends StatefulWidget {
  // const Login({ Key? key }) : super(key: key);

  final Function toggleView;
  Login({ required this.toggleView });  // constructor

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(4, 98, 126,1.0),
        elevation: 0.0,
        title: Text('Login to App'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: TextButton.icon(
              onPressed: () {
                widget.toggleView();
              }, 
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
              ),
              label: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              // Email text field:
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email.' : null,
                onChanged: (val) {  
                  // val represents whatever is in the form field
                  // onChanged means everytime something is typed or deleted from the form field
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              // Password text field:
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password with length of more than 6 characters.' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = 'Could not sign in with those credentials.');
                    }
                    print(email);
                    print(password);
                  }
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Login'),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber[800]),
                  textStyle: MaterialStateProperty.all(TextStyle(color:Colors.white))
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize:14.0),
              ),
            ],
            ),
        )
        // child: ElevatedButton(
        //   child: Text('Login Anon'),
        //   onPressed: () async { //async task to login
        //     dynamic result = await _auth.signInAnon();
        //     // it will try to sign in, wait to resolve and pass back to result
        //     if (result == null) {
        //       print('error signing in');
        //     } else {
        //       print('signed in');
        //       print(result.uid);
        //     }
        //   },
        // ),
      )
    );
  }
}