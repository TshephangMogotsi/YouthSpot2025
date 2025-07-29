import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.title,
    this.widget,
    this.onChanged,
    this.controller,
    this.isPasswordField,
    this.validator,
    this.maxLines = 1,
    this.isOnWhiteBackground = false,
    this.fillColor, // New parameter for fillColor
  });

  final String? title;
  final String hintText;
  final Widget? widget;
  final bool isOnWhiteBackground;
  final int maxLines;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool? isPasswordField;
  final String? Function(String?)? validator;
  final Color? fillColor; // New fillColor field

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Height10(),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeManager.themeMode,
                  builder: (context, theme, snapshot) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextFormField(
                        maxLines: widget.maxLines,
                        obscureText: widget.isPasswordField == true
                            ? _obscureText
                            : false,
                        controller: widget.controller,
                        validator: widget.validator,
                        onChanged: (value) {
                          setState(() {
                            _errorText = widget.validator?.call(value);
                          });
                          widget.onChanged?.call(value);
                        },
                        readOnly: widget.widget == null ? false : true,
                        autofocus: false,
                        cursorColor: Colors.grey[100],
                        style: subTitleStyle.copyWith(fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: widget.fillColor ??
                              (theme == ThemeMode.dark
                                  ? Colors.transparent
                                  : Colors.white),
                          hintText: widget.hintText,
                          hintStyle: subTitleStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey[700]),
                          suffixIcon: widget.isPasswordField == true
                              ? IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                )
                              : null,
                          // Reducing the vertical height by adjusting contentPadding
                          contentPadding: const EdgeInsets.symmetric(
                            vertical:
                                10.0, // Adjust this value for height reduction
                            horizontal: 20.0, // Horizontal padding
                          ),

                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(34)),
                            borderSide: BorderSide(
                              width: 1.3,
                              color: kSSIorange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(34)),
                            borderSide: BorderSide(
                              width: 1,
                              color: theme == ThemeMode.dark
                                  ? Colors.transparent
                                  : widget.isOnWhiteBackground
                                      ? Colors.white
                                      : Colors.white,
                            ),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(34)),
                            borderSide: BorderSide(
                              color: kSSIorange,
                              width: 1,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(34)),
                            borderSide: BorderSide(
                              color: pinkClr,
                              width: 1.0,
                            ),
                          ),
                          errorStyle: const TextStyle(color: pinkClr),
                          errorText: _errorText,
                        ),
                      ),
                    );
                  }),
            ),
            if (widget.widget != null) widget.widget!
          ],
        ),
      ],
    );
  }
}
