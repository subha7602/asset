import 'package:asset/Signup/forget.dart';
import 'package:asset/functions/Verification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asset/Signup/signup.dart';
import 'package:asset/functions/auth_helper.dart';
import 'package:asset/Admin/AdminHomePage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Employee/homepage.dart';

void main() {
  runApp(MaterialApp(
    home: Signin(),
  ));
}

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _emailValid = true;
  bool _passwordValid = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  void navigateToHome(String role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        if (role == 'Admin') {
          return AdminHomePage(context: context);
        } else {
          return Home(userEmail: _emailController.text);
        }
      }),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Stack(
            children: [
        // Background Image
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff01579B),
                ),
                child: Image.asset(
                  "assets/login gif.gif", // Adjust the image path
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 280),
                  Center(
                    child: Text(
                      "WELCOME BACK!!!",
                      style:GoogleFonts.nunito( textStyle:TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0,color: Color(0xff01579B)),
                    ),)
                  ),
                  Center(
                    child: Text(
                      "LOGIN HERE",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0,color: Color(0xff01579B)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: Color(0xff01579B)),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // Set enabled border color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // Set focused border color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _emailValid = isValidEmail(value);
                      });
                    },
                  ),
                  if (!_emailValid)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Enter a valid email",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      hintStyle: TextStyle(color: Color(0xff01579B)),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // Set enabled border color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // Set focused border color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,color: Color(0xff01579B),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _passwordValid = value.length >= 6;
                      });
                    },
                  ),
                  if (!_passwordValid)
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Password must be at least 6 characters long",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Forget(),
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Align(alignment: Alignment.centerRight,
                          child: Text('Forget Password ?',style: TextStyle(color:Color(0xff01579B), ),)),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      // Expanded(
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Color(0xff01579B),
                      //
                      //     ),
                      //     onPressed: () async {
                      //       if (_emailController.text.isEmpty ||
                      //           _passwordController.text.isEmpty) {
                      //         print("Email and password cannot be empty");
                      //         return;
                      //       }
                      //       try {
                      //         final user = await AuthHelper.signInWithEmail(
                      //             email: _emailController.text,
                      //             password: _passwordController.text);
                      //         if (user != null) {
                      //           print("login successful");
                      //           final userDoc = await FirebaseFirestore.instance
                      //               .collection("users")
                      //               .doc(user.uid)
                      //               .get();
                      //           final userData =
                      //           userDoc.data() as Map<String, dynamic>;
                      //           navigateToHome(userData['role']);
                      //                                       }
                      //       } catch (e) {
                      //         print(e);
                      //       }
                      //     },
                      //     child: Text(
                      //       "LOGIN",
                      //       style: TextStyle(fontSize: 16.0),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff01579B),
                          ),
                          onPressed: () async {
                            if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                              print("Email and password cannot be empty");
                              return;
                            }
                            try {
                              final user = await AuthHelper.signInWithEmail(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              if (user != null) {
                                print("login successful");
                                final userDoc = await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .get();
                                final userData = userDoc.data() as Map<String, dynamic>;
                                navigateToHome(userData['role']);
                              }
                            } catch (e) {
                              print(e);
                              // Show the SnackBar with the error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid password'),
                                  backgroundColor: Color(0xff01579B),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Are You a New User?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Signup()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xff01579B), // Set the text color to the desired color
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
    ],),
      ),);
  }
}
