
import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../widgets/bullet_row.dart';

class SignOfAlcoholism extends StatelessWidget {
  const SignOfAlcoholism({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: cherry,
        borderRadius: BorderRadius.all(
          Radius.circular(
            mainBorderRadius,
          ),
        ),
      ),
      child: const PrimaryPadding(
        verticalPadding: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benefits of Circumcision',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Height10(),
            BulletRow(
              bulletColor: deepCherry,
              text:
                  'Reduced risk of HIV and other sexually transmitted infections (STIs)',
            ),
            Height10(),
            BulletRow(bulletColor: deepCherry,text: 'Lower risk of urinary tract infections'),
            Height10(),
            Height10(),
            BulletRow(
              bulletColor: deepCherry,
              text:
                  'Reduced risk of HIV and other sexually transmitted infections (STIs).',
            ),
            Height10(),
            BulletRow(
              bulletColor: deepCherry,
              text: 'Potential decrease in risk of penile cancer.',
            ),
          ],
        ),
      ),
    );
  }
}
