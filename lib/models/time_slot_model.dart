class TimeSlotModel {
  bool? availability;
  String? booked_by;
  String? day;
  String? therapist_email;
  int? time;

  TimeSlotModel({this.availability, this.booked_by, this.day, this.therapist_email, this.time});

  // Receive data from database
  factory TimeSlotModel.fromMap(map) {
    return TimeSlotModel(
      availability: map['availability'],
      booked_by: map['booked_by'],
      day: map['day'],
      therapist_email: map['therapist_email'],
      time: map['time'],
    );
  }

  // Send data to database
  Map<String,dynamic> toMap() {
    return {
      'availability': availability,
      'booked_by': booked_by,
      'day': day,
      'therapist_email': therapist_email,
      'time': time,
    };
  }
}