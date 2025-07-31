import 'package:flutter/material.dart';
import 'package:youthspot/screens/Account/account.dart';
import 'package:youthspot/screens/homepage.dart';
import 'package:youthspot/screens/resources/resources.dart';
import 'package:youthspot/screens/services/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'article_page.dart';
import 'config/constants.dart';
import 'config/theme_manager.dart';
import 'services/services_locator.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  // Define the pages for the bottom navigation bar
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DocumentPage(), // Resources
    ServicesScreen(), // Services
    // Placeholder(), // Leaderboard
    Account(), // Account
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme == ThemeMode.dark
                ? const Color(0xFF0A0A0A)
                : backgroundColorLight,
            selectedItemColor: kSSIorange,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 0
                      ? 'assets/icon/Home.svg'
                      : 'assets/icon/home_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 1
                      ? 'assets/icon/folder.svg'
                      : 'assets/icon/folder_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 1 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Resources',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 2
                      ? 'assets/icon/Services.svg'
                      : 'assets/icon/services_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 2 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Services',
              ),
              // BottomNavigationBarItem(
              //   icon: SvgPicture.asset(
              //     _selectedIndex == 3
              //         ? 'assets/icon/trophy.svg'
              //         : 'assets/icon/trophy_outline.svg',
              //     height: 20,
              //     width: 20,
              //     colorFilter: ColorFilter.mode(
              //       _selectedIndex == 3 ? kSSIorange : Colors.grey,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              //   label: 'Leaderboard',
              // ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 4
                      ? 'assets/icon/profile.svg'
                      : 'assets/icon/profile_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 4 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }
}

