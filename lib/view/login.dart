import 'package:cnumontifier/view/home.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:cnumontifier/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/signin_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final SignInController _signinController = SignInController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Home();
        } else {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).padding.top),
              child: SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/final_logo.png',
                          width: 150, height: 150),
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
                        child: SvgPicture.asset(
                          'assets/images/login.svg',
                          height: 150,
                          width: 150,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _signinController.signInWithGoogle();
                        },
                        child: Container(
                          margin: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: ColorTheme.accentColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/googlelogo.png',
                                    width: 20, height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: CustomText(
                                    text: "Sign in with Google",
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                    color: ColorTheme.textColorLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
