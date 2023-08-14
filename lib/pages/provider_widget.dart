import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in/pages/login_page.dart';
import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  void signOut(BuildContext context) {
    loading = true;
    notifyListeners();
    try {
      _auth.signOut().whenComplete(() {
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
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  Future<void> login(BuildContext context, email, password) async {
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
      notifyListeners();
    }
  }

  Future<void> signUp(BuildContext context, uname, email, password) async {
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
      addUser(uname, email, password);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(uname, email, password) async {
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
