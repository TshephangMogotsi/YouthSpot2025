import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../widgets/bullet_row.dart';

class WhereToGetAlcHelp extends StatelessWidget {
  const WhereToGetAlcHelp({
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
                  bulletColor: deepCherry,
                  text:
                      'Many public hospitals and health centers in Botswana provide alcohol and substance abuse treatment services.',
                ),
                Height10(),
                BulletRow(
                    bulletColor: deepCherry,
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
              color: deepCherry,
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
                    'Botswana Substance Abuse Support Network (BOSASNet):',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Height10(),
                    const Text(
                    'Provides counseling, support groups, and treatment referrals for individuals struggling with alcoholism and other substance use disorders.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Height10(),
                  const Text(
                    'Helpline:',
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
                              color: deepCherry,
                            ),
                            Width10(),
                            Text(
                              '392 8892',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: deepCherry,
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
                            Icon(
                              Icons.link,
                              color: deepCherry,
                            ),
                            Width10(),
                            Text(
                              'Website',
                              style: TextStyle(
                                fontSize: 20,
                                color: deepCherry,
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
