import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tflite/tflite.dart';
import 'package:dio/dio.dart';

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

//creating a  stateful widget.
class ProcessImage extends StatefulWidget {

  final File? imageFile;
  final File? imageContent;

  const ProcessImage(
      {Key? key, required this.imageFile, required this.imageContent})
      : super(key: key);

  @override
  _ProcessImageState createState() => _ProcessImageState();
}

class _ProcessImageState extends State<ProcessImage> {

  Dio dio = new Dio();
 
  List? _result;
  String _name = '';
  String _confidence = '';

  //Setting a default theme
  var currentTheme = APP_THEME.LIGHT;



   // loading model in flutter
  loadModel() async {
    //  model for the classifier
    var resultant = await Tflite.loadModel(
        labels: 'assets/models/emotion-detection.txt',
        model: "assets/models/emotion-detection.tflite");

    print("Resultant after loading model :$resultant");
  }



  Future classifyImage(File image) async {

     print("------------------ detecting the class prediction class from  here ------------------");

     var result = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.2,
        imageMean: 0.0,
        imageStd: 255.0,
        asynch: true
     );

    print("-----------------Getting results from the model-----------------");
    
    print(result);

    setState(() {
      
      _result = result;
    
      String str = _result![0]['label'];

      _name = str.substring(2);

      _confidence = _result != null
          ? (_result![0]['confidence'] * 100.0).toString().substring(0, 2) + '%'
          : "";
    });

 }
   
// Intializing  the model ready for inference
   @override
  void initState() {
    super.initState();
    loadModel();
  }

  //closing  or resources after use
  @override
  void dispose() {
     // tflite.close();
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
        body: buildBodyWidget(widget.imageFile! ),

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
    title: const Text('Pneumosarscov2', style: TextStyle(fontSize: 20)),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          print("application is being refreshed.");
        },
      ),
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          print("more verting in the application.");
        },
      ),
    ],
  );
}

// building the body section
Widget buildBodyWidget(File imagepath) {
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
            //first child of the stack
            Container(
              width: double.infinity,
              height: 350,
              margin: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: imagepath != null
                  ? Image.file(imagepath, fit: BoxFit.cover, height: 250)
                  : const Text("image not uploaded",
                      style: TextStyle(color: Colors.black)),
            ),

            //Second child of the stack

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
                    const Text('Diagnosis of chest images is one of the most trivial processes, but technology is here to assist you as a radiologist.Click on the button below to get assistive information about the possible diseases in the above chest image.',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            color: Color.fromARGB(255, 12, 49, 25),
                            )),

                    Container(
                      width: 100.0,
                      height: 120.0,
                      margin: const EdgeInsets.only(top: 30.0, bottom: 5.0),
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          // call  the function to process image on the apply model file
                          classifyImage(imagepath);
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 90.0,
                                width: 90.0,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Image.asset(
                                  'assets/images/process.png',
                                  fit: BoxFit.cover,
                                )),
                            const Text(
                              "Tap to Scan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),
                    ),

                     //Rendering the sized box conditionally
                    _name != ''
                        ? (SizedBox(
                            height: 60.0,
                            child: Text(
                              "PREDICTION:\n MESSAGE: $_name \nCONFIDENCE: $_confidence",
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ))
                        : (const Text(''))
                    
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




