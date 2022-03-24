// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fyp_app/models/therapist_location_model.dart';
import 'package:fyp_app/models/time_slot_model.dart';
import 'package:fyp_app/models/user_model.dart';
import 'package:fyp_app/services/therapist_location_services.dart';
import 'package:fyp_app/services/time_slot_services.dart';
import 'package:fyp_app/services/user_services.dart';
import 'package:im_stepper/stepper.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart";
// import 'dart:async';

// enum userType { patient, therapist }
// FirebaseAuth auth = FirebaseAuth.instance;
// User? _user = auth.currentUser;
late TherapistLocationModel _therapistLocation;
class Appointment extends StatefulWidget {
  const Appointment({ Key? key }) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

enum Mode { virtual, physical }

class _AppointmentState extends State<Appointment> {
  UserModel _currentUser = UserModel();
  // userType _currentUserType = userType.patient;
  // final String? _currentUserEmail = _user!.email;

  int activeStep = 0;
  int upperBound = 3;

  String _chosenAppointmentMode = "";
  
  List<UserModel> _therapistList = [];
  List<TimeSlotModel> _timeSlotList = [];
  List<TimeSlotModel> _appointmentList = [];
  List<String> _displayNameList = [];
  String _chosenTherapistDisplayName = "";
  String _chosenTherapistEmail = "";
  String _chosenTimeSlotDay = "";
  int _chosenTimeSlotTime = 0;

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
  void initState() {
    setState(() {
      _chosenAppointmentMode = "V";
    });
    super.initState();
  }

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
    getAppointmentList();
    getDisplayNameFromEmail(_appointmentList);
    if(_currentUser.type == 'P') {
      return outputForPatient();
    }
    else {  //_currentUser.type == 'T'
      return outputForTherapist();
    }
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
              color: Color.fromRGBO(107,180,186,0.6),
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
                      fontSize: 22,
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
    if(_currentUser.type == 'P') {
      if(_appointmentList.isNotEmpty) {
        return 'Your Appointment:';
      }
      else {  //_appointmentList.isEmpty
        switch (activeStep) {
          case 1:
            return 'Choose your Therapist';

          case 2:
            return 'Choose a Time Slot';

          case 3:
            return 'Choose Mode of Appointment';

          default:
            return 'Book an Appointment';
        }
      }
    }
    else {  //_currentUser.type == 'T'
      return 'Your Appointment(s):';
    }
  }

  // Returns the body based on the activeStep.
  Widget body() {
    switch (activeStep) {
      case 1:
        getTherapists();
        return therapistList(_therapistList);
        
      case 2:
        getTimeSlots();
        return timeSlotList(_timeSlotList);

      case 3:
        return appointmentMode();

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

  // Returns the buttons widget
  Widget buttons() {
    if (activeStep == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(),
            flex: 1,
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
            flex: 5,
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                    title: Icon(
                      Icons.check_circle_rounded,
                      size: 50,
                      color: Colors.green.shade600,
                    ),
                    content: Text(
                      'Are you sure you want to book this appointment?',
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
                        onPressed: () {
                          Navigator.pop(context, 'Confirm');

                          final snackBar = SnackBar(
                            content: Text('Appointment booked successfully!'),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          bookTimeSlots();
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
              // => bookTimeSlots(),
              child: Text('Confirm'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade600),
              ),
            ),
            flex: 5,
          ),
          Expanded(
            child: SizedBox(),
            flex: 1,
          ),
        ],
      );
    }
    else {
      return Row(
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

  Widget outputForPatient() {
    if(_appointmentList.isNotEmpty) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color.fromRGBO(240,240,235,1.0),
          body: Column(
            children: [
              SizedBox(height: 25),
              header(),
              Expanded(
                // flex: 6,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: patientAppointmentList(_appointmentList),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {  //_appointmentList.isEmpty
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color.fromRGBO(240,240,235,1.0),
          body: Column(
            children: [
              SizedBox(height: 10),
              NumberStepper(
                activeStep: activeStep,  // this is the default actually
                numbers: [1,2,3,4],
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
                    child: buttons(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget outputForTherapist() {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(240,240,235,1.0),
        body: Column(
          children: [
            SizedBox(height: 25),
            header(),
            Expanded(
              // flex: 6,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                child: therapistAppointmentList(_appointmentList),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getTherapists() async {
    List<UserModel> therapistList = await UserService().getAllTherapists();
    
    if(mounted){
      setState(() {
        _therapistList = therapistList;
      });
    }
  }

  // Returns the Therapist List widget
  Widget therapistList(List<UserModel> therapists) {
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
                  "Dr. " + data.displayName!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.arrow_right_circle_fill,
                        color: Color.fromRGBO(4, 98, 126,0.8),
                        size: 30,
                      ),
                      onPressed: () { 
                        getLocationByTherapistEmail(data.email!);
                        _chosenTherapistDisplayName = data.displayName!;
                        _chosenTherapistEmail = data.email!;
                        activeStep++; 
                      }
                    ),
                  ],
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
    List<TimeSlotModel> timeSlotList = await TimeSlotService().getAvailableTimeSlots(_chosenTherapistEmail);
    
    if(mounted){
      setState(() {
        _timeSlotList = timeSlotList;
      });
    }
  }

  // Returns the Therapist List widget
  Widget timeSlotList(List<TimeSlotModel> timeSlots) {
    List<Widget> list = <Widget>[];

    list.add(Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Dr. ' + _chosenTherapistDisplayName + '\'s available time slot(s):',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ));

    if (timeSlots.isEmpty) {
      list.add(Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              'There are currently no available time slots.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.red[600],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ));
    }
    
    for (var data in timeSlots) {
      String time = timeFormatting(data.time);

      list.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  data.day!.substring(2),
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
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _chosenTimeSlotDay = data.day!;
                        _chosenTimeSlotTime = data.time!;
                        activeStep++; 
                        // showDialog<String>(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) => AlertDialog(
                        //     title: Icon(
                        //       Icons.check_circle_rounded,
                        //       size: 50,
                        //       color: Colors.green.shade600,
                        //     ),
                        //     content: Text(
                        //       'Are you sure you want to book this time slot?',
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //       ),
                        //     ),
                        //     actions: <Widget>[
                        //       TextButton(
                        //         onPressed: () => Navigator.pop(context, 'Cancel'),
                        //         child: Text(
                        //           'Cancel',
                        //           style: TextStyle(
                        //             fontSize: 16,
                        //           ),
                        //         ),
                        //       ),
                        //       TextButton(
                        //         onPressed: () {
                        //           Navigator.pop(context, 'Confirm');

                        //           final snackBar = SnackBar(
                        //             content: Text('Appointment booked successfully!'),
                        //             action: SnackBarAction(
                        //               label: 'Close',
                        //               onPressed: () {},
                        //             ),
                        //           );
                        //           ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        //           bookTimeSlots();
                        //         },
                        //         child: Text(
                        //           'Confirm',
                        //           style: TextStyle(
                        //             fontSize: 17,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
                      }, 
                      child: Text('Select'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade600),
                      ),
                    ),
                  ],
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

  // Returns the widget for Mode of Appointment
  Widget appointmentMode() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Choose your preferred mode of appointment:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              // Mode of Appointment radio buttons
              Row(
                children: <Widget>[
                  Radio<String>(
                    activeColor: Colors.teal.shade600,
                    value: "V",
                    groupValue: _chosenAppointmentMode,
                    onChanged: (String? value) {
                      setState(() {
                        _chosenAppointmentMode = value!;
                      });
                    },
                  ),
                  Text('Virtual'),
                  SizedBox(width: 30.0),
                  Radio<String>(
                    activeColor: Colors.teal.shade600,
                    value: "P",
                    groupValue: _chosenAppointmentMode,
                    onChanged: (String? value) {
                      setState(() {
                        _chosenAppointmentMode = value!;
                      });
                    },
                  ),
                  Text('Physical'),
                ],
              ),
              SizedBox(height: 5),
              Text('Therapist: ' + _chosenTherapistDisplayName, style: TextStyle(fontSize: 18,)),
              SizedBox(height: 5),
              Text('Time Slot: ' + _chosenTimeSlotDay.substring(2) + ', ' + timeFormatting(_chosenTimeSlotTime), style: TextStyle(fontSize: 18,)),
              SizedBox(height: 5),
              Text('Mode: ' + (_chosenAppointmentMode == 'V' ? 'Virtual' : 'Physical'), style: TextStyle(fontSize: 18,)),
              SizedBox(height: 15),
              virtualOrPhysical(),
            ],
          ),
        ),
      ),
    );
  }

  // Returns a widget depending on whether the mode of appointment chosen is Virtual or Physical
  Widget virtualOrPhysical() {
    if (_chosenAppointmentMode == 'V') {
      return SizedBox();
    }
    else {  //_chosenAppointmentMode == 'P'
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Location: ' + _therapistLocation.location!, style: TextStyle(fontSize: 18,)),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Location()),
              );
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(4, 98, 126, 0.8)),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0)),
            ),
            label: Text('View Location on Map'),
            icon: Icon(Icons.map_outlined),
            // child: Container(margin: EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 3.0), child: Text('View Location on Map')),
          ),
        ],
      );
    }
  }
  
  Future bookTimeSlots() async {
    await TimeSlotService().bookTimeSlot(_chosenTherapistEmail, _chosenTimeSlotDay, _chosenTimeSlotTime, _chosenAppointmentMode);
  }

  Future getAppointmentList() async {
    List<TimeSlotModel> appointmentList = [];
    appointmentList = await TimeSlotService().getAppointmentList(_currentUser.type);
    
    if (mounted) {
      setState(() {
        _appointmentList = appointmentList;
      });
    }
  }

  // Returns the Patient's Appointment List widget
  Widget patientAppointmentList(List<TimeSlotModel> appointments) {
    if(_appointmentList.isNotEmpty) {
      List<Widget> list = <Widget>[];

      appointments.asMap().forEach((index, data) {
        String time = timeFormatting(data.time);
        if (_displayNameList.length == _appointmentList.length) {
          list.add(Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Dr. ' + _displayNameList[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    subtitle: Text(
                      data.day!.substring(2) + '\n' + time + '\nMode: ' + (data.mode! == 'V' ? 'Virtual' : 'Physical'),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
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
                                  'Are you sure you want to cancel this appointment?',
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
                                    onPressed: () {
                                      Navigator.pop(context, 'Confirm');

                                      final snackBar = SnackBar(
                                        content: Text('Appointment canceled successfully!'),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      
                                      if (mounted) {
                                        setState(() {
                                          activeStep = 0;
                                        });
                                      }

                                      cancelAppointment(data.therapist_email, data.booked_by, data.day, data.time);
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
                          child: Text('Cancel'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade600),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
      });
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
    else {  //_appointmentList.isEmpty
      return Scaffold(
        backgroundColor: Color.fromRGBO(240,240,235,1.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have no appointments!',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  // Returns the Therapist's Appointments List widget
  Widget therapistAppointmentList(List<TimeSlotModel> appointments) {
    if(_appointmentList.isNotEmpty) {
      List<Widget> list = <Widget>[];

      appointments.asMap().forEach((index, data) {
        String time = timeFormatting(data.time);
        if (_displayNameList.length == _appointmentList.length) {
          list.add(Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Patient: ' + _displayNameList[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    subtitle: Text(
                      data.day!.substring(2) + '\n' + time + '\nMode: ' + (data.mode! == 'V' ? 'Virtual' : 'Physical'),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
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
                                  'Are you sure you want to cancel this appointment?',
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
                                    onPressed: () {
                                      Navigator.pop(context, 'Confirm');

                                      final snackBar = SnackBar(
                                        content: Text('Appointment canceled successfully!'),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                      cancelAppointment(data.therapist_email, data.booked_by, data.day, data.time);
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
                          child: Icon(CupertinoIcons.delete_solid, size:22),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade600),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
      });
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
    else {  //_appointmentList.isEmpty
      return Scaffold(
        backgroundColor: Color.fromRGBO(240,240,235,1.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have no appointments!',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  // Function to cancel an appointment
  Future cancelAppointment(String? therapistEmail, String? patientEmail, String? day, int? time) async {
    await TimeSlotService().cancelAppointment(therapistEmail!, patientEmail!, day!, time!);
  }

  // Function to get display name from email
  Future getDisplayNameFromEmail(List<TimeSlotModel> appointmentList) async{
    List<String> displayNameList = [];
    if (_currentUser.type == 'P') {
      for (var data in appointmentList) {
        String displayName = await UserService().getDisplayNameFromEmail(data.therapist_email!);
        displayNameList.add(displayName);
      }
    }
    else {  //_currentUser.type == 'T'
      for (var data in appointmentList) {
        String displayName = await UserService().getDisplayNameFromEmail(data.booked_by!);
        displayNameList.add(displayName);
      }
    }
    
    if(mounted){
        setState(() {
          _displayNameList = displayNameList;
        });
      }
  }

  // Function to get therapist's location by their email
  Future getLocationByTherapistEmail(String therapistEmail) async {
    TherapistLocationModel therapistLocation;
    therapistLocation = await TherapistLocationService().getLocationByTherapistEmail(therapistEmail);
    if (mounted) {
      setState(() {
        _therapistLocation = therapistLocation;
      });
    }
  }

  // Function for time formatting
  String timeFormatting(int? time) {
    String startTime = "";
    String endTime = "";
    String hour = "";
    String minute = "";
    String amPm = "am";

    // Time formatting
    if (time! < 1300) {
      if (time >= 1200) {
        amPm = "pm";
      }
      startTime = (time).toString();
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
    if ( (time + 0200) < 1300 ) {
      if (time + 0200 >= 1200) {
        amPm = "pm";
      }
      endTime = (time + 0200).toString();
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

    if (time >= 1300) {
      if (time >= 1200) {
        amPm = "pm";
      }
      startTime = (time - 1200).toString();
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
    if ( (time + 0200) >= 1300 ) {
      if (time + 0200 >= 1200) {
        amPm = "pm";
      }
      endTime = (time - 1200 + 0200).toString();
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

    return (startTime + " - " + endTime);
  }

}

class Location extends StatefulWidget {
  const Location({ Key? key }) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // LatLng initialCenter = LatLng(3.1076865826032387, 101.47808749998136);
  LatLng initialCenter = LatLng(_therapistLocation.latitude!, _therapistLocation.longitude!);
  late LatLng currentCenter;
  double currentZoom = 16.0;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    currentCenter = initialCenter;
  }

  void _zoomIn() {
    if (currentZoom < 18.0) {
      currentZoom = currentZoom + 1;
    }
    mapController.move(currentCenter, currentZoom);
  }

  void _zoomOut() {
    currentZoom = currentZoom - 1;
    mapController.move(currentCenter, currentZoom);
  }

  void _recenter() {
    currentCenter = initialCenter;
    mapController.move(currentCenter, currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    print('Location: ' + _therapistLocation.location!);
    print('Latitude: ' + _therapistLocation.latitude.toString());
    print('Longitude: ' + _therapistLocation.longitude.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Location of Chosen Therapist'),
        backgroundColor: Color.fromRGBO(4, 98, 126, 1.0),
      ),
      body: Stack(
        children: <Widget>[ 
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentCenter,
              zoom: currentZoom,
              maxZoom: 18.0,
              interactiveFlags: InteractiveFlag.drag,
              onPositionChanged: (mapPosition, boolValue) => currentCenter = mapPosition.center!,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    rotate: false,
                    width: 80.0,
                    height: 80.0,
                    point: initialCenter,
                    builder: (ctx) =>
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 1.0,
                            top: 2.0,
                            child: Icon(Icons.location_on, color: Colors.black54, size: 40,),
                          ),
                          Icon(Icons.location_on, color: Colors.red[600], size: 40,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            // add your floating action button
            child: Container(
              margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    tooltip: 'Zoom In',
                    mini: true,
                    onPressed: () => _zoomIn(),
                    child: Icon(Icons.add_rounded, size: 30),
                    heroTag: null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    backgroundColor: Color.fromRGBO(4, 98, 126, 0.8),
                  ),
                  FloatingActionButton(
                    tooltip: 'Zoom Out',
                    mini: true,
                    onPressed: () => _zoomOut(),
                    child: Icon(Icons.remove_rounded, size: 30),
                    heroTag: null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    backgroundColor: Color.fromRGBO(4, 98, 126, 0.8),
                  ),
                  SizedBox(height: 13.0),
                  FloatingActionButton(
                    tooltip: 'Re-center',
                    onPressed: () => _recenter(),
                    child: Icon(Icons.my_location_rounded, size: 30),
                    heroTag: null,
                    backgroundColor: Color.fromRGBO(4, 98, 126, 0.8),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}