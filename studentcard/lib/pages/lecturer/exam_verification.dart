import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/pages/lecturer/exam_recognition.dart';
import 'package:studentcard/services/course_database.dart';
import 'package:studentcard/shared_components/constants.dart';
import 'package:studentcard/shared_components/loading.dart';

class ExamVerification extends StatefulWidget {
  const ExamVerification({super.key});

  @override
  State<ExamVerification> createState() => _ExamVerificationState();
}

class _ExamVerificationState extends State<ExamVerification> {
  final _formKey = GlobalKey<FormState>();
  List<String> courses = [];
  List<String> examId = [];
  String selectedExamID = "";
  bool displayCamera = false;


  Future<void> _loadCourses() async {
    List? exam = await getExamList();
    List<String> courseNames = [];
    for (var element in exam!) {
      examId.add(element.toString());
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('exams').doc(element);
      DocumentSnapshot documentSnapshot = await documentReference.get();

      DocumentReference courseReference = FirebaseFirestore.instance
          .collection('courses')
          .doc(documentSnapshot["courseuid"]);
      DocumentSnapshot courseSnapshot = await courseReference.get();

      courseNames.add(courseSnapshot["courseid"] +
          " - " +
          courseSnapshot["coursename"]);
    }
    setState(() {
      courses.addAll(courseNames);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCourses();
    didChangeDependencies();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Verification in Exam Hall"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: courses.length == 0 ? Loading(): Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 25.0 ),
        child: Form(
          key: _formKey,
          child: Column(
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
                    displayCamera = true;
                    selectedExamID = examId[courses.indexOf(val!)];
                    DocumentReference documentReference = FirebaseFirestore.instance.collection("exams").doc(selectedExamID);
                    DocumentSnapshot documentSnapshot = await documentReference.get();

                    Navigator.of(context).pushNamed('/exam_recognization', arguments: {
                      "students" : documentSnapshot["students"]
                    });
                  }),



            ],
          ),
        ),
      ),
    );

  }
}
