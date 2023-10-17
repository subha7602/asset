
import 'dart:async';
import 'package:asset/Signup/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() =>
      _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool isEmailVerified = false;
  Timer? timer;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }
  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    if (mounted) { // Add this condition
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
    }

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verification'),
            content: Text("Email Successfully Verified"),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      timer?.cancel();
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top:50,right: 90,left: 90), // Adjust the padding as needed
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/verify.gif", // Adjust the image path to the location of your signup.gif file
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width, // Set the width to the screen width
                      //height: MediaQuery.of(context).size.height, // Set the height to the screen height
                    ),
                  ),
                ),
              ),
              SizedBox(height:50),
              const Center(
                child: Text(
                  'CHECK YOUR EMAIL📩',
                  textAlign: TextAlign.center,
                style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you a Email on  ${auth.currentUser?.email}',
                    textAlign: TextAlign.center,style:TextStyle(fontSize: 16)
                  ),
                ),
              ),
              SizedBox(height:70),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xff01579B)),
                ),
                child: const Text('Resend'),
                onPressed: () {
                  try {
                    FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                  } catch (e) {
                    debugPrint('$e');
                  }
                },
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back,color:Color(0xff01579B) ),
                  TextButton(onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signin()), // Replace 'SignInPage' with your SignIn page widget
                  );}, child: Text('Go back to SignIn Page',style:TextStyle(color: Color(0xff01579B)))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
