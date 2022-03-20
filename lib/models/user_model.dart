class UserModel {
  String? displayName;
  String? email;
  int? sober_days;
  String? type;

  UserModel({this.displayName, this.email, this.sober_days, this.type});

  // Receive data from database
  factory UserModel.fromMap(map) {
    return UserModel(
      displayName: map['displayName'],
      email: map['email'],
      sober_days: map['sober_days'],
      type: map['type'],
    );
  }

  // Send data to database
  Map<String,dynamic> toMap() {
    return {
      'displayname': displayName,
      'email': email,
      'sober_days': sober_days,
      'type': type,
    };
  }
}