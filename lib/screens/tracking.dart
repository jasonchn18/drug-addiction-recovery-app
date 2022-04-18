// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Tracking extends StatefulWidget {
  const Tracking({ Key? key }) : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240,240,235,1.0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height:15.0),
              Text(
                'Mood Tracking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: moodList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> moodList() {
    List<Widget> list = <Widget>[];

    list.add(Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ListTile(
          dense: false,
          visualDensity: VisualDensity(horizontal: -4),
          leading: Text(
            '15-04-2022',
          ),
          title: Text(
            'I don\'t want to talk about today.',
          ),
          trailing: Text(
            '😡',
            style: TextStyle(
              fontSize: 20,
            ),
          ), 
        ),
      ),
    ));

    list.add(Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ListTile(
          dense: false,
          visualDensity: VisualDensity(horizontal: -4),
          leading: Text(
            '14-04-2022',
          ),
          title: Text(
            'Today was the worst day...',
          ),
          trailing: Text(
            '😢',
            style: TextStyle(
              fontSize: 20,
            ),
          ), 
        ),
      ),
    ));

    list.add(Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ListTile(
          dense: false,
          visualDensity: VisualDensity(horizontal: -4),
          leading: Text(
            '13-04-2022',
          ),
          title: Text(
            'I had a great day today!',
          ),
          trailing: Text(
            '😁',
            style: TextStyle(
              fontSize: 20,
            ),
          ), 
        ),
      ),
    ));

    return list;
  }
}