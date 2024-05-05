import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnumontifier/service/auth_service.dart';
import 'package:cnumontifier/service/leaf_collection_service.dart';
import 'package:cnumontifier/view/select_map.dart';
import 'package:cnumontifier/widgets/button.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:cnumontifier/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import './../controller/signin_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class User extends StatefulWidget {
  const User({Key? key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  String? _userId;
  AuthService authService = AuthService();
  LeafService leafService = LeafService();

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

  void _showModal(BuildContext context, DocumentSnapshot leafDoc) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150, // Adjust the height as needed
                width: MediaQuery.of(context).size.width,
                child: Base64ImageWidget(
                  base64Image: leafDoc["leafImage"],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: CustomText(
                  text: "${leafDoc["leafName"]}",
                  textAlign: TextAlign.center,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/information-2-line.svg",
                        width: 20,
                        height: 20,
                        color: ColorTheme.bgColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomText(
                          text: "Characteristics",
                          textAlign: TextAlign.left,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: CustomText(
                              text: "Accuracy",
                              textAlign: TextAlign.left,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: CustomText(
                              text: "${leafDoc["leafAccuracy"]}",
                              textAlign: TextAlign.left,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Slider(
                      min: 0.0,
                      max: 100.0,
                      value: leafDoc["leafAccuracy"],
                      divisions: 4,
                      onChanged: (double value) {},
                      label: "${leafDoc["leafName"]}",
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: CustomText(
                              text: "Shape",
                              textAlign: TextAlign.left,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: CustomText(
                              text: "${leafDoc["leafShape"]}",
                              textAlign: TextAlign.left,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: CustomText(
                              text: "Leaf Area",
                              textAlign: TextAlign.left,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: CustomText(
                              text: "${leafDoc["leafArea"]}",
                              textAlign: TextAlign.left,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: "View location",
                  onPressed: () {
                    // Add functionality here
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectMap(
                          image: leafDoc["leafImage"],
                          latitude: leafDoc["latitude"],
                          longitude: leafDoc["longitude"],
                          edit: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ], // Removed extra closing parenthesis here
          ),
        );
      },
    );
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
                  return FutureBuilder<List<DocumentSnapshot>>(
                    future: leafService.getLeafInfoByUid(_userId),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<DocumentSnapshot>> leafSnapshot) {
                      if (leafSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (leafSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${leafSnapshot.error}'));
                      } else {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          "${snapshot.data?["avatar"]}"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text:
                                                '${snapshot.data?["fullname"]}',
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          CustomText(
                                              text:
                                                  '${snapshot.data?["email"]}',
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: CustomText(
                                        text: "Collections",
                                        textAlign: TextAlign.left,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    StaggeredGrid.count(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      children: List.generate(
                                        leafSnapshot.data!.length,
                                        (index) {
                                          var leafDoc =
                                              leafSnapshot.data![index];
                                          // Access leaf info from the document
                                          var leafImage = leafDoc["leafImage"];
                                          return StaggeredGridTile.count(
                                            crossAxisCellCount:
                                                index % 2 == 0 ? 2 : 1,
                                            mainAxisCellCount:
                                                index % 2 == 0 ? 1 : 2,
                                            child: InkWell(
                                              onTap: () => _showModal(context,
                                                  leafSnapshot.data![index]),
                                              child: Base64ImageWidget(
                                                base64Image: leafImage,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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

class Base64ImageWidget extends StatelessWidget {
  final String base64Image;

  Base64ImageWidget({required this.base64Image});

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(base64Image);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
      ),
    );
  }
}
