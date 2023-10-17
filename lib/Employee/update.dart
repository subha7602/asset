import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditDataView extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> dataList; // Add this line

  EditDataView({required this.data, required this.dataList}); // Add dataList to the constructor

  @override
  _EditDataViewState createState() => _EditDataViewState();
}

class _EditDataViewState extends State<EditDataView> {
  late TextEditingController prodIdController;
  late TextEditingController costController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    prodIdController = TextEditingController(text: widget.data['prod_id']);
    costController = TextEditingController(text: widget.data['cost']);
    dateController = TextEditingController(text: widget.data['date']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPDATE'),
        backgroundColor: Color(0xff01579B), // Set AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: prodIdController,
              decoration: InputDecoration(
                labelText: 'Product ID',
                labelStyle: TextStyle(
                  color: Color(0xff01579B),
                  // Set label text color
                ),enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // Set enabled border color
                borderRadius: BorderRadius.circular(10.0),
              ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set focused border color
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),SizedBox(height: 20),
            TextField(
              controller: costController,
              decoration: InputDecoration(
                labelText: 'Cost',
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
            ),SizedBox(height: 20),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
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
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int index = widget.dataList.indexOf(widget.data); // Use widget.dataList here
                widget.dataList[index]['prod_id'] = prodIdController.text;
                widget.dataList[index]['cost'] = costController.text;
                widget.dataList[index]['date'] = dateController.text;
                DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child('Products').child('List').child(widget.data['prod_id']);
                databaseRef.update({
                  'prod_id': prodIdController.text,
                  'cost': costController.text,
                  'date': dateController.text,
                });
                Navigator.pop(context, widget.dataList[index]);
              },
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white, // Set button text color
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff01579B), // Set button background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
