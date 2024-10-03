import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/models/course.dart';
import 'package:studentcard/pages/student/attendance_list.dart';
import 'package:studentcard/services/attendance_database.dart';

class ViewAttendance extends StatelessWidget {
  const ViewAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamProvider<List<AttendanceData>>.value(
      value: AttendanceDatabase().attendances,
      initialData: [],
      catchError: (context, error) {
        print(error.toString());
        return [];
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Check Attendance"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
          child: Column(
            children: [

              Expanded(child: AttendanceList(uid: user!.uid,)),

            ],
          ),
        ),
      ),
    );

  }
}



