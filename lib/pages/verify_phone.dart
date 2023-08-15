import 'package:flutter/material.dart';

class VerifyPhone extends StatelessWidget {
  VerifyPhone({super.key});

  final _formKey = GlobalKey<FormState>();
  final _verifyPhoneController = TextEditingController();

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
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: TextStyle(letterSpacing: 6, fontSize: 20),
                  validator: (value) {
                    if (value!.isEmpty)
                      return "enter OTP to verify ..";
                    else
                      return null;
                  },
                  controller: _verifyPhoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "000000",
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
                      if (_formKey.currentState!.validate()) {}
                    },
                    icon: Icon(Icons.check),
                    label: Text(
                      "Verify",
                    ),
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
