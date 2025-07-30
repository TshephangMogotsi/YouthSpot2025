import 'package:flutter/material.dart';
import 'package:youthspot/screens/Account/account.dart';
import 'package:youthspot/screens/homepage.dart';
import 'package:youthspot/screens/resources/resources.dart';
import 'package:youthspot/screens/services/services.dart';
import 'package:youthspot/screens/sos_screen.dart';
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
    Placeholder(), // Leaderboard
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SOSScreen()),
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.sos),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: theme == ThemeMode.dark ? const Color(0xFF0A0A0A) : backgroundColorLight,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(0, 'Home', 'assets/icon/Home.svg', 'assets/icon/home_outline.svg'),
                _buildNavItem(1, 'Resources', 'assets/icon/folder.svg', 'assets/icon/folder_outline.svg'),
                const SizedBox(width: 40), // The space for the FAB
                _buildNavItem(2, 'Services', 'assets/icon/Services.svg', 'assets/icon/services_outline.svg'),
                _buildNavItem(3, 'Leaderboard', 'assets/icon/trophy.svg', 'assets/icon/trophy_outline.svg'),
                _buildNavItem(4, 'Account', 'assets/icon/profile.svg', 'assets/icon/profile_outline.svg'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, String label, String activeIcon, String inactiveIcon) {
    return IconButton(
      icon: SvgPicture.asset(
        _selectedIndex == index ? activeIcon : inactiveIcon,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(
          _selectedIndex == index ? kSSIorange : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
      onPressed: () => _onItemTapped(index),
      tooltip: label,
    );
  }
}

