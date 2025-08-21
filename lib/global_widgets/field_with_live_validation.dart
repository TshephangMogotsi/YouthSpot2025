import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/font_constants.dart';

///
/// Reusable text field with live validation and password visibility toggle.
/// Includes built-in 20px left spacing for consistent styling.
///
class FieldWithLiveValidation extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final String? Function(String?) validator;
  final bool isPassword;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;
  final Function(String)? onChanged;
  final String? leadingAsset; // <-- NEW
  final bool readOnly; // <-- NEW

  const FieldWithLiveValidation({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.errorText,
    this.isPassword = false,
    this.trailingIcon,
    this.onTrailingPressed,
    this.onChanged,
    this.leadingAsset, // <-- NEW
    this.readOnly = false, // <-- NEW
  });

  @override
  State<FieldWithLiveValidation> createState() =>
      _FieldWithLiveValidationState();
}

class _FieldWithLiveValidationState extends State<FieldWithLiveValidation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Width20(), // Built-in 20px left spacing
            Text(widget.title, style: AppTextStyles.primaryBold),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFEEF0F2),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: widget.errorText != null ? Colors.red : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              if (widget.leadingAsset != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    widget.leadingAsset!,
                    height: 24,
                    width: 24,
                  ),
                ),
                SizedBox(width: 5,),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.isPassword,
                  readOnly: widget.readOnly,
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.readOnly ? Colors.grey[600] : null,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    errorText: null,
                  ),
                  onChanged: widget.readOnly ? null : widget.onChanged,
                ),
              ),
              if (widget.trailingIcon != null)
                IconButton(
                  icon: Icon(widget.trailingIcon, color: Colors.grey[700]),
                  onPressed: widget.onTrailingPressed,
                ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
///
/// Dropdown with live validation for gender.
/// Includes built-in 20px left spacing for consistent styling.
///
class DropdownWithLiveValidation extends StatelessWidget {
  final String title;
  final String hintText;
  final String? value;
  final List<String> items;
  final String? errorText;
  final void Function(String?)? onChanged;

  const DropdownWithLiveValidation({
    super.key,
    required this.title,
    required this.hintText,
    required this.value,
    required this.items,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Width20(), // Built-in 20px left spacing
            Text(title, style: AppTextStyles.primaryBold),
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
              color: errorText != null ? Colors.red : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hintText,
                style: AppTextStyles.primaryRegular
              ),
              isExpanded: true,
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: AppTextStyles.primaryRegular),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}