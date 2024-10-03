import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import 'package:studentcard/machine_learning/Recognizer.dart';
import 'package:studentcard/machine_learning/Recognition.dart';
import 'package:studentcard/styles/app_text.dart';



class BiometricRegistration extends StatefulWidget {
  const BiometricRegistration({super.key});

  @override
  State<BiometricRegistration> createState() => _BiometricRegistrationState();
}

class _BiometricRegistrationState extends State<BiometricRegistration> {
  User? user = FirebaseAuth.instance.currentUser;
  late List<CameraDescription> cameras;
  dynamic controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];


  // todo declare face detector
  late FaceDetector faceDetector;

  // todo declare face recognizer
  late Recognizer recognizer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var options  = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);
    recognizer = Recognizer();

    initializeCamera();

  }


  CameraImage? frame;
  initializeCamera() async{
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.medium, imageFormatGroup: ImageFormatGroup.nv21);

    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.stopImageStream();
    controller?.dispose();
    super.dispose();
  }

  img.Image? image;
  performFaceDetection() async {
    InputImage? inputImage = _inputImageFromCameraImage();
    List<Face> faces = await faceDetector.processImage(inputImage!);

    // print("fl="+faces.length.toString());
    //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = _convertNV21(frame!);
    image =img.copyRotate(image!, angle: camDirec == CameraLensDirection.front?270:90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      img.Image croppedFace = img.copyCrop(image!, x:faceRect.left.toInt(),y:faceRect.top.toInt(),width:faceRect.width.toInt(),height:faceRect.height.toInt());

      //TODO pass cropped face to face recognition model
      Recognition recognition = recognizer.recognize(croppedFace!, faceRect);

      // print(recognition.embeddings);
      recognitions.add(recognition);
    }

    print("total length= ${recognitions.length}");
    if (recognitions.length == 10) {
      recognizer.registerFaceInDB(user!.uid, recognitions[3].embeddings);
      recognizer.registerFaceInDB(user!.uid, recognitions[6].embeddings);
      recognizer.registerFaceInDB(user!.uid, recognitions[9].embeddings);
      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text('Face registered successfully !'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

    setState(() {
      isBusy = false;
    });

  }


  static img.Image _convertNV21(CameraImage image) {

    final width = image.width.toInt();
    final height = image.height.toInt();

    Uint8List yuv420sp = image.planes[0].bytes;

    final outImg = img.Image(height:height, width:width);
    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0)
          r = 0;
        else if (r > 262143) r = 262143;
        if (g < 0)
          g = 0;
        else if (g > 262143) g = 262143;
        if (b < 0)
          b = 0;
        else if (b > 262143) b = 262143;

        // I don't know how these r, g, b values are defined, I'm just copying what you had bellow and
        // getting their 8-bit values.
        outImg.setPixelRgb(i, j, ((r << 6) & 0xff0000) >> 16,
            ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
      }
    }
    return outImg;
  }



  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  //TODO convert CameraImage to InputImage
  InputImage? _inputImageFromCameraImage() {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
      _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) {
        return null;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null)
    {
      return null;}

    // get image format
    final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21))
    {
      return null;}

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (frame!.planes.length != 1) {
      return null;
    }
    final plane = frame!.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Face Registration"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
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
                      child: controller != null ? CameraPreview(controller):
                      CircularProgressIndicator(),
                    ),
                  )
                // child: CameraPreview(cameraController),
                // height: 200,
              ),
            ),
            SizedBox(height: 40,),
            Container(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Instructions : ", style: AppText.infoText,),
                  Text("1. Press the button below to register your face.", style: AppText.infoText_2,),
                  Text("2. Place your face inside the circle for 10 seconds.", style: AppText.infoText_2,),
                ],
              ),

            ),

            SizedBox(height: screenHeight*0.2,),



            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border : Border.all(
                  color: Colors.black,
                  width: 3.0,),
              ),
              child: ElevatedButton(
                onPressed: (){
                  controller.startImageStream((image) => {
                    if (!isBusy) {isBusy = true, frame = image, performFaceDetection()}
                  });

                },
                child: Text(""),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffD9D9D9),

                ),
              ),

            ),


          ],
        ),
      ),

    );
  }
}
