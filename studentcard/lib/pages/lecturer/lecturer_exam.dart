import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/services/course_database.dart';
import 'package:studentcard/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studentcard/shared_components/constants.dart';
import 'package:intl/intl.dart';
import 'package:studentcard/shared_components/student_table.dart';
import 'package:studentcard/styles/app_colors.dart';


class LecturerExamination extends StatefulWidget {
  const LecturerExamination({super.key});


  @override
  State<LecturerExamination> createState() => _LecturerExaminationState();
}

class _LecturerExaminationState extends State<LecturerExamination> {
  final CourseDatabaseService _addData = CourseDatabaseService();
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final List<String> venues = ['FOM CR0002', 'FCI CQCR 1001', 'FCI CQCR 1002','FCI CQCR 1003'];
  final List<String> durations = ['1','2','3'];
  String? selectedCourse = "";
  String selectedCourseID = "";
  List<String> courses = [];
  List<String> courseId = [];
  List<String> studentNames = [];
  List<String> studentUid = [];
  List<String> selectedStudentUid = [];
  List<String> studentId = [];
  List<bool> checked = [];

  Future<void> _loadCourses() async {
    List? c = await getCourseList(user!.uid);
    List? cid = await getCourseID(user!.uid);

    setState(() {
      c!.map((e) {
        courses.add(e.toString());
        return null;}).toList();

      cid!.map((e) {
        courseId.add(e.toString());
        return null;

      }).toList();

    });
  }

  // List<String> stringList = courses.map((item) => item.toString()).toList();
  TextEditingController datePickerController = TextEditingController();
  TextEditingController timePickerController = TextEditingController();

  String venue = '';
  String duration = '';

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Examination"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 25.0 ),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.s,
              children: [
                DropdownButtonFormField(
                  isExpanded: true,
                    itemHeight: null,
                    decoration: text("Course name"),
                    items: courses.map(
                            (type) => DropdownMenuItem(
                            value: type,
                            child: Text("$type"))).toList(),
                  onChanged: (val) async{
                    // Perform the asynchronous work first
                      // Update the state inside setState
                    selectedCourseID = courseId[courses.indexOf(val!)];
                    List? students = await getStudentList(selectedCourseID);
                    List<String> names = [];
                    List<String> ids = [];
                    List<bool> check = [];
                    List<String> uids = [];

                    for (var i = 0; i < students!.length; i++) {
                      DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(students[i]);
                      DocumentSnapshot documentSnapshot = await documentReference.get();
                      names.add(documentSnapshot["firstname"] + " " + documentSnapshot["lastname"]);
                      ids.add(documentSnapshot["userid"]);
                      check.add(true);
                      uids.add(documentSnapshot.id);

                    }
                    setState(() {
                      studentNames = names;
                      studentId = ids;
                      checked = check;
                      studentUid = uids;

                    });
                  }),
                SizedBox(height: 25,),
        
                TextFormField(
                  controller: datePickerController,
                  readOnly: true,
                  decoration: text('Exam Date').copyWith(
                      suffixIcon: IconButton(
                          onPressed: () async{
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2030));
        
                            datePickerController.text = DateFormat('dd-MM-yyyy').format(date!);
                            // print(user!.uid);
                          },
                          icon: Icon(Icons.date_range))),
        
                ),
                SizedBox(height: 25,),
                TextFormField(
                  controller: timePickerController,
                  readOnly: true,
                  decoration: text('Exam Time').copyWith(
                      suffixIcon: IconButton(
                          onPressed: () async{
                            TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now());
        
                            int hour = time!.hour.toInt();
                            String  minute = time!.minute.toString();
                            String meridiem = "";
        
                            if (hour > 12) {
                              hour = hour - 12;
                              meridiem = "PM";
                            }
                            else {
                              meridiem = "AM";
                            }

                            if (int.parse(minute) < 10) {
                              minute = "0" + minute;
                            }
                            else {
                              minute = minute;
                            }
                            String formattedTime = hour.toString() + ":"+  minute +" " + meridiem;
                            timePickerController.text = formattedTime;
        
                          },
                          icon: Icon(Icons.access_time_sharp))),
        
                ),
                SizedBox(height: 25,),
        
                DropdownButtonFormField(
                    decoration: text("Exam venue"),
                    items: venues.map(
                            (type) => DropdownMenuItem(
                            value: type,
                            child: Text("$type"))).toList(),
                    onChanged: (val) => setState(() {
                      venue = val!;
        
        
                    })),
                SizedBox(height: 25,),
        
                DropdownButtonFormField(
                    decoration: text("Exam hours"),
                    items: durations.map(
                            (type) => DropdownMenuItem(
                            value: type,
                            child: Text("$type hour"))).toList(),
                    onChanged: (val) => setState(() {
                      duration = val!;
        
        
                    })),
                SizedBox(height: 25,),

                // StudentTableWidget(uid: selectedCourseID),
                StudentTableWidget(studentNames: studentNames, studentId: studentId, checked: checked),
                SizedBox(height: 25,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async{

                        for (var i = 0; i < checked.length; i++) {
                          if (checked[i] == true) {
                            selectedStudentUid.add(studentUid[i]);
                          }
                        }
                        
                        await _addData.addExamData(selectedCourseID, duration, datePickerController.text,
                            venue, timePickerController.text, selectedStudentUid);

                        final snackBar = SnackBar(
                          content: Text('Final exam posted successfully !'),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                        

                        // print("Course uid = $selectedCourseID");
                        // print("Students = $selectedStudentUid");
                        // print("Date = ${datePickerController.text}");
                        // print("Time = ${timePickerController.text}");
                        // print("Exam hours = $duration");
                        // print("Venue/Station = $venue");

                      },
                      child: Text("Post"),

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: AppColors.LoginBtn,

                  ),),
                )
        
              ],
        
            ),
          ),
        ),
      ),
    );
  }

}
