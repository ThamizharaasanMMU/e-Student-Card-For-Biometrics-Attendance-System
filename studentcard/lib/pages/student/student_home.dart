import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/pages/student/view_student_card.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/shared_components/popupmenubutton.dart';
import 'package:studentcard/styles/app_text.dart';
import 'package:studentcard/styles/app_colors.dart';



class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? name;
    String? id;
    Map<String, String> userDetails = {"user" : "", "userid" : ""};
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Set the icon color to white

            ),
            onPressed: () {

            },
          ),
            actions: [
              PopUpMenu(),
            ]

        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.topLeft,
                  child: Text('Student Dashboard', style: AppText.header2,)),
              SizedBox(height: 40,),
              Align(
                alignment: Alignment.center,
                  child: Image.asset('assets/images/mmu_logo.png')),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed('/view_studentcard', arguments: user?.uid);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.BtnColor1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),

                      ),

                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset('assets/icons/icon_person.png'),
                          SizedBox(height: 10,),
                          Text("e-Student Card"),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()async{
                        DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(user!.uid);
                        DocumentSnapshot documentSnapshot = await documentReference.get();
                        name = documentSnapshot["firstname"] + " " + documentSnapshot["lastname"];
                        id = documentSnapshot["userid"];

                        userDetails["user"] = documentSnapshot["firstname"] + " " + documentSnapshot["lastname"];
                        userDetails["userid"] = documentSnapshot["userid"];
                        Navigator.of(context).pushNamed('/view_exam', arguments: userDetails);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.BtnColor2,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),

                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset('assets/icons/icon_document.png'),
                          SizedBox(height: 10,),
                          Text("Exam Slip"),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed('/biometric_register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.BtnColor3,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )

                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset('assets/icons/icon_face_id.png'),
                          SizedBox(height: 10,),
                          Text("Biometric Data"),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed('/view_attendance');

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.BtnColor4,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),

                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset('assets/icons/icon_openbook.png'),
                          SizedBox(height: 20,),
                          Text("Check Attendance", style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
              Spacer(),


            ],

          ),
        ),
      ),
    );
  }
}
