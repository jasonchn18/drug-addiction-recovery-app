import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app/models/the_user.dart';

class AuthService {
  // Create instance of our FirebaseAuth, providing us with methods from the FirebaseAuth class
  // final means wont change in the future
  // underscore means private, only can use in this file
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create TheUser object based on Firebase user
  TheUser? _userFromFirebaseUser(User user) {
    // return uid from user object if user is not null
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // method to login anonymously (asynchronous task)
  Future signInAnon() async {
    try {
      // await means will wait till this is complete
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // method to login with email and password

  // method to register with email and password

  // method to logout

}