import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/models/course.dart';
import 'package:studentcard/pages/student/attendance_tile.dart';
import 'package:studentcard/shared_components/display_nothing.dart';


class AttendanceList extends StatefulWidget {
  final String uid;
  const AttendanceList({super.key, required this.uid});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  @override
  Widget build(BuildContext context) {
    final attendance = Provider.of<List<AttendanceData>>(context) ?? [];
    DateTime today = DateTime.now();
    String currentDate = DateFormat("dd-MM-yy").format(today);
    final finalisedAttendance = attendance.where((atdnce) => atdnce.currentDate == currentDate && 
                                                              atdnce.students.contains(widget.uid)).toList();

    return finalisedAttendance.length == 0 ? DisplayNothing(message: "No attendance records") : ListView.builder(
        itemCount: finalisedAttendance.length,
        itemBuilder: (context, index) {
          return AttendanceTile(attendanceData: finalisedAttendance[index]);
        });
  }
}
