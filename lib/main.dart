import 'package:cnumontifier/controller/classify_image_controller.dart';
import 'package:cnumontifier/view/home.dart';
import 'package:cnumontifier/widgets/scan/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cnumontifier/view/splash.dart';
import 'package:cnumontifier/view/login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => ClassifyImageController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC45A36)),
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
        '/splash': (context) => const Splash(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/camera': (context) => const Camera(),
      },
    );
  }
}
