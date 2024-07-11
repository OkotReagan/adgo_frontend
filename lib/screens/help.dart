import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';

// creating a stateful widget in flutter.
class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        // theme: ThemeData(primaryColor: Colors),
        home: Scaffold(
            appBar: buildAppBarWidget(context),
            body: Container(
                padding: const EdgeInsets.all(30.0),
                child: Stepper(
                  steps: const [
                    Step(
                        title: Text('Step 1'),
                        content: Text(
                            'Start observation through use of the surveillence of the camera.')),
                    Step(
                        title: Text('Step 2'),
                        content: Text(
                            'If images are already taken , import and submit them for processing.')),
                    Step(
                        title: Text('Step 3'),
                        content: Text(
                            'Incase you are in need of any setting , tap the settings button and change any setting you want.')),
                    Step(
                        title: Text('Step 4'),
                        content: Text(
                            'Tap the refresh icon inorder to reload the application incase of any slow functionality.')),
                    Step(
                        title: Text('Step 5'),
                        content: Text(
                            'Tap the lefthand arrow to go back to the prvious screen.')),
                    Step(
                        title: Text('Step 6'),
                        content: Text(
                            'Tap on the more_vert icon incase you want to quit or log out from the app.')),
                  ],
                  onStepTapped: (int newIndex) {
                    setState(() {
                      _currentStep = newIndex;
                    });
                  },
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep != 5) {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep != 0) {
                      setState(() {
                        _currentStep -= 1;
                      });
                    }
                  },
                ))));
  }
}

// AppBar of the Scaffold Widget.
PreferredSizeWidget buildAppBarWidget(BuildContext context) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 21, 76, 121),
    leading: IconButton(
        icon: SvgPicture.asset(
          "assets/icons/back.svg",
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context)),
    title: const Text('Help', style: TextStyle(fontSize: 25)),
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
