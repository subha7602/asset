import 'dart:async';

import 'package:flutter/material.dart';
import'package:asset/functions/auth_helper.dart';
class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late Timer timer;
  @override
  void initState(){
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }
  @override
  void dispose(){
    timer.cancel();
        super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  Future<void> checkEmailVerified() async{
    
  }
}
