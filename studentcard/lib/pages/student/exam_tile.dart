import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/models/course.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/shared_components/loading.dart';


class ExamTile extends StatelessWidget {
  final ExamData exam;
  ExamTile({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("courses").doc(exam.courseuid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          var courseData = snapshot.data?.data() as Map<String, dynamic>;
          return Card(
            margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: ListTile(
              title: Text("${courseData["courseid"]} - ${courseData["coursename"]}"),
              subtitle: Text("${exam.date} | ${exam.time} | ${exam.examhours} hours | ${exam.venue}"),
            ),
          );

        }

      },


    );
  }
}
