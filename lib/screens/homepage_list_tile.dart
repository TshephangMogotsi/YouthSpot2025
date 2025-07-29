import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../config/constants.dart';
import '../global_widgets/primary_padding.dart';


class HomePageListTile extends StatelessWidget {
  const HomePageListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgURL,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final String svgURL;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();


    return GestureDetector(
      onTap: onTap,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context,theme, snapshot) {
          return PrimaryPadding(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme == ThemeMode.dark ? darkmodeFore : Colors.white,
                borderRadius: BorderRadius.circular(mainBorderRadius),
              ),
              child: Row(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(innerBorderRadius),
                      image: DecorationImage(
                        image: Svg(svgURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Width20(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: homePageListTitleStyleLight),
                        Text(subtitle, style: subTitleStyle),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
