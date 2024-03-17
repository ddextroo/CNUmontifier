import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import './../controller/signin_controller.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
  
}

class _UserState extends State<User> {
  @override
  void initState() {
    // TODO: implement initState
    debugPrint("test");
    super.initState();
  }
  SignInController _signInController = SignInController();
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
          child: CustomButton(
            text: 'Sign out',
            onPressed: () {
              _signInController.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            backgroundColor: ColorTheme.accentColor,
          ),
        ));
  }
}
