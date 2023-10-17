import 'package:asset/Employee/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  final String id;
  const MessageScreen({Key? key,required this.id}) : super(key: key);
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String convertDateFormat(String date) {
    // Implement your date format conversion logic here
    // For example, if date is in the format 'dd-mm-yyyy' and you want to convert it to 'yyyy-mm-dd', you can do:
    var splitDate = date.split('-');
    return '${splitDate[2]}-${splitDate[1]}-${splitDate[0]}';
  }
  List<Map<String, dynamic>> dataList = [];
  String selectedSort = 'None';
  TextEditingController _controller = TextEditingController();
  var commentController = TextEditingController();
  String searchQuery = "";
  DateTime currentDate = DateTime.now();
  DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child('Products').child('List');
  @override
  void initState() {
    super.initState();
    fetchData();
    _controller.text = searchQuery;
  }
  void updateComment(String prod_id, String comment) {
    DatabaseReference databaseRef =
    FirebaseDatabase.instance.reference().child('Products').child('List').child(prod_id);

    databaseRef.update({
      'comment': comment
    });
  }

  Future<void> fetchData() async {
    DatabaseReference databaseRef =
    FirebaseDatabase.instance.reference().child('Products').child('List');

    DatabaseEvent event = await databaseRef.once();
    DataSnapshot snapshot = event.snapshot;

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
          'comment': ' ', // Add this line to fetch the comment
        };
      }).toList();

      setState(() {});
    }
  }
  List<Map<String, dynamic>> getFilteredAndSortedData() {
    // Get current date
    DateTime currentDate = DateTime.now();

    // Print the current date
    print('Current Date: ${currentDate.day}-${currentDate.month}-${currentDate.year}');

    // Simulating filtering and sorting
    List<Map<String, dynamic>> filteredData = dataList
        .where((data) {
      // Convert the date string into a parseable format and create a DateTime object
      DateTime dataDate = DateTime.parse(convertDateFormat(data['date']));

      // Create new DateTime objects that only contain year, month, and day information
      DateTime justCurrentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      DateTime justDataDate = DateTime(dataDate.year, dataDate.month, dataDate.day);

      // Check if the date is not in the past and if it matches the search query
      return (justDataDate.isAtSameMomentAs(justCurrentDate) || justDataDate.isAfter(justCurrentDate)) && data.values.any((value) =>
          value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    })
        .toList();

    filteredData.sort((a, b) {
      return a['date'].compareTo(b['date']);
    });

    return filteredData;
  }



  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAndSortedData =
    getFilteredAndSortedData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01579B),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: Icon(Icons.arrow_back),
        ),

        title:Text('NOTIFICATIONS') ,
      ),
      body: Column(
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
                  ],
                ),
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
                    DataColumn(label: Text('DATE',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),
                    DataColumn(label: Text('COMMENTS',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)),

                  ],
                  rows: filteredAndSortedData.map((data) {
                    DateTime rowDate = DateFormat('dd-MM-yyyy').parse(data['date']);
                    bool isToday = currentDate.day == rowDate.day && currentDate.month == rowDate.month && currentDate.year == rowDate.year;
                    return DataRow(
                      cells: [
                        DataCell(Text(data['prod_id'])),
                        DataCell(Text(data['emp_id'])),
                        DataCell(Text(data['date'])),

                        DataCell(
                          IconButton(
                            icon: Icon(Icons. comment),
                            color: Color(0xff01579B),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return
                                    Dialog(
                                     child:Container(
                                       height: 300,
                                       child:
                                       SingleChildScrollView(
                                         child: Padding(
                                           padding: const EdgeInsets.all(12.0),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: <Widget>[

                                               TextField(
                                                 controller: commentController,
                                                 maxLength: 200, // Set maximum character limit
                                                 maxLines: 5, // Allow multiple lines
                                                 decoration: InputDecoration(
                                                   labelText: 'Add Comments here',
                                                   alignLabelWithHint: true,
                                                   border: OutlineInputBorder(),
                                                 ),
                                               ),

                                               Center(
                                                 child: ElevatedButton(
                                                   onPressed: () {
                                                     DatabaseReference databaseRef =
                                                     FirebaseDatabase.instance.reference().child('Products').child('List').child(data['prod_id']);

                                                     databaseRef.update({
                                                       'comment': commentController.text
                                                     });
                                                     Navigator.pop(context);
                                                   },
                                                   child: Text(
                                                     "Submit",
                                                     style: TextStyle(color: Colors.white),
                                                   ),
                                                   style: ElevatedButton.styleFrom(
                                                     primary: Color(0xff01579B),
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),

                                     ),

                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],color: isToday ? MaterialStateColor.resolveWith((states) => Color(0xFFFF7276)) : null,

                    );
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

