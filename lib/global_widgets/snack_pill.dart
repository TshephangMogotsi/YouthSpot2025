import 'package:flutter/material.dart';

class SnackPill extends StatelessWidget {
  const SnackPill({
    super.key,
    required this.pillColor,
    this.borderColor,
    required this.title,
    this.hasBorder = false,
    this.onTap,
    this.titleColor = Colors.white,
  });

  final Color? pillColor;
  final Color? borderColor;
  final Color? titleColor;
  final String title;
  final bool hasBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 60,
        minHeight: 20,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(16),
            border: hasBorder
                ? Border.all(
                    color: borderColor ?? Colors.white,
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:  TextStyle(
                  color: titleColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
