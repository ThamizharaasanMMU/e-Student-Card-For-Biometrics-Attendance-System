import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:collection/collection.dart';
import 'package:studentcard/machine_learning/Recognizer.dart';
import 'package:studentcard/machine_learning/Recognition.dart';
import 'package:studentcard/services/course_database.dart';
import 'package:studentcard/shared_components/camera_components.dart';
import 'package:studentcard/styles/app_colors.dart';
import 'package:studentcard/styles/app_text.dart';


class ExamRecognition extends StatefulWidget {
  const ExamRecognition({super.key});

  @override
  State<ExamRecognition> createState() => _ExamRecognitionState();
}

class _ExamRecognitionState extends State<ExamRecognition> {
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
  final Map<String, dynamic> studentsList = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  final List<String> students = (studentsList["students"] as List<dynamic>).cast<String>();
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
  }
  if (cc.recognitions.length == 5 && cc.highFrequencyitem(cc.recognitions) != "Unknown" && students.contains(cc.highFrequencyitem(cc.recognitions)))  {
    String studName = await (getStudentName(cc.highFrequencyitem(cc.recognitions)));
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[500],
          title: const Text("Face Recognized !", textAlign: TextAlign.center), alignment: Alignment.center,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: 300,
              width: 300,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Student Verification Status : SUCCESS", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )),
                  SizedBox(height: 10,),
                  Text("Student Name : ${studName}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: 10,),
                  // Text(getStudentName(cc.highFrequencyitem(cc.recognitions)) as String),
                  Text("The student is authorized to proceed with the exam"),
                  Spacer(),
                  Center(
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.LoginBtn,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),

                ],
              )
            ),
          ),


        ));
    // Navigator.of(context).pushNamed('/view_studentcard', arguments: cc.highFrequencyitem(cc.recognitions));
    cc.recognitions.clear();

  }

  else if (cc.recognitions.length == 5 && cc.highFrequencyitem(cc.recognitions) != "Unknown" && !students.contains(cc.highFrequencyitem(cc.recognitions)) ||
      (cc.recognitions.length == 5 && cc.highFrequencyitem(cc.recognitions) == "Unknown"))  {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[500],
          title: const Text("Face Recognized !", textAlign: TextAlign.center), alignment: Alignment.center,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
                height: 300,
                width: 300,
                child : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Student Verification Status : FAILED", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    )),
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    // Text(getStudentName(cc.highFrequencyitem(cc.recognitions)) as String),
                    Text("The student is NOT authorized to proceed with the exam"),
                    Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.LoginBtn,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),

                  ],
                )
            ),
          ),


        ));
    // Navigator.of(context).pushNamed('/view_studentcard', arguments: cc.highFrequencyitem(cc.recognitions));
    cc.recognitions.clear();

  }

  // else if (cc.recognitions.length == 5 && cc.highFrequencyitem(cc.recognitions) == "Unknown") {
  //   Navigator.pop(context);
  //   cc.recognitions.clear();
  // }


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

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Verification"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}
