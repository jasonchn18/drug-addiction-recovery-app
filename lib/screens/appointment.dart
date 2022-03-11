// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:im_stepper/stepper.dart';
// import 'dart:async';

class Appointment extends StatefulWidget {
  const Appointment({ Key? key }) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  int activeStep = 0;
  int upperBound = 2;
  
  List<DocumentSnapshot> _therapists = [];
  List<DocumentSnapshot> _time_slots = [];
  String _chosenTherapistDisplayName = "";
  String _chosenTherapistEmail = "";
  String _chosenTimeSlotDay = "";
  int _chosenTimeSlotTime = 0;

  Stream<DocumentSnapshot> snapshot =  FirebaseFirestore.instance.collection("users").doc('qDRHNNU6sxOCPNXFpvbGmdMqm3w1').snapshots();

  void _prevButtonAction() {
    setState(() {
      activeStep--;
    });
  }

  void _startButtonAction() {
    setState(() {
      activeStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(240,240,235,1.0),
        body: Column(
          children: [
            SizedBox(height: 10),
            NumberStepper(
              activeStep: activeStep,  // this is the default actually
              numbers: [1,2,3],
              direction: Axis.horizontal,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              stepColor: Color.fromRGBO(134,148,133,1),
              activeStepColor: Color.fromRGBO(4, 98, 126,1.0),
              numberStyle: TextStyle(color: Colors.white),
              onStepReached:(index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            SizedBox(height: 20),
            header(),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: body(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(),
                        flex: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: activeStep == 0 ? ()=>_startButtonAction() : ()=>_prevButtonAction(),
                          child: Text(buttonText()),
                          style: ButtonStyle(
                            backgroundColor: activeStep == 0 ?
                              MaterialStateProperty.all<Color>(Colors.teal.shade600) : MaterialStateProperty.all<Color>(Color.fromRGBO(4, 98, 126, 0.8)),
                          ),
                        ),
                        flex: 11,
                      ),
                      Expanded(
                        child: SizedBox(),
                        flex: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Returns the header wrapping the header text.
  Widget header() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 9,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(107,180,186,0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    headerText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Choose your Therapist';

      case 2:
        return 'Choose a Time Slot';

      default:
        return 'Book an Appointment';
    }
  }

  // Returns the body based on the activeStep.
  Widget body() {
    switch (activeStep) {
      case 1:
        getTherapists();
        return therapistList(_therapists);
      case 2:
        getTimeSlots();
        return timeSlotList(_time_slots);
        // return Scaffold(
        //   backgroundColor: Color.fromRGBO(240,240,235,1.0),
        //   body: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         'Chosen therapist: $_chosenTherapistDisplayName $_chosenTherapistEmail',
        //         style: TextStyle(
        //           fontSize: 15,
        //         ),
        //       ),
        //     ],
        //   ),
        // );

      default:
        return Scaffold(
          backgroundColor: Color.fromRGBO(240,240,235,1.0),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15,5,15,5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'To book an appointment with a therapist, \nall you have to do is pick the therapist of your choice and choose any time slots that are available!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  // Returns the header text based on the activeStep.
  String buttonText() {
    if (activeStep == 0) {
      return "Start";
    }
    else {
      return "Previous";
    }
  }

  // Returns the Therapist List widget
  Widget therapistList(List<DocumentSnapshot> therapists) {
    List<Widget> list = <Widget>[];
    for (var data in therapists) {
      list.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                dense: false,
                visualDensity: VisualDensity(horizontal: -4),
                leading: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.black54,
                  size: 30,
                ),
                title: Text(
                  "Dr. " + data.get('displayName'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Color.fromRGBO(4, 98, 126,0.8),
                  ),
                  onPressed: () { 
                    _chosenTherapistDisplayName = data.get('displayName');
                    _chosenTherapistEmail = data.get('email');
                    activeStep++; 
                  }
                ), 
              ),
            ],
          ),
        ),
      ));
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: list,
          ),
        ),
      ),
    );
  }

  Future getTherapists() async {
    List<DocumentSnapshot> docs = [];
    
    await FirebaseFirestore.instance.collection('users')
    .where("type",isEqualTo: "T")
    .orderBy("displayName")
    .get().then((query) {
        docs = query.docs;
    });

    setState(() {
      _therapists = docs;
    });
  }

  // Returns the Therapist List widget
  Widget timeSlotList(List<DocumentSnapshot> time_slots) {
    List<Widget> list = <Widget>[];

    list.add(Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Dr. ' + _chosenTherapistDisplayName + '\'s available time slot(s):',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ));
    
    for (var data in time_slots) {
      // int start_time = data.get('time');  //1000
      // int end_time = start_time + 0200;   //1200
      // String time = start_time.toString() + " - " + end_time.toString();
      String startTime = "";
      String endTime = "";
      String hour = "";
      String minute = "";
      String amPm = "am";

      // Time formatting
      if (data.get('time') < 1300) {
        if (data.get('time') >= 1200) {
          amPm = "pm";
        }
        startTime = (data.get('time')).toString();
        if(startTime.length == 3) {
          startTime = "0" + startTime;
        }
        if (startTime[0] == "0") {
          hour = startTime.substring(1,2);
        }
        else {
          hour = startTime.substring(0,2);
        }
        minute = startTime.substring(2,4);
        startTime = hour + "." + minute + amPm;
      }
      if ( (data.get('time') + 0200) < 1300 ) {
        if (data.get('time') + 0200 >= 1200) {
          amPm = "pm";
        }
        endTime = (data.get('time') + 0200).toString();
        if(endTime.length == 3) {
          endTime = "0" + endTime;
        }
        if (endTime[0] == "0") {
          hour = endTime.substring(1,2);
        }
        else {
          hour = endTime.substring(0,2);
        }
        minute = endTime.substring(2,4);
        endTime = hour + "." + minute + amPm;
      }

      if (data.get('time') >= 1300) {
        if (data.get('time') >= 1200) {
          amPm = "pm";
        }
        startTime = (data.get('time') - 1200).toString();
        if(startTime.length == 3) {
          startTime = "0" + startTime;
        }
        if (startTime[0] == "0") {
          hour = startTime.substring(1,2);
        }
        else {
          hour = startTime.substring(0,2);
        }
        minute = startTime.substring(2,4);
        startTime = hour + "." + minute + amPm;
      }
      if ( (data.get('time') + 0200) >= 1300 ) {
        if (data.get('time') + 0200 >= 1200) {
          amPm = "pm";
        }
        endTime = (data.get('time') - 1200 + 0200).toString();
        if(endTime.length == 3) {
          endTime = "0" + endTime;
        }
        if (endTime[0] == "0") {
          hour = endTime.substring(1,2);
        }
        else {
          hour = endTime.substring(0,2);
        }
        minute = endTime.substring(2,4);
        endTime = hour + "." + minute + amPm;
      }

      String time = startTime + " - " + endTime;

      list.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  data.get('day').substring(2),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                subtitle: Text(
                  time,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    _chosenTimeSlotDay = data.get('day');
                    _chosenTimeSlotTime = data.get('time');
                    setTimeSlots();
                  }, 
                  child: Text('Select'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: list,
          ),
        ),
      ),
    );
  }
  
  Future getTimeSlots() async {
    List<DocumentSnapshot> docs = [];
    
    await FirebaseFirestore.instance.collection('time_slots')
    .where("therapist_email",isEqualTo: _chosenTherapistEmail)
    .where("availability",isEqualTo: true)
    .orderBy("day")
    .orderBy("time")
    .get().then((query) {
      docs = query.docs;
    });

    if (mounted) {
      setState(() {
        _time_slots = docs;
      });
    }
  }
  
  Future setTimeSlots() async {
    // var db = FirebaseFirestore.instance;

    // db.collection("time_slots").doc(doc.id).update({foo: "bar"});

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    // print(user!.email);

    QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('time_slots')
      .where('therapist_email', isEqualTo: _chosenTherapistEmail)
      .where('day', isEqualTo: _chosenTimeSlotDay)
      .where('time', isEqualTo: _chosenTimeSlotTime)
      .get();
    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;
    await docRef.update({
      'availability': false,
      'booked_by': user!.email,
    });
  }
  
}

class Article extends StatelessWidget {
  const Article({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Title'),
        // centerTitle: true,
        backgroundColor: Color.fromRGBO(4, 98, 126,1.0),
        elevation: 0.0,
      ),
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: Text('article content'),
    );
  }
}