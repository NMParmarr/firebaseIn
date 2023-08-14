import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in/pages/home_page.dart';
import 'package:firebase_in/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AuthStream extends StatefulWidget {
  const AuthStream({super.key});

  @override
  State<AuthStream> createState() => _AuthStreamState();
}

class _AuthStreamState extends State<AuthStream> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Scaffold(
                  backgroundColor: const Color.fromARGB(255, 215, 255, 246),
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )));
            }
            final user = snapshot.data;
            if (user != null) {
              print("user is logged in");
              print(user);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              });
              return Container(
                color: Colors.amberAccent,
              );
            } else {
              print("user is not logged in");
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });

              return Container(
                color: Colors.amberAccent,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            }
          }),
    );
  }
}
