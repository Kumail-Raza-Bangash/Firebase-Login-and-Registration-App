import 'dart:developer';

import 'package:firebase001/screens/HomeScreen.dart';
import 'package:firebase001/screens/email_auth/signup_screen.dart';
import 'package:firebase001/screens/phone_auth/signin_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      log("Please fill all the fields!");
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          setState(() {
            _isLoading = false;
          });
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => HomeScreen()));
        }
      } on FirebaseAuthException catch (ex) {
        setState(() {
          _isLoading = false;
        });
        log(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SignUpScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration:
                                InputDecoration(labelText: "Email Address"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(labelText: "Password"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CupertinoButton(
                            onPressed: () {
                              login();
                            },
                            color: Colors.purple,
                            child: Text("Log In"),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => SignInWithPhone()));
                            },
                            child: Text("Sigin with Phone"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
