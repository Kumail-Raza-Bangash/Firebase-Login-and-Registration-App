// ignore: unused_import
import 'dart:developer';

import 'package:firebase001/screens/email_auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  bool _isLoading = false;

  bool isCreatingAccount = false; // For showing loading indicator

  void createAccount() async {
    setState(() {
      isCreatingAccount = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || cPassword.isEmpty) {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all the details!")),
      );
    } else if (password != cPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
    } else {
      try {
        // Create new account
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (ex) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ex.code.toString())),
        );
      }
    }

    setState(() {
      isCreatingAccount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create an account"),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
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
                            height: 10,
                          ),
                          TextField(
                            controller: cPasswordController,
                            decoration:
                                InputDecoration(labelText: "Confirm Password"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CupertinoButton(
                            onPressed: () {
                              createAccount();
                            },
                            color: Colors.purple,
                            child: Text("Create Account"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
