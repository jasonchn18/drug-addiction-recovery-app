// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:fyp_app/models/mood_details_model.dart';
import 'package:fyp_app/services/mood_services.dart';

class Tracking extends StatefulWidget {
  const Tracking({ Key? key }) : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  List<MoodDetailsModel> _moodList = [];

  @override
  Widget build(BuildContext context) {
    getMoodList();
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Mood Tracking',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: moodList(_moodList),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: tracking(_moodList),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> moodList(List<MoodDetailsModel> moodList) {
    List<Widget> list = <Widget>[];
    // Sort from newest to oldest mood entry
    _moodList.sort((a, b) => b.date!.compareTo(a.date!));

    list.add(SizedBox(height: 5.0,));

    _moodList.forEach((data) {
      list.add(Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ListTile(
            dense: false,
            visualDensity: VisualDensity(horizontal: -4),
            leading: Text(
              data.date!.toDate().toString().split(' ')[0],
            ),
            title: Text(
              data.description!,
            ),
            trailing: Text(
              data.emoji!,
              style: TextStyle(
                fontSize: 20,
              ),
            ), 
          ),
        ),
      ));
    });

    return list;
  }

  Future getMoodList() async {
    List<MoodDetailsModel> moodList = await MoodService().getMoodList();
    if (mounted) {
      setState(() {
        _moodList = moodList;
      });
    }
  }

  Widget tracking(List<MoodDetailsModel> moodList) {
    // Sort from newest to oldest mood entry
    moodList.sort((a, b) => b.date!.compareTo(a.date!));
    int badPoints = 0;

    // Check for bad moods/emotions in the last 14 days
    if(moodList.length > 14) {
      for(var i=0; i<14; i++) {
        if (moodList[i].emoji == '😢') {
          badPoints += 1;
        }
        else if (moodList[i].emoji == '😡') {
          badPoints += 2;
        }
      }
    }
    else {
      for(var i=0; i<moodList.length; i++) {
        if (moodList[i].emoji == '😢') {
          badPoints += 1;
        }
        else if (moodList[i].emoji == '😡') {
          badPoints += 2;
        }
      }
    }
    
    if (badPoints >= 12) {
      return Text('You are encouraged to book an appointment with a therapist soon.');
    }
    else {
      return Text('Everything looks good! No actions needed.');
    }
  }
}