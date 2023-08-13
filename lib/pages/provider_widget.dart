import 'package:firebase_auth/firebase_auth.dart';
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
