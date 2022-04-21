import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app/models/mood_details_model.dart';
import 'package:fyp_app/models/mood_model.dart';

class MoodService {
  User? user = FirebaseAuth.instance.currentUser;

  // Function for patient to get their mood list
  Future<List<MoodDetailsModel>> getMoodList() async {
    List<MoodDetailsModel> moodList = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection('moods')
    .where("email", isEqualTo: user!.email)
    .get().then((query) {
      for (var moodDetail in query.docs[0].get('moodDetails')) {
        // print(doc.get('moodDetails').runtimeType);
        moodList.add(MoodDetailsModel.fromMap(moodDetail));
      }
    });
    // print(moodList);
    return moodList;
  }

  // Function for patient to check-in and add a mood
  Future checkIn(MoodDetailsModel moodDetails) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnap = await db.collection('moods')
    .where('email', isEqualTo: user!.email)
    .get();

    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document
      DocumentReference docRef = doc.reference;
      
      // Get the existing moodDetailsList from Firestore document
      List<dynamic> dynamicMoodDetailsList = (doc.get('moodDetails'));

      List<MoodDetailsModel> moodDetailsList = [];
      for(var data in dynamicMoodDetailsList) {
        MoodDetailsModel tempMoodDetails = MoodDetailsModel();
        tempMoodDetails.date = data['date'];
        tempMoodDetails.emoji = data['emoji'];
        tempMoodDetails.description = data['description'];
        moodDetailsList.add(tempMoodDetails);
      }

      // Add the new moodDetail to the list
      moodDetailsList.add(moodDetails);
      
      MoodModel mood = MoodModel();

      mood.email = user!.email;
      mood.moodDetails = moodDetailsList;

      await docRef.set(mood.toMap());
    }
    else {
      MoodModel mood = MoodModel();
      List<MoodDetailsModel> moodDetailsList = [];
      moodDetailsList.add(moodDetails);

      mood.email = user!.email;
      mood.moodDetails = moodDetailsList;
      await db.collection('moods').doc().set(mood.toMap());
    }

    DocumentSnapshot userDocSnap = await db.collection('users').doc(user!.uid).get();
    DocumentReference userDocRef = userDocSnap.reference;
    await userDocRef.update({
      'last_checked_in': Timestamp.fromDate(DateTime.now()),
    });
  }
}