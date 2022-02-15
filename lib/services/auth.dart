import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Create instance of our FirebaseAuth, providing us with methods from the FirebaseAuth class
  // final means wont change in the future
  // underscore means private, only can use in this file
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // method to login anonymously (asynchronous task)
  Future signInAnon() async {
    try {
      // await means will wait till this is complete
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // method to login with email and password

  // method to register with email and password

  // method to logout

}