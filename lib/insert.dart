import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'homepage.dart';

class RealDB extends StatefulWidget {
  const RealDB({Key? key}) : super(key: key);

  @override
  State<RealDB> createState() => _RealDBState();
}

class _RealDBState extends State<RealDB> {
  var nameController = new TextEditingController();
  var costController = new TextEditingController();
  var dateController = new TextEditingController();
  var _scanResult = '';

  Future<void> _scanBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Cancel', true, ScanMode.DEFAULT);

    if (!mounted) return;

    setState(() {
      _scanResult = barcodeScanResult;
    });
  }

  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Home())),
            child: Icon(Icons.arrow_back)),
        title: Text(
          'Add item',
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name of Product', border: OutlineInputBorder()),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: costController,
                decoration: InputDecoration(
                    labelText: 'Cost', border: OutlineInputBorder()),
              ),
              SizedBox(height: 30),
              // Generated code for this Container Widget...
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 8, 0),
                child: GestureDetector(
                  onTap: _scanBarcode,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            Colors.black, //                   <--- border color
                        width: 0.8,
                      ),
                      //color: FlutterFlowTheme.of(context).secondaryBackground,
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
                          ),
                          Text(
                            'Scan Barcode:',
                          ),
                          Text(
                            _scanResult,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                    labelText: 'Next Date of Inspection',
                    border: OutlineInputBorder()),
                onTap: () async {
                  DateTime? pickdate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2032));
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
                    if (nameController.text.isNotEmpty &&
                        costController.text.isNotEmpty &&
                        _scanResult != -1 &&
                        dateController.text.isNotEmpty)
                      insertData(nameController.text, costController.text,
                          _scanResult, dateController.text);
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

  void insertData(String name, String cost, String scan, String date) {
    // String key=databaseRef.child("Products").child("List").push().key;
    databaseRef.child("Products").child("List").push().set({
      // 'id':key,
      'name': name,
      'cost': cost,
      'code': scan,
      'date': date,
    });
    nameController.clear();
    dateController.clear();
    costController.clear();
    _scanResult = '';
  }
}
