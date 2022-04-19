import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app/models/appointment_model.dart';

class AppointmentService {
  User? user = FirebaseAuth.instance.currentUser;

  // Function for patient to book an appointment
  Future bookAppointment(AppointmentModel appointment) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('appointments').doc().set(appointment.toMap());
  }

  // Function for patient or therapist to retrieve their appointment list
  Future<List<AppointmentModel>> getAppointmentList(String? userType) async {
    List<AppointmentModel> appointmentList = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (userType == 'P') {
      await db.collection('appointments')
      .where("booked_by", isEqualTo: user!.email)
      .orderBy("date")
      .get().then((query) {
        for (var doc in query.docs) {
          appointmentList.add(AppointmentModel.fromMap(doc.data()));
        }
      });
    }
    else {  //userType == 'T'
      await db.collection('appointments')
      .where("therapist_email", isEqualTo: user!.email)
      .orderBy("date")
      .get().then((query) {
        for (var doc in query.docs) {
          appointmentList.add(AppointmentModel.fromMap(doc.data()));
        }
      });
    }

    return appointmentList;
  }

  // Function for patient or therapist to cancel an appointment
  Future cancelAppointment(AppointmentModel appointment) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnap = await db.collection('appointments')
    .where('therapist_email', isEqualTo: appointment.therapist_email)
    .where('date', isEqualTo: appointment.date)
    .where('mode', isEqualTo: appointment.mode)
    .where('booked_by', isEqualTo: appointment.booked_by)
    .get();

    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document
    DocumentReference docRef = doc.reference;
    await docRef.delete();
  }
}