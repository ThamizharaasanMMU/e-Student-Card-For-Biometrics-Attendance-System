import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/pages/admin/admin_create_acc.dart';
import 'package:studentcard/pages/admin/admin_delete_acc.dart';
import 'package:studentcard/pages/campusStaff/face_recognition.dart';
import 'package:studentcard/pages/lecturer/exam_recognition.dart';
import 'package:studentcard/pages/lecturer/exam_verification.dart';
import 'package:studentcard/pages/lecturer/lecturer_exam.dart';
import 'package:studentcard/pages/lecturer/lecturer_home.dart';
import 'package:studentcard/pages/lecturer/lecturer_mark_attendance.dart';
import 'package:studentcard/pages/lecturer/mark_attendance.dart';
import 'package:studentcard/pages/page_decider.dart';
import 'package:studentcard/pages/student/biometric_registration.dart';
import 'package:studentcard/pages/student/view_attendance.dart';
import 'package:studentcard/pages/student/view_exam_slip.dart';
import 'package:studentcard/pages/student/view_student_card.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/styles/app_colors.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthService().signOut();
    return StreamProvider<MMUsers?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, error) {
        return null;
      },
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,

        ),
        // home: PageDecider(),
        initialRoute: '/',
        routes: {
          '/' : (context) => PageDecider(),
          // '/' : (context) => TestPage(),
          '/create' : (context) => AdminCreateAccount(),
          '/delete' : (context) => AdminDeleteAccount(),
          '/exam' : (context) => LecturerExamination(),
          '/view_exam' : (context) => ViewExamSlip(),
          '/view_studentcard' : (context) => ViewStudentCard(),
          '/biometric_register' : (context) => BiometricRegistration(),
          '/recognize' : (context) => FaceRecognition(),
          '/exam_verification' : (context) => ExamVerification(),
          '/exam_recognization' : (context) => ExamRecognition(),
          '/mark_attendance' : (context) => LecturerMarkAttendance(),
          '/biometric_attendance' : (context) => MarkAttendance(),
          '/view_attendance' : (context) => ViewAttendance(),
        },
      ),
    );
  }
}
