import 'package:youthspot/config/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final void Function()? onTap;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    // this.style,
    this.customBackgroundColor,
  });

  // final PrimaryButtonStyle? style;
  final Color? customBackgroundColor;

  @override
  Widget build(BuildContext context) {
    // PrimaryButtonStyle? defaultStyle =
    //     Theme.of(context).extension<PrimaryButtonStyle>();
    // Color? backgroundColor =
    //     style?.backgroundColor ?? defaultStyle?.backgroundColor;
    // double? height = style?.height ?? defaultStyle?.height;
    // double? width = style?.width ?? defaultStyle?.width;
    // TextStyle? labelstyle = style?.labelStyle ?? defaultStyle?.labelStyle;

    return SelectionContainer.disabled(
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kSSIorange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
          ),
        ),
      ),
    );
  }
}
