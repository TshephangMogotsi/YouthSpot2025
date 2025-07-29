import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';

class EventColorPicker extends StatefulWidget {
  const EventColorPicker({
    super.key,
  });

  @override
  State<EventColorPicker> createState() => _EventColorPickerState();
}

class _EventColorPickerState extends State<EventColorPicker> {
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: formFieldTitle,
        ),
        const Height10(),
        Wrap(
          children: List<Widget>.generate(
            4,
            (int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorIndex = index;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: index == 0
                        ? const Color(0xFFCBEFED)
                        : index == 1
                            ? const Color(0xFF6742A7)
                            : index == 2
                                ? const Color(0xFFff6600)
                                : index == 3
                                    ? const Color(0xFFff5555)
                                    : Colors.white,
                    radius: 14,
                    child: selectedColorIndex == index
                        ? ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeManager.themeMode,
                            builder: (context, theme, snapshot) {
                              return Icon(
                                FontAwesomeIcons.check,
                                color: index == 0
                                    ? const Color.fromARGB(255, 0, 114, 108)
                                    : index == 1
                                        ? const Color.fromARGB(
                                            255, 255, 255, 255)
                                        : index == 2
                                            ? const Color.fromARGB(
                                                255, 255, 255, 255)
                                            : index == 3
                                                ? const Color.fromARGB(
                                                    255, 255, 255, 255)
                                                : Colors.white,
                                size: 18,
                              );
                            })
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}