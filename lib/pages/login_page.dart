// ignore_for_file: must_be_immutable

import 'package:firebase_in/pages/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  bool isLogin = true;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _unamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();

  String uname = '';
  String email = '';
  String password = '';

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
                    widget.isLogin ? "User Login" : "Sign Up",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  widget.isLogin
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
                  Consumer<PasswordVisibilityProvider>(
                      builder: (context, provider, child) {
                    return TextFormField(
                      validator: (password) {
                        if (password!.isEmpty)
                          return "Enter new password..";
                        else if (password.length < 8)
                          return "Password must be 8 char long..";
                        else
                          return null;
                      },
                      obscureText: provider.isPasswordVisible,
                      controller: _passcontroller,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => provider.toggleVisibility(),
                              icon: provider.isPasswordVisible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          hintText: "Password",
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(3))),
                    );
                  }),
                  SizedBox(height: 20),
                  Consumer<LoginProvider>(builder: (context, provider, child) {
                    return Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            uname = _unamecontroller.text.toString().trim();
                            email = _emailcontroller.text.toString().trim();
                            password = _passcontroller.text.toString().trim();
                            widget.isLogin
                                ? provider.login(context, email, password)
                                : provider.signUp(
                                    context, uname, email, password);
                          }
                        },
                        icon: provider.loading
                            ? SizedBox()
                            : Icon(Icons.login_outlined),
                        label: provider.loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(widget.isLogin ? "Login" : "Sign Up"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.all(10)),
                      ),
                    );
                  }),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (widget.isLogin) {
                            _unamecontroller.clear();
                            _emailcontroller.clear();
                            _passcontroller.clear();
                          }
                          widget.isLogin = !widget.isLogin;
                        });
                      },
                      child: Text(widget.isLogin
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
}
