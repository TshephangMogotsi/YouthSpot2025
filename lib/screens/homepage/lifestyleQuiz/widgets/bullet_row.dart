import 'package:flutter/material.dart';


class BulletRow extends StatelessWidget {
  const BulletRow({
    super.key,
    required this.text,
    required this.bulletColor,
  });

  final String text;
  final Color bulletColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            CircleAvatar(
              radius: 10,
              backgroundColor: bulletColor,
            ),
          ],
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
