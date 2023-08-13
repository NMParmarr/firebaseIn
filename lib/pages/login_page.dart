import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _unamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();

  String uname = '';
  String email = '';
  String password = '';

  bool isLogin = true;
  bool pv = true;

  bool loding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox.shrink(),
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-135.jpg?w=360",
                            ))),
                  ),
                  Text(
                    isLogin ? "User Login" : "Sign Up",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  isLogin
                      ? SizedBox()
                      : TextFormField(
                          validator: (username) {
                            if (username!.isEmpty)
                              return "Username is required..";
                            else
                              return null;
                          },
                          autofocus: true,
                          controller: _unamecontroller,
                          decoration: InputDecoration(
                              hintText: "Username",
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(3))),
                        ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (email) {
                      if (email!.isEmpty)
                        return "Email field is required..";
                      else if (!email.contains('@'))
                        return "Enter valid email...";
                      else
                        return null;
                    },
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(3))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (password) {
                      if (password!.isEmpty)
                        return "Enter new password..";
                      else if (password.length < 8)
                        return "Password must be 8 char long..";
                      else
                        return null;
                    },
                    obscureText: pv,
                    controller: _passcontroller,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                pv = !pv;
                              });
                            },
                            icon: pv
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        hintText: "Password",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(3))),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          uname = _unamecontroller.text.toString().trim();
                          email = _emailcontroller.text.toString().trim();
                          password = _passcontroller.text.toString().trim();
                          isLogin ? login() : signUp();
                        }
                      },
                      icon: loding ? SizedBox() : Icon(Icons.login_outlined),
                      label: loding
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(isLogin ? "Login" : "Sign Up"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.all(10)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (isLogin) {
                            _unamecontroller.clear();
                            _emailcontroller.clear();
                            _passcontroller.clear();
                          }
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? "Dont have an account? Sign Up"
                          : "Already have an account? Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      setState(() {
        loding = true;
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        setState(() {
          loding = false;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        loding = false;
      });
    }
  }

  Future<void> signUp() async {
    try {
      setState(() {
        loding = true;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        setState(() {
          loding = false;
        });
      });
      addUser();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        loding = false;
      });
    }
  }

  Future<String> getCurrentUid() async {
    return ((await _auth.currentUser!).uid);
  }

  Future<void> addUser() async {
    debugPrint("adduser method : start");
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference users = _firestore.collection("users");
      final getID = _auth.currentUser!.uid;
      await users.doc(getID).set(
        {
          "email": email,
          "password": password,
          "username": uname,
        },
      ).then((value) {
        setState(() {
          isLogin = !isLogin;
        });
        debugPrint("adduser method : end");
      });
    } catch (e) {
      print("error " + e.toString());
      debugPrint("adduser method : error end");
    }
    debugPrint("adduser method : end without adding..!opps");
  }
}
