import 'package:app/pages/RegisterPage.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  // Variables to store form data
  String _email = '';
  String _password = '';

  void submit() {
    bool flag = _formKey.currentState!.validate();
    if (flag) {
      _formKey.currentState!.save();
      print(_password);
      print(_email);
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
                    "LogIn",
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
                        onSaved: (value) {
                          _email = value.toString();
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
                        onSaved: (value) {
                          _password = value.toString();
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
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "goto register",
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
