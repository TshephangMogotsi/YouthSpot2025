import 'package:flutter/material.dart';

import '../../../../config/constants.dart';


class CustomColorPicker extends StatefulWidget {
   const CustomColorPicker({
    super.key,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(4, (int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 5, right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = index;
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
                  child: this.index == index
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        )
                      : null,
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
