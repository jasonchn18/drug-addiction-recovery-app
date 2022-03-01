// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fyp_app/services/auth.dart';
import 'package:fyp_app/shared/constants.dart';
import 'package:fyp_app/shared/loading.dart';

class Register extends StatefulWidget {
  // const Register({ Key? key }) : super(key: key);

  final Function toggleView;
  Register({ required this.toggleView });  // constructor

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String displayName = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(4, 98, 126,0.8),
        elevation: 0.0,
        title: Text('Register to App'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: TextButton.icon(
              onPressed: () {
                // if use this.toggleView, it refer to state object but toggleView is not in the state object
                widget.toggleView();
              }, 
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Form(
          key: _formKey,  // associating the GlobalKey with our form
          // to keep track of the state of the form and access validation techniques
          child: SingleChildScrollView(   // to fix renderflex error when keyboard opens
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                // Display Name text field:
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Display Name'),
                  validator: (val) => val!.isEmpty ? 'Enter a Display Name.' : null,
                  onChanged: (val) {  
                    // val represents whatever is in the form field
                    // onChanged means everytime something is typed or deleted from the form field
                    setState(() => displayName = val);
                  },
                ),
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
                  validator: (val) => val!.length < 6 ? 'Enter a password with length of more than 6 characters.' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // if receive null value only continue
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(displayName, email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Please supply a valid email.';
                          loading = false;
                        });
                      }
                      print(email);
                      print(password);
                    }
                  }, 
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Register'),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber[600]),
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
          ),
        )
      )
    );
  }
}