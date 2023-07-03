import 'package:asset/functions/authFunctions.dart';

import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the Homepage widget
import 'signin.dart'; // Import the SigninPage widget

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();
  bool isLogin = false;
  String email = '';
  String password = '';
  String username = '';

  void navigateToHomePage() {
    Navigator.pushReplacement( // Replace current route with the Homepage
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void navigateToSigninPage() {
    Navigator.pushReplacement( // Replace current route with the signin page (SigninPage)
      context,
      MaterialPageRoute(builder: (context) => Signin()),
    );
  }

  void navigateToSignupPage() {
    Navigator.pushReplacement( // Replace current route with the signup page (Authenticate)
      context,
      MaterialPageRoute(builder: (context) => Signup()),
    );
  }

  void signinUser() {
    signin(email, password).then((_) {
      navigateToHomePage(); // Navigate to Homepage after successful signin
    });
  }

  void signupUser() {
    sigunup(email, password).then((_) {
      navigateToSigninPage(); // Navigate to signin page after successful signup
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !isLogin
                  ? TextFormField(
                key: ValueKey('username'),
                decoration: InputDecoration(hintText: "Enter Username"),
                validator: (value) {
                  if (value.toString().length < 6) {
                    return 'Username is too small';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    username = value!;
                  });
                },
              )
                  : Container(),
              TextFormField(
                key: ValueKey('email'),
                decoration: InputDecoration(hintText: "Enter Email"),
                validator: (value) {
                  if (!value.toString().contains('@')) {
                    return 'Invalid email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                key: ValueKey('password'),
                decoration: InputDecoration(hintText: "Password"),
                validator: (value) {
                  if (value.toString().length < 6) {
                    return 'Password is too small';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();
                    isLogin ? signinUser() : signupUser();
                  }
                },
                child: isLogin ? Text('Login') : Text('Sign-up'),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: isLogin
                    ? Text('Don\'t have an account? Sign up')
                    : Text('Already Signed up? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
