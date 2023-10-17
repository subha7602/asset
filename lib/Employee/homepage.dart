import 'package:asset/Admin/AdminHomePage.dart';
import 'package:asset/Employee/Redirect_screen.dart';
import 'package:asset/Employee/add.dart';
import 'package:asset/Employee/my_drawer_header.dart';
import 'package:asset/functions/notification_services.dart';
import 'package:asset/Admin/ReviewBill.dart';
import 'package:asset/Employee/upload_product_form.dart';
import 'package:asset/Employee/view.dart';
import 'package:asset/Employee/Status.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asset/Signup/signin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class Home extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  Home({Key? key, this.userName,this.userEmail}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  NotificationServices notificationServices=NotificationServices();
  @override
  void initState(){
    super.initState();
    notificationServices.firebaseInit(context);
    notificationServices.requestNotificationPermission();
    notificationServices.isTokenRefresh();
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      print('device token');
      print(value);
    });
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin()),
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }
  final currenUser = FirebaseAuth.instance ;
  @override
  Widget build(BuildContext context) {
    var container;
    if(currentpage == DrawerSections.homepage){
      container = Home();
    } else if (currentpage == DrawerSections.notifications){
      container = MessageScreen(id: '',);
    } else if (currentpage == DrawerSections.logout){
      container =_logout();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff01579B),
      appBar: AppBar(
        backgroundColor: Color(0xff01579B),
        elevation: 25,
        title: FittedBox(
          fit: BoxFit.cover,
          child: Text(
            'ASV - ASSET',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

      ),
      body: Align(
        alignment: AlignmentDirectional(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/asset.png',
                width: screenWidth * 0.9,
                height: screenWidth * 0.5,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 12),
              child: Text(
                'Manage the asset easily, efficiently within seconds by using our Application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05 , right: screenWidth * 0.05,top: screenWidth * 0.05),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Color(0x33000000),
                        offset: Offset(0, -1),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center the children horizontally
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center the children horizontally
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => RealDB(),
                                  ),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.only(top: screenWidth * 0.05),
                                  child: Container(
                                    width: screenWidth * 0.7,
                                    height: 60,
                                    margin: EdgeInsets.symmetric(vertical: 10), // Add vertical margin for spacing
                                    decoration: BoxDecoration(
                                      color: Color(0xff01579B),
                                      border: Border.all(
                                        color: Color(0xff01579B),
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'SCAN AND ADD',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                        Icon(Icons.qr_code_scanner_sharp, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => DataTableView(),
                                  ),
                                ),
                                child: Container(
                                  width: screenWidth * 0.7,
                                  height: 60,
                                  margin: EdgeInsets.symmetric(vertical: 10), // Add vertical margin for spacing
                                  decoration: BoxDecoration(
                                    color: Color(0xff01579B),
                                    border: Border.all(
                                      color: Color(0xff01579B),
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'UPDATE PRODUCT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 18),
                                      Icon(Icons.edit, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => UploadProductForm(),
                                  ),
                                ),
                                child: Container(
                                  width: screenWidth * 0.7,
                                  height: 60,
                                  margin: EdgeInsets.symmetric(vertical: 10), // Add vertical margin for spacing
                                  decoration: BoxDecoration(
                                    color: Color(0xff01579B),
                                    border: Border.all(
                                      color: Color(0xff01579B),
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'UPLOAD BILL',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Icon(Icons.upload_sharp, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Status(),
                                  ),
                                ),
                                child: Container(
                                  width: screenWidth * 0.7,
                                  height: 60,
                                  margin: EdgeInsets.symmetric(vertical: 10), // Add vertical margin for spacing
                                  decoration: BoxDecoration(
                                    color: Color(0xff01579B),
                                    border: Border.all(
                                      color: Color(0xff01579B),
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'VIEW STATUS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 25),
                                      Icon(Icons.remove_red_eye, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(userName:widget.userName,userEmail: widget.userEmail),
                MyDrawerList(context,currentpage),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget MyDrawerList(BuildContext context, DrawerSections currentpage){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          menuItem(context,1,"HomePage",Icons.home,
            currentpage == DrawerSections.homepage ?true : false, (){
            setState(() {
              currentpage= DrawerSections.homepage;
            });
            Navigator.pop(context);
              }),
          menuItem(context,2,"Notifications",Icons.notifications_active_rounded,
            currentpage == DrawerSections.notifications ?true : false,(){
            setState(() {
              currentpage = DrawerSections.notifications;
            });
            Navigator.pop(context);
              }),
          menuItem(context,3,"LogOut",Icons.logout_rounded,
            currentpage == DrawerSections.logout ?true : false,(){
            setState(() {
              currentpage=DrawerSections.logout;
            });
            Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
var currentpage = DrawerSections.homepage;
Widget menuItem(BuildContext context,int id, String title, IconData icon, bool selected,VoidCallback onTap) {
   FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin()),
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }
  Color itemColor = selected ? Colors.grey : Colors.transparent; // Define color
  return Material(
    color: itemColor,
    child: GestureDetector(
      onTap: () {
        onTap();
        if (id == 1){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
        } else if (id == 2){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MessageScreen(id: '')));
        } else if (id == 3){
          _logout();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.black, // Set icon color
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black, // Set text color
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    )
  );
}
enum DrawerSections
{
  homepage,
  logout,
  notifications,
}
void main() => runApp(MaterialApp(
  home: Home(),
));
