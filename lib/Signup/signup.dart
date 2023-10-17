import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:asset/functions/auth_helper.dart';
import 'package:get/get.dart';
import '../Employee/homepage.dart';
import '../functions/Verification.dart';
import 'signin.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String _selectedRole = 'Employee';
  String _emailError = "";
  String _passwordError = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }
  void navigateToSigninPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Signin()),
    );
  }
  void navigateToHome(String userName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home(userName: userName)), // Pass the user's name to Home
    );
  }
  Future<String?> getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    if ( _emailController == null ||
        _passwordController == null ||
        _confirmPasswordController == null) {
      return Container(); // Return an empty container if controllers are not initialized
    }
    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: [
            // Background Color
            Container(
              child: Padding(
                padding: EdgeInsets.only(top:50,right: 90,left: 90), // Adjust the padding as needed
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/ghost.gif", // Adjust the image path to the location of your signup.gif file
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width, // Set the width to the screen width
                    //height: MediaQuery.of(context).size.height, // Set the height to the screen height
                  ),
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 200.0),
                    Center(
                      child: Text(
                        "WELCOME,",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0, color: Color(0xff01579B),),
                      ),
                    ),
                    Center(
                      child: Text(
                        "SIGN-UP HERE...",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color(0xff01579B)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _buildCurvedTextField("Email", _emailController),
                    if (_emailError.isNotEmpty)
                      Text(
                        _emailError,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 10.0),
                    _buildCurvedTextField("Password", _passwordController, isPassword: true),

                    if (_passwordError.isNotEmpty)
                      Text(
                        _passwordError,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 10.0),
                    _buildCurvedTextField("Confirm Password", _confirmPasswordController, isPassword: true),

                    SizedBox(height: 10.0),
                    _buildDropdownButton(),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text("SIGN UP"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff01579B), // Set the background color of the button
                      ),
                      onPressed: () async {
                        _emailError = "";
                        _passwordError = "";

                        // Validate email format
                        final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!_emailController.text.isNotEmpty || !emailPattern.hasMatch(_emailController.text)) {
                          setState(() {
                            _emailError = "Invalid email address";
                          });
                          return;
                        }// Check if the email already exists
                        try {
                          final isEmailTaken = await AuthHelper.isEmailTaken(_emailController.text);
                          if (isEmailTaken) {
                            setState(() {
                              _emailError = "Email already exists";
                            });
                            return;
                          }
                        } catch (e) {
                          print(e);
                          return;
                        }// Check password length
                        if (_passwordController.text.length < 6) {
                          setState(() {
                            _passwordError = "Password must be at least 6 characters long";
                          });
                          return;
                        }
                        try {
                          final user = await AuthHelper.signupWithEmail(

                            email: _emailController.text,
                            password: _passwordController.text,

                          );
                          if (user != null) {
                            print("Signup successful");

                            await UserHelper.saveUserWithRole(user, _selectedRole);
                            Navigator.push(context as BuildContext, MaterialPageRoute(builder: (ctx)=>const Verification()));
                            navigateToHome(user.DisplayName);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Signin()),
                            );
                          },
                          child: Text(
                            "Sign In",
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
          ],
        ),
      ),
    );
  }
  Widget _buildCurvedTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? (label == "Password" ? !_isPasswordVisible : !_isConfirmPasswordVisible) : false,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Color(0xff01579B)),
          suffixIcon: isPassword
              ? (label == "Password"
              ? IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xff01579B),
            ),
          )
              : IconButton(
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xff01579B),
            ),
          ))
              : null,
        ),
      ),
    );
  }
  Widget _buildDropdownButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButton<String>(
        value: _selectedRole,
        onChanged: (newValue) {
          setState(() {
            _selectedRole = newValue!;
          });
        },
        items: <String>['Employee', 'Admin'] // Add any other roles here
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xff01579B), // Set dropdown text color
              ),
            ),
          );
        }).toList(),
        underline: Container(), // Remove the default underline
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xff01579B),
        ),
      ),
    );
  }
}
