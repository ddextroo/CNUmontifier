import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package

class Splash extends StatefulWidget {
 const Splash({super.key});

 @override
 State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

 @override
 void initState() {
    super.initState();
    // Set the status bar to be transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFb94e29), // Transparent status bar
    ));
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Container(
        color: Color(0xFFb94e29),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/w_bg_logo.png', width: 250, height: 250),
            ],
          ),
        ),
      ),
    );
 }
}
