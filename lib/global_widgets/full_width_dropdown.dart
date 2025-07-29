import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

class FullWidthDropdownButton extends StatefulWidget {
  const FullWidthDropdownButton(
      {super.key,
      required this.options,
      required this.showError,
      this.onOptionSelect,
      required this.hintText});
  final List<String> options;
  final bool showError;
  final String hintText;
  final void Function(String)? onOptionSelect;

  @override
  State<FullWidthDropdownButton> createState() =>
      _FullWidthDropdownButtonState();
}

class _FullWidthDropdownButtonState extends State<FullWidthDropdownButton> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: theme == ThemeMode.light ? Colors.white : darkmodeFore,
              border: Border.all(
                color: widget.showError ? pinkClr : theme == ThemeMode.dark ? darkmodeFore : Colors.white,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 12,
                  hint: Padding(padding: const EdgeInsets.only(left: 10), child: Text(widget.hintText, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),)),
                  dropdownColor: theme == ThemeMode.dark
                      ? darkmodeFore
                      : Colors.white,
                  borderRadius: BorderRadius.circular(mainBorderRadius),
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      widget.onOptionSelect?.call(newValue!);
                    });
                  },
                  items: widget.options
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }
}
