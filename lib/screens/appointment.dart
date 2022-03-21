// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fyp_app/models/time_slot_model.dart';
import 'package:fyp_app/models/user_model.dart';
import 'package:fyp_app/services/time_slot_services.dart';
import 'package:fyp_app/services/user_services.dart';
import 'package:im_stepper/stepper.dart';
// import 'dart:async';

// enum userType { patient, therapist }
// FirebaseAuth auth = FirebaseAuth.instance;
// User? _user = auth.currentUser;
class Appointment extends StatefulWidget {
  const Appointment({ Key? key }) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  UserModel _currentUser = UserModel();
  // userType _currentUserType = userType.patient;
  // final String? _currentUserEmail = _user!.email;

  int activeStep = 0;
  int upperBound = 2;
  
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
    else {  //_hasAppointment == false
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
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ));
    
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
                trailing: ElevatedButton(
                  onPressed: () {
                    _chosenTimeSlotDay = data.day!;
                    _chosenTimeSlotTime = data.time!;
                    // bookTimeSlots();
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
                          'Are you sure you want to book this time slot?',
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
  
  Future bookTimeSlots() async {
    await TimeSlotService().bookTimeSlot(_chosenTherapistEmail, _chosenTimeSlotDay, _chosenTimeSlotTime);
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
                      data.day!.substring(2) + '\n' + time,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: ElevatedButton(
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
    else {
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
                      data.day!.substring(2) + '\n' + time,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: ElevatedButton(
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
    else {
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

  Future cancelAppointment(String? therapistEmail, String? patientEmail, String? day, int? time) async {
    await TimeSlotService().cancelAppointment(therapistEmail!, patientEmail!, day!, time!);
  }

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