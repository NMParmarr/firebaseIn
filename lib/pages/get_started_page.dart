import 'package:firebase_in/pages/login_page.dart';
import 'package:flutter/material.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.network(
                "https://img.freepik.com/free-vector/welcome-word-flat-cartoon-people-characters_81522-4207.jpg"),
            Spacer(),
            Text(
              "Welcome FirebaseIn",
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => LoginPage())));
                },
                icon: Icon(Icons.login_rounded),
                label: Text("Get Started")),
            Spacer()
          ],
        ),
      ),
    );
  }
}
