import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import '../main.dart';
import 'body.dart';

enum APP_THEME { LIGHT, DARK }

class MyAppThemes {
  //Method for changing to the light theme...
  static ThemeData appThemeLight() {
    return ThemeData(
      // Define the default brightness and colors for the overall app.
      brightness: Brightness.light,
      //appBar theme
      appBarTheme: const AppBarTheme(
        //ApBar's color
        color: Color.fromARGB(255, 21, 76, 121),

        //Theme for AppBar's icons
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      //Theme for app's icons
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),

      //Theme for FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //White background
        backgroundColor: Colors.white,

        //Black plus (+) sign for FAB
        foregroundColor: Colors.black,
      ),
    );
  }

  // Method for changing to the dark theme.
  static ThemeData appThemeDark() {
    return ThemeData(
      brightness: Brightness.dark,

      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      //Theme for FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //dark background for FAB
        backgroundColor: Colors.black,

        //White plus (+) sign for FAB
        foregroundColor: Colors.white,
      ),
    );
  }
}

//Creating a  stateful widget.
class DetectImage extends StatefulWidget {
  const DetectImage({super.key});

  @override
  _DetectImageState createState() => _DetectImageState();
}

class _DetectImageState extends State<DetectImage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  // Setting a default theme.....
  var currentTheme = APP_THEME.LIGHT;

  void loadCamera(BuildContext context) {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            // run the model ...
            runModel(context);
          });
        });
      }
    });
  }

  // Loading model in flutter..
  loadModel() async {
    //  model for the classifier
    var resultant = await Tflite.loadModel(
        labels: 'assets/models/emotion-detection.txt',
        model: "assets/models/emotion-detection.tflite");

    print("Resultant after loading model :$resultant");
  }

  runModel(BuildContext context) async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);

      predictions!.forEach((element) {
        setState(() {
          
          output = element['label'].substring(2);

          if (output == 'sad') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmotionDetector()),
            );
            print("user is sad....");
          } else {
            print("user is not sad....");
          }
        });
      });
    }
  }

  // Intializing  the model ready for inference...
  @override
  void initState() {
    super.initState();
    loadCamera(context);
    loadModel();
  }

  //closing  or resources after use
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // the ThemeData Widget is used to add global themes to the app.
      // setting the theme dynamically.
      theme: currentTheme == APP_THEME.DARK
          ? MyAppThemes.appThemeDark()
          : MyAppThemes.appThemeLight(),
      home: Scaffold(
        appBar: buildAppBarWidget(context),
        body: buildBodyWidget(),

        //Code for FAB (floating Action button)
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.threesixty),
          onPressed: () {
            setState(() {
              // Currently selected theme toggles when FAB is pressed
              currentTheme == APP_THEME.DARK
                  ? currentTheme = APP_THEME.LIGHT
                  : currentTheme = APP_THEME.DARK;
            });
          },
        ),
      ),
    );
  }

  // AppBar of the Scaffold Widget.
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/back.svg",
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      title: const Text('Ad Detections', style: TextStyle(fontSize: 20)),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            print("Application is being refreshed.");
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            print("More verting in the application...");
          },
        ),
      ],
    );
  }

  // Building the body section...
  Widget buildBodyWidget() {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          height: 800.0,
          color: Colors.black,
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: Stack(
            children: <Widget>[
              //First child of the stack...
              Container(
                  width: double.infinity,
                  height: 350,
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: !cameraController!.value.isInitialized
                      ? Container()
                      : AspectRatio(
                          aspectRatio: cameraController!.value.aspectRatio,
                          child: CameraPreview(cameraController!),
                        )),

              // Second child of the stack...

              Positioned(
                // ignore: sort_child_properties_last
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
                  height: 500,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      )),
                  child: Column(
                    children: <Widget>[
                      Text(
                        output,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Container(
                        width: 350.0,
                        height: 300.0,
                        margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            // call  the function to process image on the apply model file

                            print("Tapped handle model ...");
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 250,
                                  width: 300,
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: Image.asset(
                                    'assets/images/ads.jpg',
                                    fit: BoxFit.cover,
                                  )),
                              const Text(
                                "Advert",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                right: 0,
                left: 0,
                top: 360.0,
              )
            ],
          ),
        ),
      ],
    ));
  }
}
