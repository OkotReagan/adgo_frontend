// ignore_for_file: invalid_use_of_visible_for_testing_member, sort_child_properties_last
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import "package:images_picker/images_picker.dart";
import '../components/item_card.dart';
import '../screens/help.dart';
import '../screens/navBar.dart';
import '../screens/processImage.dart';
import 'package:dio/dio.dart';

import 'details_screen.dart';
import 'detections.dart';

enum APP_THEME { LIGHT, DARK }

class MyAppThemes {
  //Method for changing to the light theme
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

//Creating a  stateful widget...
class EmotionDetector extends StatefulWidget {
  const EmotionDetector({Key? key}) : super(key: key);

  @override
  _EmotionDetectorState createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  // Setting a default theme....
  var currentTheme = APP_THEME.LIGHT;
  bool isLoading = false;
  List posts = [];

  void getData() async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching data
    });

    try {
      print("------------------ GETTING DATA FROM THE API ------------------");

      var response =
          await Dio().get('https://emotionsdetection.onrender.com/api/items');

      setState(() {
        posts = response.data;
        isLoading = false; // Set isLoading to false after receiving data.
      });
    } catch (error) {
      // Handle error
      print(error.toString());
      setState(() {
        isLoading = false; // Set isLoading to false on error as well
      });
    }
  }

  Future<void> _refresh() async {
    getData();
  }

  void showAds(BuildContext context) {
    const delayDuration =
        Duration(seconds: 30); // Set the duration for the timer..

    Future.delayed(delayDuration, () {
      // Callback function executed after the timer completes
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetectImage()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    showAds(context);
  }


  Future dropDown(String value) async {
    // print(value);
    if (value == "Quit") {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // The ThemeData Widget is used to add global themes to the app..
      // setting the theme dynamically..
      theme: currentTheme == APP_THEME.DARK
          ? MyAppThemes.appThemeDark()
          : MyAppThemes.appThemeLight(),
      home: Scaffold(
        drawer: NavBar(),
        appBar: buildAppBarWidget(), //AppBar
        body: buildBodyWidget(), //body

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

  // AppBar of the Scaffold Widget....
  PreferredSizeWidget buildAppBarWidget() {
    return AppBar(
      // leading: IconButton(
      //   icon : const Icon(Icons.menu),
      //   onPressed: () {
      //       print("Menu being  displayed");
      //     },
      // ),
      title: const Text('AdGo', style: TextStyle(fontSize: 20)),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            print("Application is being refreshed...");
            _refresh();
          },
        ),
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            // const PopupMenuItem(
            //   value: "more",
            //   child: Text("More.."),
            // ),
            const PopupMenuItem(
              value: "Quit",
              child: Text("quit"),
            ),
          ],
          onSelected: (String value) {
            dropDown(value);
          },
        ),
      ],
    );
  }

  // building the body section
  Widget buildBodyWidget() {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SizedBox(
            height: 800.0,
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Image.asset(
                        'assets/images/x-bg.jpeg',
                        height: 250,
                        opacity: const AlwaysStoppedAnimation(.9),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      child: Container(
                          padding: const EdgeInsets.all(30.0),
                          child: const Text(
                            "Welcome to the AdGO  mobile application, built to let you navigate through your products or items with out disturbances from the ads.",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
                          )),
                      top: 140.0,
                      right: 0,
                      left: 0,
                    )
                  ],
                ),

                // Second element in the stack...
                Positioned(
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 5.0, bottom: 20.0),
                      height: 500,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          )),
                      child: Builder(
                        builder: (context) => Column(
                          children: <Widget>[
                            const Center(
                              child: Text("Available Items ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'Roboto')),
                            ),

                            Expanded(
                              child: isLoading
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator(), // Display circular progress indicator
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ListView.builder(
                                        itemCount: posts.length,
                                        itemBuilder: (context, index) =>
                                            ItemCard(
                                          post: posts[index],
                                          press: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(
                                                post: posts[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            
                          ],
                        ),
                      )),
                  right: 0,
                  left: 0,
                  top: 900.0 * 0.3,
                  bottom: 0,
                ),
              ],
            )),
      ],
    ));
  }
}
