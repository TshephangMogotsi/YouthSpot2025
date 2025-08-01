import 'package:flutter/material.dart';
import 'package:youthspot/config/font_constants.dart';

import '../../../../../../config/theme_manager.dart';
import '../../../../../../services/services_locator.dart';

class MedicationInfoHeader extends StatelessWidget {
  const MedicationInfoHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            color: theme == ThemeMode.dark
                ? const Color(0xFF2A2A34) // darkmodeFore in your theme
                : Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // SvgPicture.asset(
                  //   'assets/icons/capsule.svg',
                  //   height: 40,
                  //   width: 40,
                  //   colorFilter: ColorFilter.mode(
                  //     theme == ThemeMode.dark
                  //         ? Colors.grey // from theme
                  //         : const Color(0xFF252150), // properBlack
                  //     BlendMode.srcIn,
                  //   ),
                  // ),
                  Image.asset(
                 'assets/icon/pill_icon.png',
                   
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
               
                  ),
                  const SizedBox(width: 15),
                   Expanded(
                    child: Text(
                      'Track and manage your medication to improve your adherence and effectiveness of your treatment.',
                      textAlign: TextAlign.left,
                    style:AppTextStyles.secondaryRegular ,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}