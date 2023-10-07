import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:cue_cetera/pages/result_display.dart';
import 'package:cue_cetera/services/firebase_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});
  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

//class _videoRecord written using code from: https://bettercoding.dev/flutter/tutorial-video-recording-and-replay/
//code references in class _videoRecord also from:
// https://pub.dev/packages/camera/example
//https://stackoverflow.com/questions/64070044/how-to-record-a-video-with-camera-plugin-in-flutter
class _RecordVideoState extends State<RecordVideo> {
  late CameraController controllers;
  bool startRecordSetup = true;
  bool runningFirebase = false;
  bool startedRecording = false;
  bool videoRecorded = false;

  @override
  void initState() {
    cameraSetup();
    super.initState();
  }

  cameraSetup() async {
    final cameras = await availableCameras();
    controllers = CameraController(cameras[0], ResolutionPreset.max);
    await controllers.initialize();

    setState(() => startRecordSetup = false);
  }

  recordVideo() async {
    if (!controllers.value.isRecordingVideo) {
      await controllers.startVideoRecording();
    } else {
      final file = await controllers.stopVideoRecording();
      runningFirebase = true;
      setState(() {});
      var output = await runFirebase(file.path);
      runningFirebase = false;
      videoRecorded = false;
      setState(() {});
      //Navigator.push(context, MaterialPageRoute(builder: (context) =>  Test(file.path),));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultDisplay(file.path, output),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (startRecordSetup) {
      return Container(
        color: const Color(0xffc9b6b9),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(controllers),
            !startedRecording ? FloatingActionButton(
              backgroundColor: const Color(0xffc9b6b9),
              onPressed: !videoRecorded ? () => {
                startedRecording = true,
                setState(() {}),
                recordVideo(),
              } :
              null, // disable button if video is recorded
              child: const Icon(Icons.circle),
            ) :
            FloatingActionButton(
              backgroundColor: const Color(0xffff0000),
              onPressed: () => {
                recordVideo(),
                startedRecording = false,
                videoRecorded = true,
                setState(() {}),
              },
              child: const Icon(Icons.circle),
            ),
            runningFirebase ? const SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0
            ) :
            const SizedBox.shrink(),
          ],
        ),
      );
    }
  }
}