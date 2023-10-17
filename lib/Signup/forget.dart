import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}
class _ForgetState extends State<Forget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01579B),
        title: Text('FORGET PASSWORD'),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[Container(
            decoration: BoxDecoration(
              //color: Color(0xff01579B),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:60,
                  top: 50),
              child: Image.asset(
                "assets/password_forget.gif", // Adjust the image path
                fit: BoxFit.cover,
                width: 230,
                height: 230,
                // height: double.infinity,// Make the image take the full width of the screen
              ),
            ),
          ),Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 300),
                    Center(
                      child: Text(
                        'FORGET YOUR PASSWORD?',
                        style: TextStyle(color: Color(0xff01579B), fontSize:20,fontWeight: FontWeight.w900),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: Text(
                          'Enter your email to reset your password',
                          style: TextStyle(color: Color(0xff01579B)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20, top: 20),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          hintStyle: TextStyle(color: Color(0xff01579B)),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Set enabled border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Set focused border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email to reset password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0, left: 30, top: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff01579B), // This is the custom color
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password reset email sent')),
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            'SEND',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),



          ],
        ),
      ),
    );
  }
}
