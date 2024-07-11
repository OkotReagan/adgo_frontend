import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../main.dart';
import 'body.dart';

//Creating a  stateful widget.....
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

final Dio _dio = Dio();

Future<void> registerUser() async {
  // Set the API endpoint and request body
  final String url = 'your_registration_api_endpoint';
  final Map<String, dynamic> data = {
    'email': email, // Use the email entered by the user
    'password': password, // Use the password entered by the user
  };

  try {
    // Show the progress indicator
    setState(() {
      isAPIcallProcess = true;
    });

    // Make the API request
    final Response response = await _dio.post(url, data: data);

    // Check the response status
    if (response.statusCode == 200) {
      // Registration successful, navigate to the next screen
      Navigator.pushNamed(context, '/next_screen');
    } else {
      // Registration failed, display an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Unable to register. Please try again.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  } catch (error) {
    // Error occurred during the API call, display an error message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('An error occurred. Please try again.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  } finally {
    // Hide the progress indicator
    setState(() {
      isAPIcallProcess = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
          backgroundColor: HexColor("#283B71"),
          body: ProgressHUD(
            child: Form(key: globalFormKey, child: _loginUI(context)),
            inAsyncCall: isAPIcallProcess,
            opacity: 0.3,
            key: UniqueKey(),
          ),
        )));
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/emotion.png",
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
            child: Center(
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          FormHelper.inputFieldWidget(
            context,
            "email",
            "Email",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Username can \'t be  empty.";
              }

              return null;
            },
            (onSavedVal) {
              // Handle the onChanged event here
              email = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIcon: const Icon(Icons.person),
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FormHelper.inputFieldWidget(context, "password", "Password",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Password can \'t be  empty.";
              }

              return null;
            }, (onSavedVal) {
              // Handle the onChanged event here.....
              password = onSavedVal;
            },
                borderFocusColor: Colors.white,
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                borderRadius: 10,
                obscureText: hidePassword,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Colors.white.withOpacity(0.7),
                    icon: Icon(hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility))),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 14.0),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'Forgot Password ?',
                        style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Forgot Password");
                          })
                  ])),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Login",
              () {
                print("logging in........");
              },
              btnColor: HexColor('#283B71'),
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 14.0),
                      children: <TextSpan>[
                    const TextSpan(text: "Don't have an account"),
                    TextSpan(
                        text: 'Register ?',
                        style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                            print(" Registering..");
                          })
                  ])),
            ),
          ),
        ],
      ),
    );
  }
}
