import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentcard/models/course.dart';


class CourseDatabaseService {
  final CollectionReference examCollection = FirebaseFirestore.instance.collection("exams");

  Future addExamData(String courseUid, String examHours, String date, String venue, String time, List<String> students) async{
    String uid = examCollection.doc().id;
    return await examCollection.doc(uid).set({
      'uid' : uid,
      'courseuid' : courseUid,
      'examhours' : examHours,
      'date' : date,
      'time' : time,
      'venue' : venue,
      'students' : students

    });
  }

  List<ExamData> _examListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc)
        {return ExamData(
            courseuid: doc['courseuid'],
            date: doc["date"],
            examhours: doc["examhours"],
            students : doc["students"],
            time: doc["time"],
            venue: doc["venue"]);
        }).toList();
  }

  //   get exam data stream

  Stream<List<ExamData>> get exams {
    return examCollection.snapshots()
        .map(_examListFromSnapshot);
  }


}


void generateRandomUIDs(String studentUid) async {
  final _courseStream = FirebaseFirestore.instance.collection("courses").snapshots();

  try {
    QuerySnapshot snapshot = await _courseStream.first; // Wait for the first snapshot

    // List<String> uids = [];
    List<String> allUids = snapshot.docs.map((doc) => doc.id).toList();

    // Shuffle the list of UIDs
    allUids.shuffle();

    // pick 3 random uids
    List<String> randomUids = allUids.take(3).toList();

    updateStudentsList(randomUids, studentUid);

  } catch (e) {
    print(e.toString());
    return null;
  }
}
//TODO assign students to 3 courses randomly
void updateStudentsList(List<String> uids, String studentUid) async {

  for (var j = 0; j < uids.length; j++) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('courses').doc(uids[j]);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    List<dynamic> classes = documentSnapshot['classes'];

    var tuto = [];
    var lect = [];
    for (var i =0; i < classes.length; i++) {
      Map<String, dynamic> firstClass = classes[i];

      if (firstClass['session'] == 'Tutorial'){
        tuto.add(i);
      }
      else if (firstClass['session'] == 'Lecture') {
        lect.add(i);
      }

    }
    Map<String, dynamic> tutoClass = classes[tuto[Random().nextInt(tuto.length)]];
    Map<String, dynamic> lectClass = classes[lect[Random().nextInt(lect.length)]];

    tutoClass['students'].add(studentUid);
    lectClass['students'].add(studentUid);

    await documentReference.update({'classes': classes});

  }

}

Future<List?> getCourseList(String uid) async {

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("courses")
        .get(GetOptions(source: Source.server));

    List<String> filteredDocIds = snapshot.docs
        .where((doc) => doc['coordinator'] == uid)
        .map((doc) => (doc["courseid"] + " - " + doc["coursename"]).toString())
        .toList();

    // String selectedCourse = snapshot.docs
    //     .where((doc) => 'TSN2101 - OPERATING SYSTEM'.contains(doc["courseid"]) == true)
    //     .map((doc) => (doc.id)).toString();
    //
    // print(selectedCourse);

    return filteredDocIds;

  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future<List?> getCourseID(String uid) async {

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("courses")
        .get(GetOptions(source: Source.server));

    List<String> filteredDocIds = snapshot.docs
        .where((doc) => doc['coordinator'] == uid)
        .map((doc) => (doc.id).toString())
        .toList();

    return filteredDocIds;

  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future<List?> getExamList() async{

  try {
    QuerySnapshot examSnapshot = await FirebaseFirestore.instance
        .collection("exams")
        .get(GetOptions(source: Source.server));

    List<String> exams = examSnapshot.docs
          .map((doc) => (doc.id).toString())
          .toList();

    return exams;

  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future<List?> getStudentList(String uid) async {

  try {

    DocumentReference documentReference = FirebaseFirestore.instance.collection('courses').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    List<dynamic> classes = documentSnapshot['classes'];

    List<dynamic> students = [];

    for (var i = 0; i < classes.length; i++) {
      Map<String, dynamic> firstClass = classes[i];
      if (firstClass["session"] == "Lecture") {
        // print(firstClass["students"]);
        students.addAll(firstClass["students"]);
      }
    }

    return students;

  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<String> getStudentName(String uid) async{
  try{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    return documentSnapshot["firstname"] + " " + documentSnapshot["lastname"];


  } catch (e) {
    print(e.toString());
    return "";

  }

}

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
