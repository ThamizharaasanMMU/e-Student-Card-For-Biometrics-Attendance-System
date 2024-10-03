import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/pages/student/exams_list.dart';
import 'package:studentcard/models/course.dart';
import 'package:studentcard/services/course_database.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:studentcard/shared_components/student_table.dart';

class TestPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing"),
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async{
                  // String uid = 'cTRAIEn0QGPM9FLacgsf0qiPQpF3';
                  String subject = "COMPUTATIONAL METHODS - TT1V";

                  CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');

                  QuerySnapshot querySnapshot = await coursesCollection.get();

                  querySnapshot.docs.forEach((element) {
                  // print(element["classes"][0]["lecturer"]);
                    for (int i = 0; i < element["classes"].length; i++) {

                      if (subject.contains(element["coursename"]) && subject.contains(element["classes"][i]["class"] )){
                        DateTime startDate = element["startdate"].toDate().add(Duration(hours: 8));
                        DateTime endDate = element["enddate"].toDate().add(Duration(hours: 8));

                        while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
                          String day = DateFormat("EEEE").format(startDate);
                          if (day == element["classes"][i]["day"]) {
                            print(startDate);

                          }
                          startDate = startDate.add(Duration(days: 1));
                        }


                        // String day = DateFormat("EEEE").format(startDate);


                      }

                    }

                  });



                },
                child: Icon(Icons.add)),
            SizedBox(height: 50,),
            // Expanded(child: ExamList()),
          ],
        ),

    );
  }

  // TODO list out lecturer's classes
  // CollectionReference coursesCollection = FirebaseFirestore.instance.collection('courses');
  //
  // QuerySnapshot querySnapshot = await coursesCollection.get();
  //
  // querySnapshot.docs.forEach((element) {
  // // print(element["classes"][0]["lecturer"]);
  // for (int i = 0; i < element["classes"].length; i++) {
  // if(element["classes"][i]["lecturer"] == "cTRAIEn0QGPM9FLacgsf0qiPQpF3"){
  // print(element["coursename"]);
  // }
  // }
  //
  // });




// TODO assign Lecturers to empty subjects as coordinator or lecturer
  void assignLecturerToSubjects(String lecturerUid) async{
    print("inside assignLecturerToSubjects()");

    final _courseStream = FirebaseFirestore.instance.collection("courses").snapshots();

    try{
      QuerySnapshot snapshot = await _courseStream.first; // Wait for the first snapshot

      List<String> allUids = snapshot.docs.map((doc) => doc.id).toList();

      for (var i = 0; i < allUids.length; i++) {

        DocumentReference documentReference = FirebaseFirestore.instance.collection('courses').doc(allUids[i]);
        DocumentSnapshot documentSnapshot = await documentReference.get();
        List<dynamic> classes = documentSnapshot['classes'];

        if (documentSnapshot["coordinator"] == "") {

          await documentReference.update({'coordinator': lecturerUid});
          i = allUids.length;

        }
        else if (documentSnapshot["coordinator"] != "") {
          for (var j = 0; j < classes.length; j++) {

            if (classes[j]["lecturer"] == "") {
              Map<String, dynamic> Class = classes[j];
              Class["lecturer"] = lecturerUid;
              await documentReference.update({'classes': classes});
              j = classes.length;
              i = allUids.length;

            }
          }
        }
      }

    } catch (e) {
      print(e.toString());
    }
  }



}
