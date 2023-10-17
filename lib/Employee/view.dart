
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'update.dart'; // Import the edit page

class DataTableView extends StatefulWidget {
  @override
  _DataTableViewState createState() => _DataTableViewState();
}

class _DataTableViewState extends State<DataTableView> {
  List<Map<String, dynamic>> dataList = [];
  String selectedSort = 'None';
  TextEditingController _controller = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    _controller.text = searchQuery;
  }

  Future<void> fetchData() async {
    DatabaseReference databaseRef =
    FirebaseDatabase.instance.reference().child('Products').child('List');

    DatabaseEvent event = await databaseRef.once();
    DataSnapshot snapshot = event.snapshot;
    print('view page:');
    print(snapshot.value);

    if (snapshot.value != null && snapshot.value is Map) {
      Map<dynamic, dynamic> productsData =
      snapshot.value as Map<dynamic, dynamic>;

      dataList = productsData.entries.map<Map<String, dynamic>>((entry) {
        DatabaseReference productRef = FirebaseDatabase.instance
            .reference()
            .child('Products')
            .child('List')
            .child(entry.key); // Use entry.key to get the product id

        return {
          'prod_id': entry.key as String, // Use entry.key to get the product id
          'emp_id': entry.value['emp_id'] as String,
          'cost': entry.value['cost'] as String,
          'code': entry.value['code'] as String,
          'date': entry.value['date'] as String,
          'comment': entry.value['comment'] as String, // Add this line to fetch the comment
        };
      }).toList();

      setState(() {});
    }
  }

  List<Map<String, dynamic>> getFilteredAndSortedData() {
    // Simulating filtering and sorting
    List<Map<String, dynamic>> filteredData = dataList
        .where((data) {
      return data.values.any((value) =>
          value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    })
        .toList();

    filteredData.sort((a, b) {
      if (selectedSort == 'Employee ID') {
        return a['emp_id'].toLowerCase().compareTo(b['emp_id'].toLowerCase());
      } else if (selectedSort == 'Price') {
        double priceA = double.tryParse(a['cost']) ?? 0;
        double priceB = double.tryParse(b['cost']) ?? 0;
        return priceA.compareTo(priceB);
      } else if (selectedSort == 'Date') {
        return a['date'].compareTo(b['date']);
      }
      return 0;
    });

    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAndSortedData =
    getFilteredAndSortedData();

    return Scaffold(
      appBar: AppBar(
        title: Text('VIEW AND UPDATE'),
        backgroundColor: Color(0xff01579B),
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Color(0xff01579B)),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.filter_list,
                              color: Color(0xff01579B),
                            ),
                            onSelected: (value) {
                              setState(() {
                                selectedSort = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return ['None', 'Employee ID', 'Price', 'Date']
                                  .map((String option) {
                                return PopupMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: Color(0xff01579B),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
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
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String scanResult =
                        await FlutterBarcodeScanner.scanBarcode(
                            '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                        if (scanResult != '-1') {
                          setState(() {
                            searchQuery = scanResult;
                          });
                        }
                      },
                      child: Text('Scan', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff01579B), // Set button background color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('PRODUCT-ID',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),

                     DataColumn(label: Text('EMPLOYEE-ID',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),
                    DataColumn(label: Text('COST',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),
                    DataColumn(label: Text('CODE',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),
                    DataColumn(label: Text('DATE',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),

                    DataColumn(label: Text('EDIT',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),
                  ],
                  rows: filteredAndSortedData.map((data) {
                    return DataRow(cells: [
                      DataCell(Text(data['prod_id'])),
                      DataCell(Text(data['emp_id'])),
                      DataCell(Text(data['cost'])),
                      DataCell(Text(data['code'])),
                      DataCell(Text(data['date'])),

                      DataCell(
                        IconButton(
                          icon: Icon(Icons.edit),color: Color(0xff01579B),
                          onPressed: () async {
                            Map<String, dynamic>? updatedData =
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDataView(
                                  data: data,
                                  dataList: dataList,
                                ), // Pass dataList here
                              ),
                            );

                            if (updatedData != null) {
                              int index = dataList.indexOf(data);
                              dataList[index] = updatedData;

                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DataTableView(),
  ));
}
