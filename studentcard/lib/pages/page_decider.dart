import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/pages/admin/admin_home.dart';
import 'package:studentcard/pages/campusStaff/campus_staff_home.dart';
import 'package:studentcard/pages/lecturer/lecturer_home.dart';
import 'package:studentcard/pages/login.dart';
import 'package:studentcard/pages/student/student_home.dart';
import 'package:studentcard/services/database.dart';


class PageDecider extends StatelessWidget {
  const PageDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MMUsers?>(context);
    String userType = '';
    String pass = '';

    return StreamBuilder<MMUserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot){
          if(snapshot.hasData) {
            MMUserData? userData = snapshot.data;
            userType = userData!.userType;
            // print(userType);
            pass = userData!.password;
            if (userType == 'Student') {
              return StudentHomePage();
            }
            else if (userType == 'Lecturer') {
              return LecturerHomePage();
            }
            else if (userType == 'Administrator') {
              return AdminHomePage(pass: pass);
            }
            else if (userType == 'Campus Staff') {
              return CampusStaffHomePage();

            }
            else {
              return LoginPage();
            }

          } else {
            return LoginPage();
          }
        });


  }
}
