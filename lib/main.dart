import 'package:asset/Admin/AdminHomePage.dart';
import 'package:asset/Employee/homepage.dart';
import 'package:asset/Signup/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage( _firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error occurred'),),);}
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(snapshot.data!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final userDoc = snapshot.data;
                      final userData = userDoc?.data();
                      if (userData != null &&
                          userData is Map<String, dynamic>) {
                        final userRole = userData['role'] as String;
                        print("User Role: $userRole");
                        if (userRole == 'Employee') {
                          return
                          Home();
                        } else {
                          return AdminHomePage(
                            context: context,
                          );
                        }
                      } else {
                        return Text(
                            "User data is missing or not in the expected format");
                      }
                    } else {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ));}},);}
              // If user is not authenticated, show SplashScreen again
              return SplashScreen();
            },
          );
        },
      ),
      navigatorKey: navigatorKey,

    );
  }
}
