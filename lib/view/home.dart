import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'scan.dart';
import 'map.dart';
import 'user.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 0;

  final List<Widget> _pages = [ScannerScreen(), const Map(), const User()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showModal(context);
    });
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext modalContext) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "User Manual",
                        textAlign: TextAlign.start,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(modalContext);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/x-solid.svg',
                          height: 15,
                          width: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: CustomText(
                    text:
                        """This user manual will assist you in utilizing the application efficiently to identify C. mindanaense leaves accurately. Please follow the instructions carefully for optimal results.""",
                    textAlign: TextAlign.start,
                    fontSize: 14,
                  ),
                ),
                _buildStep(
                  "1. Prepare the Leaf Sample:",
                  [
                    "Use an A4 bond paper size as a background for the leaf sample.",
                    "Ensure the leaf is positioned flush against each side of the paper to provide a clear contrast.",
                    "Flatten or press the leaf gently. This step is crucial to eliminate shadows that may interfere with accurate measurements of the leaf's length and width.",
                    "Ensure the camera lens is clean and free from any obstructions to capture high-quality images.",
                    "Avoid capturing images of damaged or incomplete leaf samples, as this may affect the accuracy of the identification process."
                  ],
                ),
                _buildStep(
                  "2. Capture the Image:",
                  [
                    "Open the Cinnamon Species Identification App on your device.",
                    "Position the camera directly above the prepared leaf sample.",
                    "Ensure good lighting conditions to capture a clear and detailed image. Natural light or well-lit environments are recommended for best results.",
                    "Align the leaf centrally within the camera frame to capture the entire leaf surface."
                  ],
                ),
                _buildStep(
                  "3. Analyze the Image:",
                  [
                    "Once the image is captured, the app will process the data and analyze the characteristics of the cinnamon leaf.",
                    "Wait for the analysis to complete. This may take a few moments depending on the complexity of the leaf.",
                    "Review the identification results displayed by the app. The app will provide information on the species of cinnamon corresponding to the analyzed leaf."
                  ],
                ),
                _buildStep(
                  "4. Interpretation of Results:",
                  [
                    "Carefully examine the identified species provided by the app.",
                    "Compare the characteristics with known traits of different cinnamon species for confirmation.",
                    "If uncertain about the identification results, you can capture additional images of the leaf sample or seek expert consultation."
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(String title, List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          textAlign: TextAlign.start,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        for (var step in steps)
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(fontSize: 12)),
                Expanded(
                  child: CustomText(
                    text: step,
                    textAlign: TextAlign.start,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: Container(
        height: 60.0,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
          child: BottomNavigationBar(
              backgroundColor: ColorTheme.textColorLight,
              unselectedFontSize: 0,
              selectedFontSize: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedPage,
              onTap: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _selectedPage == 0
                            ? 'assets/icons/home-fill.svg'
                            : 'assets/icons/home-line.svg',
                        color: ColorTheme.accentColor,
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _selectedPage == 1
                            ? 'assets/icons/map-pin-fill.svg'
                            : 'assets/icons/map-pin-line.svg',
                        color: ColorTheme.accentColor,
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _selectedPage == 2
                            ? 'assets/icons/user-fill.svg'
                            : 'assets/icons/user-line.svg',
                        color: ColorTheme.accentColor,
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown),
                    label: ''),
              ]),
        ),
      ),
    );
  }
}
