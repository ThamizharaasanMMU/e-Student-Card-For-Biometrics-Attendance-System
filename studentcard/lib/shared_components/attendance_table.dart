import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AttendanceTableWidget extends StatefulWidget {
  final List<String> dates;
  final List<String> students;
  final String startTime;
  final String courseID;
  final String courseName;
  final String courseSection;
  const AttendanceTableWidget({super.key, required this.dates, required this.students, required this.startTime,
                                required this.courseID, required this.courseName, required this.courseSection});

  @override
  State<AttendanceTableWidget> createState() => _AttendanceTableWidgetState();
}

class _AttendanceTableWidgetState extends State<AttendanceTableWidget> {

  @override
  Widget build(BuildContext context) {
    String time = widget.startTime;
    String formattedInitialTime = "";
    String formattedFinalTime = "";
    if (widget.startTime != "") {
      String modifiedTime = (time.substring(0,5) + " " +time.substring(9,11));
      DateFormat format = DateFormat('hh:mm a');
      DateTime initialTime = format.parse(modifiedTime);
      DateTime finalTime = initialTime.add(Duration(hours: 2));
      formattedInitialTime = DateFormat('hh:mm a').format(initialTime);
      formattedFinalTime = DateFormat('hh:mm a').format(finalTime);

    }



    List<TableRow> data = List<TableRow>.generate(widget.dates.length, (index) =>
        TableRow(
            children: [
              TableCell(
                child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text((index+1).toString()),
                ),
              ),
                verticalAlignment: TableCellVerticalAlignment.middle,),
              TableCell(child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.dates[index]),
                ),
              ),
                verticalAlignment: TableCellVerticalAlignment.middle,),
              TableCell(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(formattedInitialTime),
              ),
                  verticalAlignment: TableCellVerticalAlignment.middle),
              TableCell(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(formattedFinalTime),
              ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              TableCell(child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ElevatedButton(
                      onPressed: () async{
                        List<String> names = [];
                        List <bool> checked = [];
                        List<String> ids = [];
                        for (var i = 0; i < widget.students.length; i++) {
                          DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(widget.students[i]);
                          DocumentSnapshot documentSnapshot = await documentReference.get();
                          names.add(documentSnapshot["firstname"] + " " + documentSnapshot["lastname"]);
                          ids.add(documentSnapshot["userid"]);
                          checked.add(false);
                        }

                        Navigator.of(context).pushReplacementNamed('/biometric_attendance', arguments: {
                          'week' : (index+1).toString(),
                          'courseid' : widget.courseID,
                          'coursename' : widget.courseName,
                          'classsection' : widget.courseSection,
                          'students' : widget.students,
                          'studentnames' : names,
                          'studentids' : ids,
                          'checked' : checked,
                          'date' : widget.dates[index],
                          'time' : formattedInitialTime + " - " + formattedFinalTime
                        });
                      },
                      child: Icon(Icons.done, color: Colors.black,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                    ),
                  ),
                ),
              )),
            ]
        ));


    TableRow tablehead =
    TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center,), // Title of the first column
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Attendance Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center,), // Title of the second column
          ),
        ),
        TableCell(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("From Time", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            )),
        TableCell(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("To Time", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            )),
        TableCell(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            )),
      ],
    );


    List<TableRow> combineRow = [tablehead] + data;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        columnWidths: {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(5),
          2: FlexColumnWidth(5),
          3: FlexColumnWidth(5),
          4: FlexColumnWidth(5)
        },
        children: combineRow,

      ),
    );
  }
}
