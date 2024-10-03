import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentcard/models/course.dart';


class AttendanceDatabase {
  final CollectionReference attendanceCollection = FirebaseFirestore.instance.collection("attendance");

  Future addAttendance(String week, String date, String time, String courseid, String coursename, String classsection, List<String> students, String currentDate) async {
    String uid = attendanceCollection.doc().id;
    return await attendanceCollection.doc(uid).set({
      'uid' : uid,
      'week' : week,
      'date' : date,
      'time' : time,
      'courseid' : courseid,
      'coursename' : coursename,
      'classsection' : classsection,
      'students' : students,
      'currentdate' : currentDate

    });

  }

  List<AttendanceData> _attendanceListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc)
    {return AttendanceData(
        uid: doc['uid'],
        week: doc["week"],
        date: doc["date"],
        time : doc["time"],
        courseid: doc["courseid"],
        coursename: doc["coursename"],
        classsection: doc["classsection"],
        students: doc["students"],
        currentDate: doc["currentdate"]);
    }).toList();
  }

  //   get attendance data stream

  Stream<List<AttendanceData>> get attendances {
    return attendanceCollection.snapshots()
        .map(_attendanceListFromSnapshot);
  }



}