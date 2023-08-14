import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in/pages/provider_widget.dart';
import 'package:firebase_in/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
    ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
    ChangeNotifierProvider<PasswordVisibilityProvider>(
        create: (_) => PasswordVisibilityProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = "FirebaseIn";
    return MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.teal),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
