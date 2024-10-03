import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/services/authentication.dart';

class UserTile extends StatelessWidget {
  final MMUserData user;
  UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
            },
            icon: Icon(Icons.delete),
          ),
          title: Text('${user.firstName} ${user.lastName}'),
          subtitle: Text(user.userID.replaceFirst("@gmail.com", "")),
        ),


      ),
    );
  }
}
