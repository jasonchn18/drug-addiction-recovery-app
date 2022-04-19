// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  String? _type = '😁';
  late int sober_days;

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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // UserList(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Icon(
                                    Icons.warning_amber_rounded,
                                    size: 50,
                                    color: Colors.red.shade600,
                                  ),
                                  content: Text(
                                    'Do you want to logout?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'No'),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context, 'Yes');

                                        final snackBar = SnackBar(
                                          content: Text('Logged out successfully.'),
                                          action: SnackBarAction(
                                            label: 'Close',
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        await _auth.signOut();
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }, 
                            icon: Icon(
                              Icons.person_rounded,
                              color: Colors.red[600],
                            ), 
                            label: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Align(
                  alignment: Alignment.center,
                  child: displayUserDisplayName(),
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Color.fromRGBO(220, 224, 242, 0.8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                            child: homeCard(),
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
      ),
    );
  }

  Widget displayUserDisplayName() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        child: Text(
          ( _currentUser.displayName != null ? 
            ( _currentUser.type == 'T' ? 
              ('Hi, Dr. ' + _currentUser.displayName!) 
              : ('Hi, ' + _currentUser.displayName!) 
            ) 
          : 'Hi!' ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
    // Text(
    //   ( _currentUser.displayName != null ? 
    //     ( _currentUser.type == 'T' ? 
    //       ('Hi, Dr. ' + _currentUser.displayName!) 
    //       : ('Hi, ' + _currentUser.displayName!) 
    //     ) 
    //     : 'Hi!' ),
    //   style: TextStyle(
    //     fontSize: 20,
    //     fontWeight: FontWeight.w600,
    //   ),
    // );
  }

  Widget homeCard() {
    if (_currentUser.type == 'P') {
      if (_currentUser.sober_days == null) {
        return uncheckedPatientHomeCard();
      }
      else {
        return checkedPatientHomeCard();
      }
    }
    else if (_currentUser.type == 'T') {
      return Column(
        children: <Widget>[
          Text(
            '(This section is for patients.)',
            style: TextStyle(
              color: Colors.red[700],
            ),
          ),
        ],
      );
    }
    else {
      return Column(
        children: <Widget>[
          SpinKitFadingCircle(
            color: Color.fromRGBO(4, 98, 126,1.0),
            size: 50.0,
          ),
        ],
      );
    }
  }

  Widget checkedPatientHomeCard() {
    return Column(
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            showDialog<String>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                title: Center(
                  child: Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  )
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Choose an emotion:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Radio<String>(
                            activeColor: Colors.amber[700],
                            value: '😁',
                            groupValue: _type,
                            onChanged: (String? value) {
                              setState(() {
                                _type = value;
                              });
                            },
                          ),
                          Text('😁'),
                          SizedBox(width: 25.0),
                          Radio<String>(
                            activeColor: Colors.amber[700],
                            value: '😢',
                            groupValue: _type,
                            onChanged: (String? value) {
                              setState(() {
                                _type = value;
                              });
                            },
                          ),
                          Text('😢'),
                          SizedBox(width: 25.0),
                          Radio<String>(
                            activeColor: Colors.amber[700],
                            value: '😡',
                            groupValue: _type,
                            onChanged: (String? value) {
                              setState(() {
                                _type = value;
                              });
                            },
                          ),
                          Text('😡'),
                        ],
                      ),
                      SizedBox(height: 30.0,),
                      Text(
                        'Write a description:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200)
                        ),
                        child: TextFormField(
                          minLines: 3,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Today, I ..."
                          ),
                          validator: (value) {
                            if(value!.isEmpty) {
                              return 'Please enter some description.';
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Opacity(
                      opacity: 0.8,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Confirm');

                      final snackBar = SnackBar(
                        content: Text('Checked in successfully!'),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }, 
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade600),
          ),
          icon: Icon(Icons.check_circle_outline_rounded,), 
          label: Text('Check In',),
        ),
        SizedBox(height: 15.0,),
        Text(
          'You have been sober/drug-free for:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        SizedBox(height: 12.0,),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 250.0,
              height: 250.0,
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(width: 11, color: Colors.teal.shade500),
                ),
              )
            ),
            Column(
              children: <Widget>[
                Text(
                  _currentUser.sober_days.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'days',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(
                        title: Icon(
                          Icons.warning_amber_rounded,
                          size: 50,
                          color: Colors.red.shade600,
                        ),
                        content: Text(
                          'Are you sure you want to reset your drug-free days?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, 'Confirm');

                              final snackBar = SnackBar(
                                content: Text('Drug-free days resetted successfully.'),
                                action: SnackBarAction(
                                  label: 'Close',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              _currentUser.sober_days = null;
                              await UserService().updateSoberDays(_currentUser);
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, 
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.red[600],
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget uncheckedPatientHomeCard() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'How many days have you been sober/drug-free (excluding today)?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              label: Center(child: Text('Enter a number'),),
              alignLabelWithHint: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers
            validator: (val) => val!.isEmpty ? 'Enter a number.' : null,
            onChanged: (val) {
              if(int.tryParse(val) != null) {
                setState(() => sober_days = int.parse(val));
              }
            },
          ),
          SizedBox(height: 15.0,),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _currentUser.sober_days = sober_days;
                await UserService().updateSoberDays(_currentUser);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Submit'),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amber[800]),
              textStyle: MaterialStateProperty.all(TextStyle(color:Colors.white))
            ),
          ),
        ],
      ),
    );
  }
  
}

// final _formKey = GlobalKey<FormState>();
// class Mood extends StatelessWidget {
//   const Mood({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(240, 240, 235, 1.0),
//       appBar: AppBar(
//         title: Text('Add New Time Slot'),
//         backgroundColor: Color.fromRGBO(4, 98, 126, 0.8),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 20.0),
//               // Email text field:
              
//               SizedBox(height: 20.0),
              
//               SizedBox(height: 20.0),
              
              
//               SizedBox(height: 30.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Navigator.of(context).pop();
//                   if (_formKey.currentState!.validate()) {
//                     showDialog<String>(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) => AlertDialog(
//                         title: Icon(
//                           Icons.event_available_rounded,
//                           size: 50,
//                           color: Colors.green.shade600,
//                         ),
//                         content: Text(
//                           'Are you sure you want to add this new time slot?',
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         ),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, 'Cancel'),
//                             child: Opacity(
//                               opacity: 0.8,
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context, 'Confirm');

//                               final snackBar = SnackBar(
//                                 content: Text('Time slot added successfully!'),
//                                 action: SnackBarAction(
//                                   label: 'Close',
//                                   onPressed: () {},
//                                 ),
//                               );
//                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                             },
//                             child: Text(
//                               'Confirm',
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 }, 
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Add Time Slot'),
//                 ),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.amber[800]),
//                   textStyle: MaterialStateProperty.all(TextStyle(color:Colors.white))
//                 ),
//               ),
//             ],
//           ),
//         )
//       )
//     );
//   }
// }