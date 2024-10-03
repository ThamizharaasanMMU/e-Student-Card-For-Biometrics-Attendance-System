import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/pages/student/exams_list.dart';
import 'package:studentcard/models/course.dart';
import 'package:studentcard/services/course_database.dart';
import 'package:studentcard/services/database.dart';
import 'package:studentcard/shared_components/loading.dart';


class ViewExamSlip extends StatefulWidget {
  const ViewExamSlip({super.key});

  @override
  State<ViewExamSlip> createState() => _ViewExamSlipState();
}

class _ViewExamSlipState extends State<ViewExamSlip> {
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String,String> userDetails = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    if (userDetails != null) {
      setState(() {
        loading = false;  // Set loading to false once userDetails are fetched
      });
    } else {
      // Handle case where args are null
      setState(() {
        loading = false;  // Also set loading to false if args are null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String,String> userDetails = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    return StreamProvider<List<ExamData>>.value(
      value: CourseDatabaseService().exams,
      initialData: [],
      catchError: (context, error) {
        print(error.toString());
        return [];
      },
      child: loading ? Loading(): Scaffold(
        appBar: AppBar(
          title: Text("View Exam Slip"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,

        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name : ${userDetails["user"]}"),
              SizedBox(height: 10,),
              Text("Student ID : ${userDetails["userid"]}"),
              SizedBox(height: 10,),
              Text("Campus : Cyberjaya Campus"),
              SizedBox(height: 10,),
              Text("Faculty : FCI"),
              SizedBox(height: 10,),
              Text("Term : Trimester 2 - 2024/2025"),
              SizedBox(height: 10,),

              Divider(thickness: 5,),

              Expanded(child: ExamList(uid: user!.uid,)),
            ],
          ),
        ),
      ),
    );
  }
}
