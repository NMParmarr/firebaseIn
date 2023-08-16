import 'package:firebase_in/pages/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhone extends StatelessWidget {
  final String verificationId;
  final String phoneNo;
  VerifyPhone({super.key, required this.verificationId, required this.phoneNo});

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
                    helperText: "Enter 6 digit code..",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      gapPadding: 5,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Consumer<LoginWithPhoneProvider>(
                    builder: (context, provider, child) {
                  return Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          provider.verify(
                            context,
                            verificationId,
                            _verifyPhoneController.text.toString().trim(),
                            phoneNo,
                          );
                        }
                      },
                      icon: provider.loading ? SizedBox() : Icon(Icons.check),
                      label: provider.loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Verify"),
                      style:
                          ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                    ),
                  );
                })
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
