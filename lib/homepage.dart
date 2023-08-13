import 'package:asset/insert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asset/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asset/signin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Signin()),
            (Route<dynamic> route) => false, // Remove all existing routes from the stack.
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.black,
         appBar: AppBar(
           backgroundColor: Colors.black,
           elevation: 25,
           title: Text(
             'HOMEPAGE',
             style: TextStyle(
             fontFamily: 'Plus Jakarta Sans',
             color: Colors.white,
             fontSize: 28,
             fontWeight: FontWeight.w500,
           ),
           ),
             actions: <Widget>[
               Center(
                 child: ElevatedButton(
                   onPressed: () {
                     _logout();

                   },
                   child: Text("Logout"),
                 ),
               ),
             ],
         ),

      body: // Generated code for this Column Widget...
      Align(
        alignment: AlignmentDirectional(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 30 ,),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/asset.png',
                width: 220,
                height: 127,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
              child: Text(
                'Manage the asset easily, efficiently within seconds  by using our Application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 400,
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
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) => new RealDB())),
                                        child: Container(
                                          width:
                                          MediaQuery.sizeOf(context).width * 0.4,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF1F4F8),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                12, 12, 12, 12),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                  size: 36,
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0, 12, 0, 4),
                                                  child:  Text(
                                                    'Add item',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Plus Jakarta Sans',
                                                      color: Color(0xFF57636C),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,),

                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) => new RealDB())),
                                        child: Container(
                                          width:
                                          MediaQuery.sizeOf(context).width * 0.4,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF1F4F8),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                12, 12, 12, 12),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.edit_square,
                                                  color: Color(0xFF101213),
                                                  size: 44,
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0, 12, 0, 4),
                                                  child:  Text(
                                                    'Update',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Plus Jakarta Sans',
                                                      color: Color(0xFF57636C),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,),

                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.sizeOf(context).width * 0.4,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F4F8),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              12, 12, 12, 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye,
                                                color: Color(0xFF101213),
                                                size: 44,
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 12, 0, 4),
                                                child:  Text(
                                                  'View',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Plus Jakarta Sans',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,),

                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.sizeOf(context).width * 0.4,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F4F8),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              12, 12, 12, 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload_file_rounded,
                                                color: Color(0xFF101213),
                                                size: 44,
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 12, 0, 4),
                                                child:  Text(
                                                  'Upload Bill',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Plus Jakarta Sans',
                                                    color: Color(0xFF57636C),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,),

                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
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
      )

     );
  }
}
