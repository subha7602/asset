import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BILL STATUS'),
        backgroundColor: Color(0xff01579B),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Bill').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var bills = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Flexible(
                      child: Container(
                        width: double.infinity,
                        child: Text('BILL TITLE',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      child: Container(
                        width: double.infinity,
                        child: Text('EMPLOYEE ID',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      child: Container(
                        width: double.infinity,
                        child: Text('IMAGE',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      child: Container(
                        width: double.infinity,
                        child: Text('     STATUS',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),),
                      ),
                    ),
                  ),
                ],
                rows: bills.map(
                      (bill) => DataRow(
                    cells: <DataCell>[
                      DataCell(Text(bill['BillTitle'])),
                      DataCell(Text(bill['EmployeeID'])),
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.8,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(bill['BillImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(bill['BillImage']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff01579B),width: 2), // Add a blue border
                              borderRadius: BorderRadius.circular(8.0),

                            ),
                            child: Container(
                              width: 90,
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                // color: bill['status'] == 'pending'
                                //     ? Colors.grey
                                //     : bill['status'] == 'Rejected'
                                //     ? Colors.red
                                //     : Colors.green,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  bill['status'],
                                  style: TextStyle(
                                    color: bill['status'] == 'pending'
                                        ? Colors.black
                                        : bill['status'] == 'Rejected'
                                        ? Colors.red // Change text color to white for rejected
                                        : Colors.green, // Change text color to white for approval
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Text(bill['status']),
                      ),
                    ],
                  ),
                ).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
