
import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../widgets/bullet_row.dart';

class WhereToGetSMC extends StatelessWidget {
  const WhereToGetSMC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(
          0xFFCFA050,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            mainBorderRadius,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Height20(),
          const PrimaryPadding(
            child: Column(
              children: [
                Text(
                  'Where to Get Circumcised Safely in Botswana',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Height10(),
                BulletRow(
                  bulletColor: deepGold,
                  text:
                      'Public hospitals and clinics across Botswana offer circumcision services.',
                ),
                Height10(),
                BulletRow(
                  bulletColor: deepGold,
                    text:
                        'Some private clinics also offer circumcision services. Users can inquire about these clinics locally.'),
                Height10(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(
                0xFF966E2F,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  30,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ministry of Health and Wellness Facilities:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Height10(),
                  const Text(
                    'General Inquiry Phone Number:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Height10(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              mainBorderRadius,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Color(
                                0xFF966E2F,
                              ),
                            ),
                            Width10(),
                            Text(
                              '392 8892',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(
                                    0xFF966E2F,
                                  ),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Width10(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              mainBorderRadius,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.link, color: deepGold),
                            Width10(),
                            Text(
                              'Website',
                              style: TextStyle(
                                fontSize: 20,
                                color: deepGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
