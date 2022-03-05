// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _chosenTherapistDisplayName = "";
  String _chosenTherapistEmail = "";

  Stream<DocumentSnapshot> snapshot =  FirebaseFirestore.instance.collection("users").doc('qDRHNNU6sxOCPNXFpvbGmdMqm3w1').snapshots();

  void _prevButtonAction() {
    setState(() {
      activeStep--;
    });
  }

  void _nextButtonAction() {
    if (activeStep == 0) {
      setState(() {
        activeStep++;
      });
    }
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
                      SizedBox(width: 30),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: activeStep > 0 ? ()=>_prevButtonAction() : null,
                          child: Text('Previous'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(4, 98, 126, 0.7)),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: activeStep != 1 ? ()=>_nextButtonAction() : null,
                          child: Text(
                            buttonText(),
                          ),
                          style: ButtonStyle(
                            backgroundColor: activeStep < upperBound ?
                              MaterialStateProperty.all<Color>(Color.fromRGBO(4, 98, 126, 0.7)) : MaterialStateProperty.all<Color>(Colors.teal.shade600),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
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
        return Scaffold(
          backgroundColor: Color.fromRGBO(240,240,235,1.0),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chosen therapist: $_chosenTherapistDisplayName $_chosenTherapistEmail',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );

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
      return "Submit";
    }
  }

  // Returns the Choose Therapist widget
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
    // int num = therapists.length;
    // return Text('la $num');
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: list,
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> getTherapists() async {
    List<DocumentSnapshot> docs = [];
    
    await FirebaseFirestore.instance.collection('users')
    .where("type",isEqualTo: "T")
    .get().then((query) {
        docs = query.docs;
    });

    setState(() {
      _therapists = docs;
    });

    return docs;
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