import 'dart:io';
import 'dart:math';
import 'package:asset/services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _BillTitle = '';
  var _EmployeeID = '';
  GlobalMethods _globalMethods = GlobalMethods();

  File? _pickedImage; // Use "?" to denote that it's nullable

  bool _isLoading = false;
  late String url;

  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            ElevatedButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Set button text color
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff01579B), // Set button background color
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      print(_BillTitle);
      print(_EmployeeID);
      // Use those values to send our request ...
    }
    if (isValid) {
      _formKey.currentState?.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('BillImages')
              .child(_BillTitle + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          final BillId = DateTime.now().millisecondsSinceEpoch.toString() +
              Random().nextInt(10000).toString();
          await FirebaseFirestore.instance.collection('Bill').doc(BillId).set({
            'BillId': BillId,
            'BillTitle': _BillTitle,
            'BillImage': url,
            'EmployeeID': _EmployeeID,
            'status': 'pending',
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        if (error is FirebaseException && error.message != null) {
          _globalMethods.authErrorHandle(error.message!, context);
          print('error occurred ${error.message}');
        } else {
          _globalMethods.authErrorHandle('An error occurred', context);
          print('Unknown error occurred');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile =
    pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile!;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BILL UPLOAD'),
        backgroundColor: Color(0xff01579B), // Set AppBar background color
      ),
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff01579B),

          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Color(0xff01579B),
          child: InkWell(
            onTap: _trySubmit,
            splashColor: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Center(
                      child: Container(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()))
                      :Text('UPLOAD BILL',
                      style: TextStyle(fontSize: 16,color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: ValueKey('Bill Name'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Bill Name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Bill Name',
                                    labelStyle: TextStyle(
                                      color: Color(0xff01579B), // Set label text color
                                    ),enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black), // Set enabled border color
                                    borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black), // Set focused border color
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    _BillTitle = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(

                                  key: ValueKey('Employee ID'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Employee ID';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Enter Employee ID',
                                    labelStyle: TextStyle(
                                      color: Color(0xff01579B), // Set label text color
                                    ),enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black), // Set enabled border color
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black), // Set focused border color
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    _EmployeeID = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),SizedBox(height: 25),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0xff01579B),
                              ),
                              child: _pickedImage != null
                                  ? AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.contain,
                                ),
                              )
                                  : Container(),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.4, // set the width of the Column to 50% of the screen width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                    onPressed: _pickImageCamera,
                                    icon: Icon(Icons.camera,color: Color(0xff01579B)),
                                    label: Text(
                                      'Camera',
                                      style: TextStyle(
                                        color: Color(0xff01579B), // Set button text color
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: _pickImageGallery,
                                    icon: Icon(Icons.image,color: Color(0xff01579B)),
                                    label: Text(
                                      'Gallery',
                                      style: TextStyle(
                                        color: Color(0xff01579B), // Set button text color
                                      ),
                                    ),
                                  ),
                                  if (_pickedImage != null)
                                    ElevatedButton.icon(
                                      onPressed: _removeImage,
                                      icon: Icon(
                                        Icons.remove_circle_rounded,
                                        color: Colors.red,
                                      ),style: ElevatedButton.styleFrom(
                                      primary: Color(0xff01579B), // Set button background color
                                    ),
                                      label: Text(
                                        'Remove',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
