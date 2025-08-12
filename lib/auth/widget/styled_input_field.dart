import 'package:flutter/material.dart';
import 'package:youthspot/config/constants.dart';

class StyledInputField extends StatelessWidget {
  final String title;
  final String? hintText;
  final bool isPassword;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool showError;
  final String? errorText;

  const StyledInputField({
    super.key,
    required this.title,
    this.hintText,
    this.isPassword = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedValue,
    this.onChanged,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingPressed,
    this.controller,
    this.validator,
    this.showError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Width10(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF0F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: showError ? Colors.red : Colors.transparent,
              width: showError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: Colors.grey[700]),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: isDropdown
                    ? DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          hint: Text(
                            hintText ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          isExpanded: true,
                          items: dropdownItems!
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ))
                              .toList(),
                          onChanged: onChanged,
                        ),
                      )
                    : TextFormField(
                        controller: controller,
                        obscureText: isPassword,
                        style: const TextStyle(fontSize: 18),
                        validator: validator,
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
              ),
              if (trailingIcon != null)
                IconButton(
                  icon: Icon(trailingIcon, color: Colors.grey[700]),
                  onPressed: onTrailingPressed,
                ),
            ],
          ),
        ),
        if (showError && errorText != null)
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
  }
}