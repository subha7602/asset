// TODO Implement this library.
import 'package:asset/functions/authFunctions.dart';
import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the Homepage widget

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void navigateToHomePage() {
    Navigator.pushReplacement( // Replace current route with the Homepage
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void signinUser() {
    // Perform the signin logic
    // Example: authenticate user with email and password
    signin(email, password).then((_) {
      navigateToHomePage(); // Navigate to Homepage after successful signin
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
                    signinUser();
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
