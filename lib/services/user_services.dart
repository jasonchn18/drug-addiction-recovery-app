import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app/models/user_model.dart';

class UserService {
  Future<UserModel> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    return await db.collection('users').doc(user!.uid).get()
      .then((value) => UserModel.fromMap(value.data()));
  }

  Future<List<UserModel>> getAllTherapists() async {
    List<UserModel> therapistList = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users')
    .where("type", isEqualTo: "T")
    .orderBy("displayName")
    .get().then((query) {
      for (var doc in query.docs) {
        therapistList.add(UserModel.fromMap(doc.data()));
      }
    });

    return therapistList;
  }

  Future<String> getDisplayNameFromEmail(String email) async {
    String displayName = "";

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users')
    .where("email",isEqualTo: email)
    .get().then((query) {
      displayName = query.docs[0].get('displayName');
    });

    return displayName;
  }

  // Function to update patient's drug-free/sober days
  Future updateSoberDays(UserModel user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnap = await db.collection('users')
    .where('email', isEqualTo: user.email)
    .get();

    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document
    DocumentReference docRef = doc.reference;
    await docRef.update({
      'sober_days': user.sober_days,
      'last_checked_in': user.last_checked_in,
    });
  }
}