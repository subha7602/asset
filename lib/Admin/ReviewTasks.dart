
import 'package:asset/Admin/AdminHomePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ReviewTask extends StatefulWidget {
  const ReviewTask({Key? key}) : super(key: key);

  @override
  State<ReviewTask> createState() => _ReviewTaskState();
}

class _ReviewTaskState extends State<ReviewTask> {

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
  void removeItemFromDatabase(String prodId) {
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child('Products').child('List').child(prodId);

    databaseRef.remove().then((_) {
      print("Item removed successfully from the database");
    }).catchError((error) {
      print("Error removing item: $error");
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
        String getCommentForProductId(String prodId) {
          for (var data in dataList) {
            if (data['prod_id'] == prodId) {
              return data['comment'];
            }
          }
          return 'Comment not found'; // Return a default message if the prod_id is not found
        }

        String comment = getCommentForProductId(entry.key);


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
    // Get current date
    DateTime currentDate = DateTime.now();

    // Print the current date
    print('Current Date: ${currentDate.day}-${currentDate.month}-${currentDate.year}');

    // Simulating filtering and sorting
    List<Map<String, dynamic>> filteredData = dataList
        .where((data) {
      // Convert the date string into a parseable format and create a DateTime object
      DateTime dataDate = DateTime.parse(convertDateFormat(data['date']));

      // Check if it matches the search query
      return data.values.any((value) =>
          value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    })
        .toList();

    filteredData.sort((a, b) {
      return a['date'].compareTo(b['date']);
    });

    return filteredData;
  }
  void removeItem(String prodId) {
    setState(() {
      dataList.removeWhere((item) => item['prod_id'] == prodId);
    });
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
              MaterialPageRoute(builder: (context) => AdminHomePage(context: context)),
            );
          },
          child: Icon(Icons.arrow_back),
        ),

        title:Text('REVIEW TASKS') ,
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
                    DataColumn(label: Text('DELETE',style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff01579B),),)), // Add a new column for deletion
                  ],
                  rows: filteredAndSortedData.map((data) {
                    DateTime rowDate = DateFormat('dd-MM-yyyy').parse(data['date']);
                    bool isToday = currentDate.day == rowDate.day && currentDate.month == rowDate.month && currentDate.year == rowDate.year;
                    return DataRow(
                      key: ObjectKey(data['prod_id']),
                      cells: [
                        DataCell(Text(data['prod_id'])),
                        DataCell(Text(data['emp_id'])),
                        DataCell(Text(data['date'])),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.remove_red_eye_rounded),
                            color: Color(0xff01579B),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                height: 120,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Color(0xff01579B),
                                                  ),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    data['comment'],
                                                    style: TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "OK",
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
                        DataCell(
                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text('Are you sure you want to delete this item?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          removeItem(data['prod_id']);
                                          removeItemFromDatabase(data['prod_id']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
