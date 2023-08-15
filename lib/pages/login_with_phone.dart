import 'package:firebase_in/pages/verify_phone.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatelessWidget {
  LoginWithPhone({super.key});

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

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
              child: Column(children: [
                SizedBox.shrink(),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-135.jpg?w=360",
                          ))),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Enter mobile number..";
                    else if (value.length > 10 || value.length < 0)
                      return "Enter valid mobile number..";
                    else
                      return null;
                  },
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    prefix: Text(
                      "+91 ",
                      style: TextStyle(color: Colors.black),
                    ),
                    hintText: "Enter 10 digit mobile",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      gapPadding: 5,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => VerifyPhone())));
                      }
                    },
                    icon: Icon(Icons.message_sharp),
                    label: Text("Send Code"),
                    style:
                        ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
