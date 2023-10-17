import 'dart:async';
import 'dart:io';
import 'package:asset/functions/Verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer timer;
  static signInWithEmail({required String email, required String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static signupWithEmail({required String email, required String password}) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = res.user;
      await user?.sendEmailVerification();
      return user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }
  static Future<bool> isEmailTaken(String email) async {
    try {
      var signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      print("SignInMethods: $signInMethods"); // Print the signInMethods
      return signInMethods.isNotEmpty; // Email is taken if signInMethods is not empty
    } catch (e) {
      print("Error while checking email existence: $e");
      return false; // Return false in case of an error
    }
  }

  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken, idToken: auth?.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }
  static logOut() {
    GoogleSignIn().signOut();
    return _auth.signOut();
  }
}
class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<void> saveUserWithRole(User user, String role) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime?.millisecondsSinceEpoch,
      "role": role,
      "build_number": buildNumber,
    };
    String deviceId = await _getDeviceId();
    userData["device_id"] = deviceId;
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "name": user.displayName,
        "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
        "build_number": buildNumber,
        "device_id": deviceId, // Add device ID to update
        // Add photo URL if available
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
    await _saveDevice(user);
  }
  static Future<void> _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String deviceId = '';
    Map<String, dynamic> deviceData = {};
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
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
  static Future<String> _getDeviceId() async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      return deviceInfo.androidId;
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      return deviceInfo.identifierForVendor;
    }
    return '';
  }
}