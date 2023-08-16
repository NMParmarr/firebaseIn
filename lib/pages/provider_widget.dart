import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in/pages/auth_stream.dart';
import 'package:firebase_in/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'verify_phone.dart';

class LoadingProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  void signOut(BuildContext context, bool isGoogleSignIn) {
    loading = true;
    notifyListeners();
    try {
      if (isGoogleSignIn) {
        GoogleSignIn().signOut();
      }
      _auth.signOut().whenComplete(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => AuthStream())));
        loading = false;
        notifyListeners();
      });
    } catch (e) {
      loading = false;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
    }
  }
}

class LoginProvider extends ChangeNotifier {
  // late bool navigate;
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  Future<void> login(BuildContext context, email, password) async {
    bool navigate = true;
    loading = true;
    notifyListeners();
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        loading = false;

        notifyListeners();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      loading = false;
      navigate = false;
      notifyListeners();
    }

    if (navigate) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => AuthStream())));
    }
  }

  Future<void> signUp(
      BuildContext context, uname, email, password, mobile) async {
    bool navigate = true;

    loading = true;
    try {
      loading = true;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        loading = false;
        notifyListeners();
      });
      addUser(uname, email, password, mobile);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      loading = false;
      navigate = false;
      notifyListeners();
    }
    if (navigate) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => AuthStream())));
    }
  }

  Future<void> addUser(uname, email, password, mobile) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference users = _firestore.collection("users");
      final getID = _auth.currentUser!.uid;
      await users.doc(getID).set(
        {
          "email": email,
          "password": password,
          "username": uname,
          "mobile": mobile
        },
      ).then((value) {
        LoginPage().isLogin = !LoginPage().isLogin;
        notifyListeners();
      });
    } catch (e) {
      print("error " + e.toString());
      debugPrint("adduser method : error end");
    }
  }
}

class PasswordVisibilityProvider extends ChangeNotifier {
  bool isPasswordVisible = true;

  void toggleVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
}

/////////////////////////////////==login with phone==//////////////////////////////
///==========================================================================//////
class LoginWithPhoneProvider extends ChangeNotifier {
  bool loading = false;
  final _auth = FirebaseAuth.instance;

  Future<void> login(BuildContext context, String phoneNo) async {
    loading = true;
    notifyListeners();
    String code = '+91';
    String phoneNumber = code + phoneNo;
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {
        loading = false;
        notifyListeners();
      },
      verificationFailed: (e) {
        print("VerificationFailed : " + e.toString());
        loading = false;
        notifyListeners();
      },
      codeSent: (String verificationId, int? Token) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => VerifyPhone(
                      verificationId: verificationId,
                      phoneNo: phoneNo,
                    ))));
        loading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (e) {
        print("codeAutoRetrievalTimeout" + e.toString());
        loading = false;
        notifyListeners();
      },
    );
  }

  Future<void> verify(context, verificationId, sms, phoneNo) async {
    loading = true;
    notifyListeners();
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: sms);
    try {
      await _auth.signInWithCredential(credential);
      addUser(phoneNo).whenComplete(() {}).whenComplete(() {
        loading = false;
        notifyListeners();
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthStream()));
    } catch (e) {
      loading = false;
      notifyListeners();
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> addUser(phoneNo) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference _users = _firestore.collection("users");
    final uid = _auth.currentUser!.uid;
    try {
      await _users.doc(uid).set({
        "mobile": phoneNo,
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

/////////////////////google sign in ====================
class GoogleSignInProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  Future<void> googleSignIn(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )));
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
      AuthCredential credential = await GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      addUser(userCredential, context);
    } catch (e) {
      print("GoogleSignInERROR : " + e.toString());
    }
  }

  Future<void> addUser(
      UserCredential userCredential, BuildContext context) async {
    try {
      final _firestore = await FirebaseFirestore.instance;
      final _users = await _firestore.collection("users");
      final uid = await _auth.currentUser!.uid;
      await _users.doc(uid).set({
        "username": userCredential.user!.displayName,
        "mobile": userCredential.user!.phoneNumber,
        "email": userCredential.user!.email,
        "img": userCredential.user!.photoURL,
        "isGoogleSignin": true
      }).whenComplete(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthStream())));
    } catch (e) {
      print("AddUserERROR: " + e.toString());
    }
  }
}
