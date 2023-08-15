import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in/pages/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final _firestore = FirebaseFirestore.instance;
    // bool loading = Provider.of(context).LoadingProvider.loading;
    // Future<List> getUserInfo() async {
    //   List userInfo = [];
    //   final documentSnapshot =
    //       await _firestore.collection('users').doc(getUid).get();
    //   userInfo = documentSnapshot.data()?['username'];
    //   return userInfo;
    // }

    // final _auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    String getUserId() {
      try {
        String getUid;
        final _auth = FirebaseAuth.instance;
        getUid = _auth.currentUser!.uid;
        return getUid;
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      return '';
    }

    return FutureBuilder(
      future: users.doc(getUserId()).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return WillPopScope(
            onWillPop: () async {
              return FirebaseAuth.instance.currentUser != null;
            },
            child:
                Consumer<LoadingProvider>(builder: (context, provider, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("User Profile : ${data['username']}"),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome : ${data['username']}'),
                      Text("Mobile : ${data['mobile']}"),
                      ElevatedButton(
                        onPressed: () => provider.signOut(context),
                        child: provider.loading
                            ? CircularProgressIndicator(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              )
                            : Text("Sign Out"),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }
        return Scaffold(
            backgroundColor: Color.fromARGB(255, 153, 255, 233),
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )));
      },
    );
  }
}
