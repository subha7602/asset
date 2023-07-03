import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Barcode.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
  String _scanResult = '';

  Future<void> _scanBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Cancel', true, ScanMode.DEFAULT);

    if (!mounted) return;

    setState(() {
      _scanResult = barcodeScanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Insert Data",
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
