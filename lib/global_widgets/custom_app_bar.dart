import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.context,
    required this.isHomePage,
  });

  final BuildContext context;
  final bool isHomePage;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: theme == ThemeMode.dark
              ? const Color(0xFF0A0A0A) 
              : backgroundColorLight,
          elevation: 0,
          leading: widget.isHomePage ? Container() : IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: theme == ThemeMode.dark ? Colors.white : const Color(0xFF272727),
            ),
          ),
          title: widget.isHomePage
              ? SvgPicture.asset(
                  'assets/icon/appicon_homepage.svg',
                  height: 35, // Adjust as needed for sizing
                  width: 35,
                  colorFilter: ColorFilter.mode(
                    theme == ThemeMode.dark ? Colors.white : kSSIorange,
                    BlendMode.srcIn,
                  ),
                )
              : const Text(""),
          centerTitle: true,
          actions: widget.isHomePage ? [Container()] : [],
        );
      },
    );
  }
}
