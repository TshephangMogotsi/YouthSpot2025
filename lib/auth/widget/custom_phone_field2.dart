import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

class RegisterPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;
  final String? initialCountryCode;
  final String? initialValue;
  final String title;


  const RegisterPhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.initialCountryCode,
    this.initialValue,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        // Custom field style to match your register page fields:
        final OutlineInputBorder customBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.transparent,
            width: 1.2,
          ),
        );

        final Color fieldBackgroundColor = theme == ThemeMode.dark
            ? darkmodeFore
            : const Color(0xFFEEF0F2);
        
        final Color textColor = theme == ThemeMode.dark
            ? Colors.white
            : Colors.black;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Row(
                children: [
                       Width20(),
                  Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                ],
              ),
            const SizedBox(height: 6),
            IntlPhoneField(
              controller: controller,
              initialValue: initialValue,
              initialCountryCode: initialCountryCode ?? "BW",
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                border: customBorder,
                enabledBorder: customBorder,
                focusedBorder: customBorder.copyWith(
                  borderSide: BorderSide(
                    color: errorText != null ? Colors.red : Colors.orange,
                    width: 1.5,
                  ),
                ),
                errorBorder: customBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                errorText: null, // We'll show error below for consistent look
              ),
              style: TextStyle(
                fontSize: 18,
                color: textColor,
              ),
              dropdownTextStyle: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
              languageCode: "en",
              autovalidateMode: AutovalidateMode.disabled,
              onChanged: (phone) {
                onChanged?.call(phone.number);
              },
              onCountryChanged: (country) {
                // Add country code handling if you need
              },
              dropdownIcon: Icon(
                Icons.arrow_drop_down,
                color: theme == ThemeMode.dark ? Colors.grey[400] : Colors.grey,
              ),
              validator: (phone) {
                if (phone == null || phone.number.isEmpty) {
                  return "Please enter your phone number";
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(phone.number)) {
                  return "Please enter a valid phone number";
                }
                return null;
              },
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                child: Text(
                  errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}