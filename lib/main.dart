import 'package:flutter/material.dart';
import './screens/body.dart';
import 'package:camera/camera.dart';
import 'screens/RegisterScreen.dart';
import 'screens/detections.dart';
import 'screens/loginScreen.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();  
    cameras = await availableCameras().then((value) => value.where((camera) => camera.lensDirection == CameraLensDirection.front).toList());;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application....
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EMOTIONDETECTION',
        home: EmotionDetector(),
        // routes: {
        //   '/' : (context) =>  const Login(),
        //   '/register' : (context) =>  const Register(),
        //   '/feed' : (context) => const  EmotionDetector()
        // },
        debugShowCheckedModeBanner: false,
      );
}




