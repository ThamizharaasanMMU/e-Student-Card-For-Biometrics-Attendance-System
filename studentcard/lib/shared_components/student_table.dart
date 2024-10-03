import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/services/course_database.dart';


class StudentTableWidget extends StatefulWidget {
  final List<String> studentNames;
  final List<String> studentId;
  final List<bool> checked;
  const StudentTableWidget({required this.studentNames, required this.studentId, required this.checked});

  @override
  State<StudentTableWidget> createState() => _StudentTableWidgetState();
}

class _StudentTableWidgetState extends State<StudentTableWidget> {
  @override
  Widget build(BuildContext context) {
    List<TableRow> data = List<TableRow>.generate(widget.studentNames.length, (index) =>
        TableRow(
            children: [
              TableCell(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.studentId[index]),
              )),
              TableCell(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.studentNames[index]),
              )),
              TableCell(child: Checkbox(
                value: widget.checked[index],
                onChanged: (bool? value) {
                  print(value);
                  setState(() {
                    widget.checked[index] = value!;
                    print(widget.checked);

                  });
                },

              ),)
            ]
        ));

    TableRow tablehead =
      TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,), // Title of the first column
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,), // Title of the second column
            ),
          ),
          TableCell(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ))
        ],
      );

    List<TableRow> combineRow = [tablehead] + data;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(1),
        },
        children: combineRow,

      ),
    );
  }
}


