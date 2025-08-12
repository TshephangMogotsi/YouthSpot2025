import 'package:flutter/material.dart';

import '../../config/constants.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? Function(String?) validator;
  final Function(String)? onChanged;
  final String title;
  final String hintText;
  final String initialCountryCode;

  const CustomPhoneField({
    super.key,
    required this.controller,
    required this.validator,
    this.errorText,
    this.onChanged,
    required this.title,
    required this.hintText,
    this.initialCountryCode = 'BW',
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late String _countryCode;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.initialCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
                 Width20(),
            Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
              color: widget.errorText != null ? Colors.red : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              DropdownButton<String>(
                value: _countryCode,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'BW', child: Text("+267")),
                  DropdownMenuItem(value: 'ZA', child: Text("+27")),
                  DropdownMenuItem(value: 'US', child: Text("+1")),
                  // Add more country codes as needed
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _countryCode = val;
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    errorText: null,
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4.0),
            child: Text(
              widget.errorText!,
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