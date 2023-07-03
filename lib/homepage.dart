import 'package:asset/insert.dart';
import 'package:flutter/material.dart';
import 'package:asset/Signup.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>RealDB()));
            }, child: Text("Add item"))
          ],
        ),
      ),
    );
  }
}
