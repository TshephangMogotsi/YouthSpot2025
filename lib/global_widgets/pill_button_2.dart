import 'package:flutter/material.dart';

import '../config/constants.dart';

class PillButton2 extends StatelessWidget {
  const PillButton2({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
  });

  final String title;
  final void Function()? onTap;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mainBorderRadius),
          color: kSSIorange,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? Container(),
            icon != null
                ? const SizedBox(
                    width: 5,
                  )
                : Container(),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            icon != null
                ? const SizedBox(
                    width: 10,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}