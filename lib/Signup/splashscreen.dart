import 'package:asset/Signup/signin.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    try {
      _controller = AnimationController(vsync: this, duration: const Duration(seconds: 7));
      _controller.forward();
    } catch (e) {
      print('Error initializing animation controller: $e');
    }
    super.initState();

    // Navigate to login screen after a delay
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) { // Check if the widget is still active
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signin()), // Replace with your login screen
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/Flow 1.json',
          repeat: false,
          controller: _controller,
        ),
      ),
    );
  }
}
