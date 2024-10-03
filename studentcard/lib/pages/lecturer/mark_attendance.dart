import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:studentcard/machine_learning/Recognition.dart';
import 'package:studentcard/machine_learning/Recognizer.dart';
import 'package:studentcard/services/attendance_database.dart';
import 'package:studentcard/shared_components/camera_components.dart';
import 'package:studentcard/shared_components/student_table.dart';
import 'package:studentcard/styles/app_colors.dart';
import 'package:image/image.dart' as img;


class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final AttendanceDatabase _addData = AttendanceDatabase();
  List<String> sNames = [];
  List<String> sIDs = [];
  List<bool> checked = [];
  CameraComponents cc = new CameraComponents();

  initializeCamera() async{
    cc.cameras = await availableCameras();
    cc.controller = CameraController(cc.cameras[0], ResolutionPreset.high, imageFormatGroup: ImageFormatGroup.nv21);

    await cc.controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      cc.controller.startImageStream((image) => {
        if (!cc.isBusy) {cc.isBusy = true, cc.frame = image, performFaceDetection()}
      });

    });
  }


  performFaceDetection() async {
    final Map<String,dynamic> courseDetails = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    List<String> students = courseDetails["students"] as List<String>;
    List<String> studentNames = courseDetails["studentnames"] as List<String>;
    List<String> studentIds = courseDetails["studentids"] as List<String>;
    List<bool> checkBox = courseDetails["checked"] as List<bool>;


    setState(() {
      sNames = studentNames;
      sIDs = studentIds;
      checked = checkBox;
    });

    print("test");
    print(checked);
    print(studentNames);
    print(studentIds);


    InputImage? inputImage = cc.inputImageFromCameraImage();
    List<Face> faces = await cc.faceDetector.processImage(inputImage!);

    // print("fl="+faces.length.toString());
    //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
    cc.image = cc.convertNV21(cc.frame!);
    cc.image =img.copyRotate(cc.image!, angle: cc.camDirec == CameraLensDirection.front?270:90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      img.Image croppedFace = img.copyCrop(cc.image!, x:faceRect.left.toInt(),y:faceRect.top.toInt(),width:faceRect.width.toInt(),height:faceRect.height.toInt());

      //TODO pass cropped face to face recognition model
      Recognition recognition = cc.recognizer.recognize(croppedFace!, faceRect);

      if (recognition.distance > 1) {
        recognition.name = "Unknown";
      }
      cc.recognitions.add(recognition.name);
      // print("length = ${cc.recognitions.length}");

      if (cc.recognitions.length == 5 &&
          cc.highFrequencyitem(cc.recognitions) != "Unknown" &&
          students.contains(cc.highFrequencyitem(cc.recognitions))) {
        int index = students.indexOf(cc.highFrequencyitem(cc.recognitions));


        setState(() {
          checked[index] = true;
        });
        cc.recognitions.clear();
      }

      else if (cc.recognitions.length == 5 &&
          cc.highFrequencyitem(cc.recognitions) == "Unknown") {
        cc.recognitions.clear();


      }
    }




    setState(() {
      cc.isBusy = false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var options  = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    cc.faceDetector = FaceDetector(options: options);
    cc.recognizer = Recognizer();
    initializeCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cc.controller?.stopImageStream();
    cc.controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Map<String,dynamic> courseDetails = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    List<String> students = courseDetails["students"] as List<String>;
    String week = courseDetails["week"];
    String courseid = courseDetails["courseid"];
    String coursename = courseDetails["coursename"];
    String classsection = courseDetails["classsection"];
    String date = courseDetails["date"];
    String time = courseDetails["time"];
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat("dd-MM-yy").format(currentDate);
    List<String> selectedStudents = [];



    return Scaffold(
      appBar: AppBar(
        title: Text("Mark attendance"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0 ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Container(
                  height: screenWidth/2,
                  width: screenWidth/2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: SizedBox(
                      height: screenWidth/2,
                      width: screenWidth/2,
                      child: cc.controller != null ? CameraPreview(cc.controller):
                      CircularProgressIndicator(),
                    ),
                  )
              )
              ),
              SizedBox(height: 25,),
              StudentTableWidget(studentNames: sNames, studentId: sIDs, checked: checked),

              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  for (int i = 0; i < checked.length; i++) {
                    if (checked[i] == true) {
                      selectedStudents.add(students[i]);
                    }
                  }

                  await _addData.addAttendance(week, date, time, courseid, coursename, classsection, students, formattedDate);
                  Navigator.pop(context);

                },
                    child: Text("Submit", style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.LoginBtn
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
