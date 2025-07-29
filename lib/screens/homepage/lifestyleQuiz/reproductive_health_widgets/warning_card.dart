
import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../widgets/bullet_row.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(mainBorderRadius),
              topRight: Radius.circular(mainBorderRadius),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              Icon(
                Icons.info,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Warnings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: deepGold,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(mainBorderRadius),
              bottomRight: Radius.circular(mainBorderRadius),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Traditional Circumcision',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              BulletRow(
                bulletColor: deepGold,
                text:
                    'Caution against traditional circumcision practices done outside of medical facilities, as they may pose health risks due to lack of sterile conditions and trained practitioners.',
              ),
              SizedBox(height: 8),
              Text(
                'Non-medical Providers:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              BulletRow(
                bulletColor: deepGold,
                  text:
                      'Warn against getting circumcised by non-medical practitioners or in unregulated settings.'),
              Height10(),
            ],
          ),
        ),
      ],
    );
  }
}
