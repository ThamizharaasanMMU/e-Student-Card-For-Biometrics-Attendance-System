import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentcard/models/user.dart';



class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future addUserData(String firstName, String lastName, String userType, String userID, String password) async {
    return await userCollection.doc(uid).set({
      'uid' : uid,
      'firstname' : firstName,
      'lastname' : lastName,
      'usertype' : userType,
      'userid' : userID.replaceFirst("@gmail.com", ""),
      'password' : password
    });

  }

  // user list from snapshot
  List<MMUserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MMUserData(
          uid: doc['uid'],
          firstName: doc['firstname'],
          lastName: doc['lastname'],
          password: doc['password'],
          userID: doc['userid'],
          userType: doc['usertype']);
    }).toList();

  }


  // user data from snapshot
  MMUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return MMUserData(
        uid: uid!,
        firstName: snapshot['firstname'],
        lastName: snapshot['lastname'],
        password: snapshot['password'],
        userID: snapshot['userid'],
        userType: snapshot['usertype']);
  }


  //   get users stream

  Stream<List<MMUserData>> get users {
    return userCollection.snapshots()
        .map(_userListFromSnapshot);
  }


  //   get user doc stream

  Stream<MMUserData> get userData {
    return userCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }


}