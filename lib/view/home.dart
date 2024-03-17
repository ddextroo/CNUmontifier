import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'scan.dart';
import 'map.dart';
import 'gallery.dart';
import 'user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 0;

  final List<Widget> _pages = [ScannerScreen(), Map(), Gallery(), User()];

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
                    label: ''   ),
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
                            ? 'assets/icons/gallery-fill.svg'
                            : 'assets/icons/gallery-line.svg',
                        color: ColorTheme.accentColor,
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        _selectedPage == 3
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