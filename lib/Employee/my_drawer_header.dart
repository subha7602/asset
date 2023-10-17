import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHeaderDrawer extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const MyHeaderDrawer({Key? key, this.userName, this.userEmail}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Initialize _imageFile as null to indicate no image has been picked initially.
    _imageFile = null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff01579B),
      width: double.infinity,
      height: 250,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [

                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _imageFile != null
                        ? DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/profile.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Positioned(
                top: 50,
                bottom: 0,
                right: 0,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xff01579B),
                    ),
                    onPressed: () {
                      _showImagePickerDialog(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          Text(
            widget.userEmail ?? "",
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePickerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Profile Picture"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Pick from Gallery"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a Photo"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
