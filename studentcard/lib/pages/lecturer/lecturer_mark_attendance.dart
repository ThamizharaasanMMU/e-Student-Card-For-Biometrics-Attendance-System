import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studentcard/shared_components/attendance_table.dart';
import 'package:studentcard/shared_components/constants.dart';
import 'package:studentcard/shared_components/display_nothing.dart';
import 'package:studentcard/shared_components/loading.dart';

class LecturerMarkAttendance extends StatefulWidget {
  const LecturerMarkAttendance({super.key});

  @override
  State<LecturerMarkAttendance> createState() => _LecturerMarkAttendanceState();
}

class _LecturerMarkAttendanceState extends State<LecturerMarkAttendance> {
  User? user = FirebaseAuth.instance.currentUser;
  List <String> subjects = [];
  List<String> subjectIds = [];
  List<String> dates = [];
  List<String> students = [];
  String startTime = "";
  String courseID = "";
  String courseName = "";
  String courseSection = "";

  bool loading = false;

  Future<void> _loadSubjects() async {
    setState(() {
      loading = true;
    });

    try {
      CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
      QuerySnapshot querySnapshot = await coursesCollection.get();
      querySnapshot.docs.forEach((element) {
        for (int i = 0; i < element["classes"].length; i++) {
          if (element["classes"][i]["lecturer"] == user!.uid){
            setState(() {
              subjects.add(element["classes"][i]["class"] + " - " + element["coursename"]);
              subjectIds.add(element['courseid']);
              loading = false;
            });
          }
          else {
            setState(() {
              loading = false;
            });
          }
        }
      });

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: subjects.isEmpty ? DisplayNothing(message: 'No classes to display'): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 25.0 ),
          child: Column(
            children: [
              DropdownButtonFormField(
                  isExpanded: true,
                  itemHeight: null,
                  decoration: text("Course name"),
                  items: subjects.map(
                          (type) => DropdownMenuItem(
                          value: type,
                          child: Text("$type"))).toList(),
                  onChanged: (val) async{
                    setState(() {
                      dates.clear();
                      students.clear();
                    });
                    // Perform the asynchronous work first
                    String subject = val!;

                    setState(() {
                      courseID = subjectIds[subjects.indexOf(val)];
                    });
        
                    CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
                    QuerySnapshot querySnapshot = await coursesCollection.get();
        
                    querySnapshot.docs.forEach((element) {
                      for (int i = 0; i < element["classes"].length; i++) {
                        if (subject.contains(element["coursename"]) && subject.contains(element["classes"][i]["class"] )){
                          DateTime startDate = element["startdate"].toDate().add(Duration(hours: 8));
                          DateTime endDate = element["enddate"].toDate().add(Duration(hours: 8));
                          List<dynamic> studentsFromFirebase = (element["classes"][i]["students"]);
                          List<String> processStudents = studentsFromFirebase.map((s) => s.toString()).toList();

                          setState(() {
                            startTime = element["classes"][i]["time"];
                            students = processStudents;
                            courseName = element["coursename"];
                            courseSection = element["classes"][i]["class"];
                          });
        
                          while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
                            String day = DateFormat("EEEE").format(startDate);
                            if (day == element["classes"][i]["day"]) {
                              String formattedDate = DateFormat("dd-MM-yy").format(startDate);
                              setState(() {
                                dates.add(formattedDate);
                              });
                            }
                            startDate = startDate.add(Duration(days: 1));
                          }
                        }
                      }
                    });
                  }),
              SizedBox(height: 25,),
              AttendanceTableWidget(dates: dates, students: students, startTime: startTime,
                                    courseID: courseID, courseName: courseName, courseSection: courseSection,)
        
            ],
          ),
        ),
      )

    );
  }
}
