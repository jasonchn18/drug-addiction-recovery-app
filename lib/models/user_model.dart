import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? displayName;
  String? email;
  int? sober_days;
  String? type;
  Timestamp? last_checked_in;

  UserModel({this.displayName, this.email, this.sober_days, this.type, this.last_checked_in});

  // Receive data from database
  factory UserModel.fromMap(map) {
    return UserModel(
      displayName: map['displayName'],
      email: map['email'],
      sober_days: map['sober_days'],
      type: map['type'],
      last_checked_in: map['last_checked_in'],
    );
  }

  // Send data to database
  Map<String,dynamic> toMap() {
    return {
      'displayname': displayName,
      'email': email,
      'sober_days': sober_days,
      'type': type,
      'last_checked_in': last_checked_in,
    };
  }
}