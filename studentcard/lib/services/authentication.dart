import 'package:firebase_auth/firebase_auth.dart';
import 'package:studentcard/services/course_database.dart';
import 'package:studentcard/services/database.dart';
import 'package:studentcard/models/user.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MMUsers? _userFromFirebaseUser(User user) {
    return user != null ? MMUsers(uid: user.uid) : null;
  }

  // change user stream
  Stream<MMUsers?> get user {
    return _auth.authStateChanges()
        .map((user) => _userFromFirebaseUser(user!));
  }


  // register user

  Future registerUserWithCredentials(String firstName, String lastName, String userType, String userID, String password, String pass) async {
    try {

      String? currentUserId = _auth.currentUser!.email;
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: userID, password: password);
      User user = result.user!;

      await DatabaseService(uid: user.uid).addUserData(firstName, lastName, userType, userID, password);


      _auth.signOut();
      await signInWithUserIdAndPassword(currentUserId!, pass);
      if (userType == 'Student') {
        generateRandomUIDs(user.uid);
      }
      else if (userType == "Lecturer") {
        assignLecturerToSubjects(user.uid);
      }

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//   sign in with user id and password

  Future signInWithUserIdAndPassword(String userID, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: userID, password: password);
      User user = result.user!;

      

      return _userFromFirebaseUser(user);


    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try {
      return await _auth.signOut();

    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}