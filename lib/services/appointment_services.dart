import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_app/models/appointment_model.dart';

class AppointmentService {

  // Function for patient to book an appointment
  Future bookAppointment(AppointmentModel appointment) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('appointments').doc().set(appointment.toMap());
  }
}