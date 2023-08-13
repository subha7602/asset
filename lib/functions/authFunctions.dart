import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';
FirebaseAuth _auth = FirebaseAuth.instance;
// sigunup(String email,String password) async {
//
//   try {
//     final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       print('The password provided is too weak.');
//     } else if (e.code == 'email-already-in-use') {
//       print('The account already exists for that email.');
//     }
//   } catch (e) {
//     print(e);
//   }
// }
// signin(String email,String password) async {
//   try {
//     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password
//     );
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'user-not-found') {
//       print('No user found for that email.');
//     } else if (e.code == 'wrong-password') {
//       print('Wrong password provided for that user.');
//     }
//   }
// }
signin({required String email, required String password}) async {
  final res = await _auth.signInWithEmailAndPassword(
      email: email, password: password);
  final User? user = res.user;
  return user;
}
signup({required String email, required String password}) async {
  final res = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
  final User? user = res.user;
  return user;
}

signInWithGoogle() async {
  GoogleSignIn googleSignIn = GoogleSignIn();

  final acc = await googleSignIn.signIn();

  if (acc != null) {
    final auth = await acc.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    final res = await _auth.signInWithCredential(credential);

    return res.user;
  } else {
    return null;
  }
}


class UserHelper{
  static FirebaseFirestore _db=FirebaseFirestore.instance;
  static saveUser(User user)async{
    PackageInfo packageInfo=await PackageInfo.fromPlatform();
    int buildNumber=int.parse(packageInfo.buildNumber);
    Map<String,dynamic>userData={
      "name":user.displayName,
      "email":user.email,
      "last_login":user.metadata.lastSignInTime?.millisecondsSinceEpoch,
    "created_at":user.metadata.creationTime?.millisecondsSinceEpoch,
      "role":"user",
     " buid_number":buildNumber,
    };
    final userRef=_db.collection("users").doc(user.uid);
    if((await userRef.get()).exists){
      await userRef.update({
        "last_login":user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      "build_number":buildNumber,
      });
    }
    else{
    await userRef.set(userData);

    }
    await _saveDevice(user);


  }
  static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin=DeviceInfoPlugin();
    String deviceId=' ';
    Map<String,dynamic> deviceData={};
    if(Platform.isAndroid){
      final deviceInfo=await devicePlugin.androidInfo;
      deviceId=deviceInfo.androidId;
      deviceData={
        "os_version":deviceInfo.version.sdkInt.toString(),
        "platform":"android",
        "model":deviceInfo.model,
        "device":deviceInfo.device,

      };
    }
    if(Platform.isIOS){
      final deviceInfo=await devicePlugin.iosInfo;
      deviceId=deviceInfo.identifierForVendor;
      deviceData={
        "os_version":deviceInfo.systemVersion,
        "platform":"ios",
        "model":deviceInfo.model,
        "device":deviceInfo.name,

      };
    }
    final nowMS=DateTime.now().millisecondsSinceEpoch;
    final deviceRef=_db.collection("users").doc(user.uid).collection("devices").doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }

  }
}


