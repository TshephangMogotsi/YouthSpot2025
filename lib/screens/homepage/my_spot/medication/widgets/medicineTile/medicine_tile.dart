import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../config/constants.dart';
import '../../../../../../config/theme_manager.dart';
import '../../../../../../global_widgets/primary_container.dart';
import '../../../../../../services/services_locator.dart';

class MedicineTile extends StatelessWidget {
  const MedicineTile({
    super.key,
    required this.isOtherSelected,
    required this.selectedIndex,
    required this.index,
  });

  final bool isOtherSelected;
  final int? selectedIndex;
  final int index;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return Container(
      margin: index == 0
          ? const EdgeInsets.only(right: 10)
          : index == 1
              ? const EdgeInsets.symmetric(horizontal: 5)
              : const EdgeInsets.only(left: 10),
      child: AspectRatio(
        aspectRatio: 1,
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeManager.themeMode,
          builder: (context, theme, snapshot) {
            final Color textColor = theme == ThemeMode.dark
                ? Colors.white
                : const Color(0xFF252150);
            return PrimaryContainer(
              activeBorder: Border.all(
                color: selectedIndex == index
                    ? Colors.transparent
                    : theme == ThemeMode.dark
                        ? const Color(0xFF2A2A34)
                        : Colors.white,
                width: 0,
              ),
              bgColor: selectedIndex == index
                  ? kSSIorange
                  : theme == ThemeMode.dark
                      ? const Color(0xFF2A2A34)
                      : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    index == 0
                        ? 'assets/icons/pill.svg'
                        : index == 1
                            ? 'assets/icons/capsule_icon.svg'
                            : 'assets/icons/medicine.svg',
                    height: 30,
                    width: 30,
                    colorFilter: !isOtherSelected
                        ? selectedIndex == index
                            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                            : theme == ThemeMode.light
                                ? const ColorFilter.mode(Color(0xFF252150), BlendMode.srcIn)
                                : const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                        : null,
                  ),
                  const Height10(),
                  Text(
                    index == 0
                        ? 'Pill'
                        : index == 1
                            ? 'Capsule'
                            : 'Syrup',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ).copyWith(
                      color: selectedIndex == index ? Colors.white : textColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}