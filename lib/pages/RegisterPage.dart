import 'package:app/app.dart';
import 'package:app/pages/LogInPage.dart';
import 'package:app/utils/SD.dart';
import 'package:app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // Variables to store form data
  String _username = '';
  String _email = '';
  String _password = '';

  void submit() {
    bool flag = _formKey.currentState!.validate();
    if (flag) {
      _formKey.currentState!.save();
      signUp(_email, _password, _username);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    UserCredential? userCredential = null;
    try {
      // sign up
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user ID
      String uid = userCredential.user?.uid ?? "";

      // create profile
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        "profileImageUrl": SD["anonimousProfileImage"]
      });

      String message = "User signed up successfully!";
      toastification.show(
        context: context, // optional if you use ToastificationWrapper
        title: Text(
          message,
          maxLines: 10, // Limit to 2 lines
          overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // redirect to  log in page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage()),
      );
      print(message);
    } catch (e) {
      if (e is FirebaseAuthException) {
        // roll back
        await userCredential?.user?.delete();
      }

      String message = "Error signing up: $e";
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.theme,
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: boxWidth,
              height: boxWidth * 1.4,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: Colors.black, spreadRadius: 3),
                ],
                borderRadius:
                    BorderRadius.circular(12.0), // Apply rounded corners
                color: AppColors.backgroundSwatch.shade300,
              ),
              child: Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 28, // Larger font size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Colors.blueAccent, // Blue accent color
                      letterSpacing: 2.0, // Extra letter spacing
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: boxWidth * 0.9, // Maximum width
                        minWidth: 200, // Minimum width
                      ),
                      child: TextFormField(
                        onSaved: (value) {
                          _username = value.toString();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your user name';
                          } else if (value.toString().length < 3 ||
                              value.toString().length > 30) {
                            return 'usrename should between 3 and 30 characters long';
                          }
                          return null; // Validation passed
                        },
                        decoration: const InputDecoration(
                          labelText: 'user name', // Label for the text field
                          labelStyle: TextStyle(
                            fontSize: 14, // Larger font size
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.blueAccent, // Blue accent color
                            letterSpacing: 2.0, // Extra letter spacing
                          ),
                          border:
                              OutlineInputBorder(), // Adds a border to the field
                        ),
                        style: const TextStyle(
                          fontSize: 20, // Font size for entered text
                          fontWeight:
                              FontWeight.bold, // Bold text for entered text
                          color: Colors.black, // Text color for entered input
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: boxWidth * 0.9, // Maximum width
                        minWidth: 200, // Minimum width
                      ),
                      child: TextFormField(
                        onSaved: (value) {
                          _email = value.toString();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          RegExp emailRegex = RegExp(
                            r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                            caseSensitive: true,
                          );
                          if (!emailRegex.hasMatch(value.toString())) {
                            return "email is not valid";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'email', // Label for the text field
                          labelStyle: TextStyle(
                            fontSize: 14, // Larger font size
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.blueAccent, // Blue accent color
                            letterSpacing: 2.0, // Extra letter spacing
                          ),
                          border:
                              OutlineInputBorder(), // Adds a border to the field
                        ),
                        style: const TextStyle(
                          fontSize: 20, // Font size for entered text
                          fontWeight:
                              FontWeight.bold, // Bold text for entered text
                          color: Colors.black, // Text color for entered input
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: boxWidth * 0.9, // Maximum width
                        minWidth: 200, // Minimum width
                      ),
                      child: TextFormField(
                        onSaved: (value) {
                          _password = value.toString();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          RegExp strongPasswordRegex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$',
                            caseSensitive: true,
                          );
                          if (!strongPasswordRegex.hasMatch(value.toString())) {
                            return """
                            Has minimum 8 characters in length
                            At least one uppercase English letter
                            At least one lowercase English letter
                            At least one digit
                            At least one special character
                            """
                                .trim();
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'password', // Label for the text field
                          labelStyle: TextStyle(
                            fontSize: 14, // Larger font size
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.blueAccent, // Blue accent color
                            letterSpacing: 2.0, // Extra letter spacing
                          ),
                          border:
                              OutlineInputBorder(), // Adds a border to the field
                        ),
                        style: const TextStyle(
                          fontSize: 20, // Font size for entered text
                          fontWeight:
                              FontWeight.bold, // Bold text for entered text
                          color: Colors.black, // Text color for entered input
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: submit,
                      child: const Text(
                        "submit",
                        style: TextStyle(
                          fontSize: 20, // Larger font size
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.blueAccent, // Blue accent color
                          letterSpacing: 2.0, // Extra letter spacing
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInPage()),
                      );
                    },
                    child: const Text(
                      "goto logIn",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
