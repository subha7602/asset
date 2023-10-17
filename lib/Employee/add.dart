import 'package:asset/Employee/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class RealDB extends StatefulWidget {
  const RealDB({Key? key}) : super(key: key);

  @override
  State<RealDB> createState() => _RealDBState();
}

class _RealDBState extends State<RealDB> {
  var prodIdController = TextEditingController();
  var costController = TextEditingController();
  var dateController = TextEditingController();
  var employeeIdController = TextEditingController();
  var _scanResult = '';

  void _scanBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000',
      'Cancel',
      true,
      ScanMode.DEFAULT,
    );

    if (!mounted) return;

    setState(() {
      _scanResult = barcodeScanResult;
    });
  }

  void insertData(
      String prod_id,
      String cost,
      String emp_id,
      String scan,
      String date,
      String comment
      ) {
    DatabaseReference databaseRef =
    FirebaseDatabase.instance.reference().child('Products').child('List').child(prod_id);

    databaseRef.set({
      'cost': cost,
      'emp_id': emp_id,
      'code': scan,
      'date': date,
      'comment': comment
    });
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Product details added successfully.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK',style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff01579B), // Set button background color
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: Icon(Icons.arrow_back),
        ),

        title: Text(
          'Add Item',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: Color(0xff01579B),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: prodIdController,
                  decoration: InputDecoration(
                    labelText: 'Product ID',
                    labelStyle: TextStyle(
                      color: Color(0xff01579B),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cost',
                    labelStyle: TextStyle(
                      color: Color(0xff01579B),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: employeeIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Employee ID',
                    labelStyle: TextStyle(
                      color: Color(0xff01579B),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: _scanBarcode,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 24,
                            color: Color(0xff01579B),
                          ),
                          Text(
                            'Scan Barcode:',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff01579B),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _scanResult,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Next Date of Inspection',
                    labelStyle: TextStyle(
                      color: Color(0xff01579B),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickdate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2032),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Color(0xff01579B),
                            hintColor: Color(0xff01579B),
                            colorScheme: ColorScheme.light(
                              primary: Color(0xff01579B),
                            ),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickdate != null) {
                      setState(() {
                        dateController.text =
                            DateFormat('dd-MM-yyyy').format(pickdate);
                      });
                    }
                  },
                ),
                ElevatedButton(

                  onPressed: () {

                    if (prodIdController.text.isNotEmpty &&
                        costController.text.isNotEmpty &&
                        employeeIdController.text.isNotEmpty &&
                        _scanResult != '' &&
                        dateController.text.isNotEmpty) {
                      insertData(
                        prodIdController.text,
                        costController.text,
                        employeeIdController.text,
                        _scanResult,
                        dateController.text,
                        'No comments added yet'
                      );
                      _showSuccessDialog();
                      prodIdController.clear();
                      costController.clear();
                      employeeIdController.clear();
                      dateController.clear();
                      setState(() {
                        _scanResult = '';
                      });
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff01579B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
