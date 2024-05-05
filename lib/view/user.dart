import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnumontifier/service/auth_service.dart';
import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:cnumontifier/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './../controller/signin_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  String? _userId;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<DocumentSnapshot?>(
              future:
                  _userId != null ? authService.getUserInfo(_userId!) : null,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  // Assuming the document contains fields like 'name' and 'email'
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage("${snapshot.data?["avatar"]}"),
                                backgroundColor: Colors.transparent,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: '${snapshot.data?["fullname"]}',
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CustomText(
                                        text: '${snapshot.data?["email"]}',
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: CustomButton(
                              text: 'Sign out',
                              onPressed: () {
                                _signInController.signOut();
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              backgroundColor: ColorTheme.accentColor,
                            ),
                          ),
                          StaggeredGrid.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: List.generate(20, (index) {
                              return StaggeredGridTile.count(
                                crossAxisCellCount: index % 2 == 0 ? 2 : 1,
                                mainAxisCellCount: index % 2 == 0 ? 1 : 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blue[100 * (index % 9)],
                                  ),
                                  child: Center(child: Text('Item $index')),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('User not found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
