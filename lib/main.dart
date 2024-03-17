import 'package:cnumontifier/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cnumontifier/view/splash.dart';
import 'package:cnumontifier/view/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFC45A36)),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Splash();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      routes: {
        '/splash': (context) => Splash(),
        '/login': (context) => Login(),
        '/home': (context) => Home()
      },
    );
  }
}
