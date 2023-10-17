import 'package:asset/Admin/ReviewBill.dart';
import 'package:asset/Admin/ReviewTasks.dart';
import 'package:asset/Employee/Status.dart';
import 'package:asset/Signup/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/auth_helper.dart';
 // Import the ReviewPage

class AdminHomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AdminHomePage({required BuildContext context});

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Signin()),
            (Route<dynamic> route) =>
        false, // Remove all existing routes from the stack.
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff01579B),
      appBar:AppBar(
        backgroundColor:  Color(0xff01579B),
        elevation: 25,
        title: FittedBox(
          fit: BoxFit.cover,
          child: Text(
            'ADMIN-HOME',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        actions: <Widget>[

          Center(
              child:OutlinedButton(
                onPressed: () {
                  AuthHelper.logOut();
                  _logout(context);

                },
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.white, // Set the border color to white
                      width: 2, // Adjust the border width as needed
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        width: 5,
                        color: Colors.white, // Set the border color to white
                      ),
                    ),
                  ),
                ),
                child: Text(
                  "LOG-OUT",
                  style: TextStyle(
                    //fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )


          ),
        ],
      ),
      body: Align(
        alignment: AlignmentDirectional(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top:40,bottom: 60.0,left: 100,right: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/admin.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
              child: Text(
                'Manage the bill approvals and tasks easily, efficiently within seconds by using our Application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  // fontFamily: 'Plus Jakarta Sans',
                  color: Colors.white,  // Set the text color to white
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,  // Set the container background color to white
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Color(0x33000000),
                        offset: Offset(0, -1),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => ReviewBill(),
                                            ),
                                          ),
                                          child: Container(
                                            width: 237,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color:  Color(0xff01579B),  // Set the container background color to blue
                                              border: Border.all(
                                                color:   Color(0xff01579B),  // Set the container border color to white
                                                width: 4,  // Set the border width to 1
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,  // Center the children horizontally
                                              children: [
                                                Text(
                                                  'REVIEW BILL',

                                                  style: TextStyle(
                                                    color: Colors.white,  // Set the text color to white
                                                    fontWeight: FontWeight.bold,
                                                    //   fontFamily: 'Plus Jakarta Sans',
                                                    fontSize: 16,

                                                  ),
                                                ),
                                                SizedBox(width:25),
                                                Icon(Icons.check_circle_sharp, color: Colors.white),  // Set the icon color to white
                                              ],
                                            ),
                                          )


                                      ),
                                      SizedBox(height: 20,),
                                      GestureDetector(
                                          onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => ReviewTask(),
                                            ),
                                          ),
                                          child: Container(
                                            width: 237,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color:  Color(0xff01579B),  // Set the container background color to blue
                                              border: Border.all(
                                                color:   Color(0xff01579B),  // Set the container border color to white
                                                width: 4,  // Set the border width to 1
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,  // Center the children horizontally
                                              children: [
                                                Text(
                                                  'REVIEW TASKS',

                                                  style: TextStyle(
                                                    color: Colors.white,  // Set the text color to white
                                                    fontWeight: FontWeight.bold,
                                                    //   fontFamily: 'Plus Jakarta Sans',
                                                    fontSize: 16,

                                                  ),
                                                ),
                                                SizedBox(width:25),
                                                Icon(Icons.table_view_sharp, color: Colors.white),  // Set the icon color to white
                                              ],
                                            ),
                                          )


                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
