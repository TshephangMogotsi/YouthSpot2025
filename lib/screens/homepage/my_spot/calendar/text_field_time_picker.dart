
  import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../services/services_locator.dart';
import '../config/utils.dart';

Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<Object>(
      valueListenable: themeManager.themeMode,
      builder: (context,theme, snapshot) {
        return CustomTextField(
          fillColor: theme == ThemeMode.dark ? darkmodeFore : Colors.white,
          controller: controller,
          hintText: hintText,
          maxLines: maxLines,
          validator: validator,
        );
      }
    );
  }

  Widget buildDateTimePickerRow({
    required String label,
    required DateTime date,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: formFieldTitle,
        ),
        const Height10(),
        Row(
          children: [
            Expanded(
              flex: 7,
              child: buildDropDownField(
                text: Utils.toDate(date),
                onClicked: onDateTap,
              ),
            ),
            const Width10(),
            Expanded(
              flex: 4,
              child: buildDropDownField(
                text: Utils.toTime(date),
                onClicked: onTimeTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDropDownField({required String text, required VoidCallback onClicked}) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return ListTile(
          tileColor: theme == ThemeMode.dark ? darkmodeFore : Colors.white,
          shape: const StadiumBorder(),
          title: Text(text,),
          onTap: onClicked,
          trailing: const Icon(Icons.arrow_drop_down),
        );
      }
    );
  }