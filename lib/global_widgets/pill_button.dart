import 'package:flutter/material.dart';

import '../config/constants.dart';

class PillButton extends StatelessWidget {
  const PillButton(
      {super.key,
      required this.title,
      this.onTap,
      this.backgroundColor = bluishClr,
      this.icon});

  final String title;
  final void Function()? onTap;
  final Color? backgroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  )
                : const SizedBox(),
            SizedBox(width: icon != null ? 5 : 0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
