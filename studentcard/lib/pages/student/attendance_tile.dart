import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/models/course.dart';
import 'package:studentcard/styles/app_colors.dart';


class AttendanceTile extends StatelessWidget {
  final AttendanceData attendanceData;
  const AttendanceTile({super.key, required this.attendanceData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.BtnColor10,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Subject : ${attendanceData.coursename}"),
                Text("Class Code : ${attendanceData.courseid}"),
                Text("Class Session : ${attendanceData.classsection}"),
                Text("Time : ${attendanceData.time}"),
              ],
            ),
          )
        ),
      ),
    );
  }
}
