import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:collection/collection.dart';
import 'package:studentcard/machine_learning/Recognizer.dart';
import 'package:studentcard/machine_learning/Recognition.dart';


class FaceRecognition extends StatefulWidget {
  const FaceRecognition({super.key});

  @override
  State<FaceRecognition> createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  late List<CameraDescription> cameras;
  dynamic controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[0];
  CameraLensDirection camDirec = CameraLensDirection.back;
  late List<String> recognitions = [];


  // todo declare face detector
  late FaceDetector faceDetector;

  // todo declare face recognizer
  late Recognizer recognizer;

  String detectedName = "";


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
    controller = CameraController(cameras[0], ResolutionPreset.high, imageFormatGroup: ImageFormatGroup.nv21);

    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
        if (!isBusy) {isBusy = true, frame = image, performFaceDetection()}
      });

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.stopImageStream();
    controller?.dispose();
    super.dispose();
  }

  int countOccurrences(List<String> list, String target) {
    return list.where((element) => element == target).length;
  }

  String highFrequencyitem(List<String> list) {
    int counter = 0;
    String str = list[0];

    list.forEach((i) {
      int current_freq = countOccurrences(list, i);
      if (current_freq > counter){
        counter = current_freq;
        str = i;
      }

    });
    return str;
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

      if (recognition.distance > 1) {
        recognition.name = "Unknown";
      }

      setState(() {
        detectedName = recognition.name;
      });

      recognitions.add(recognition.name);
    }
    if (recognitions.length == 5 && highFrequencyitem(recognitions) != "Unknown") {
      Navigator.of(context).pushNamed('/view_studentcard', arguments: highFrequencyitem(recognitions));
      recognitions.clear();

    }
    if (recognitions.length == 5 && highFrequencyitem(recognitions) == "Unknown") {
      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text('Face Recognition FAILED !'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      recognitions.clear();
    }

    if (faces.length == 0) {
      setState(() {
        detectedName = "No face detected";
      });
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
    final camera = cameras[0];
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
                    child: controller != null ? CameraPreview(controller):
                    CircularProgressIndicator(),
                  ),
                )
              // child: CameraPreview(cameraController),
              // height: 200,
            ),
          ),
          // Text(detectedName),

        ],
      ),

    );
  }
}
