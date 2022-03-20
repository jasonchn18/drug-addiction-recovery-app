import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app/models/time_slot_model.dart';

class TimeSlotService {
  User? user = FirebaseAuth.instance.currentUser;
  
  // Function to get all available time slots
  Future<List<TimeSlotModel>> getAvailableTimeSlots(String chosenTherapistEmail) async {
    List<TimeSlotModel> timeSlotList = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('time_slots')
    .where("therapist_email",isEqualTo: chosenTherapistEmail)
    .where("availability",isEqualTo: true)
    .orderBy("day")
    .orderBy("time")
    .get().then((query) {
      for (var doc in query.docs) {
        timeSlotList.add(TimeSlotModel.fromMap(doc.data()));
      }
    });

    return timeSlotList;
  }

  // Function for a patient to book an available time slot
  Future bookTimeSlot(String chosenTherapistEmail, String chosenDay, int chosenTime) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnap = await db.collection('time_slots')
    .where('therapist_email', isEqualTo: chosenTherapistEmail)
    .where('day', isEqualTo: chosenDay)
    .where('time', isEqualTo: chosenTime)
    .get();

    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document
    DocumentReference docRef = doc.reference;
    await docRef.update({
      'availability': false,
      'booked_by': user!.email,
    });
  }

  // Function for patient or therapist to retrieve their appointment(s) list
  Future<List<TimeSlotModel>> getAppointmentList(String? userType) async {
    List<TimeSlotModel> appointmentList = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (userType == 'P') {
      await db.collection('time_slots')
      .where("booked_by", isEqualTo: user!.email)
      .where("availability", isEqualTo: false)
      .orderBy("day")
      .orderBy("time")
      .get().then((query) {
        for (var doc in query.docs) {
          appointmentList.add(TimeSlotModel.fromMap(doc.data()));
        }
      });
    }
    else {  //userType == 'T'
      await db.collection('time_slots')
      .where("therapist_email", isEqualTo: user!.email)
      .where("availability", isEqualTo: false)
      .orderBy("day")
      .orderBy("time")
      .get().then((query) {
        for (var doc in query.docs) {
          appointmentList.add(TimeSlotModel.fromMap(doc.data()));
        }
      });
    }

    return appointmentList;
  }

  // Function for patient or therapist to cancel an appointment
  Future cancelAppointment(String therapistEmail, String patientEmail, String day, int time) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnap = await db.collection('time_slots')
    .where('therapist_email', isEqualTo: therapistEmail)
    .where('booked_by', isEqualTo: patientEmail)
    .where('day', isEqualTo: day)
    .where('time', isEqualTo: time)
    .get();

    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document
    DocumentReference docRef = doc.reference;
    await docRef.update({
      'availability': true,
      'booked_by': "",
    });
  }
}