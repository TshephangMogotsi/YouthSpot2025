import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/primary_scaffold.dart';
import '../widgets/bullet_row.dart';

class SexualHealthDetailsPage extends StatelessWidget {
  const SexualHealthDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          PrimaryPadding(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: teal,
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
                      'Signs of Risky Sexual Behavior',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepTeal,
                      text: 'Having multiple sexual partners.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepTeal,
                      text: 'Engaging in unprotected sex.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepTeal,
                      text: 'Inconsistent use of contraceptives.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepTeal,
                      text: 'Participating in sex parties.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepTeal,
                      text: 'Having sex with partners of unknown HIV status.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepTeal,
                      text: 'Using drugs and engaging in risky sexual activities.',
                    ),
                    Height10(),
                    Text(
                      'These behaviors can increase the risk of sexually transmitted infections (STIs) and unintended pregnancies. It is important to practice safe sex and get regular health check-ups.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Height10(),
                  ],
                ),
              ),
            ),
          ),
          const Height20(),
          PrimaryPadding(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: teal,
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
                          'Where to Get Help for Sexual Health in Botswana',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Height10(),
                        BulletRow(
                          bulletColor: deepTeal,
                          text:
                              'Public hospitals and health centers across Botswana provide sexual and reproductive health services.',
                        ),
                        Height10(),
                        BulletRow(
                          bulletColor: deepTeal,
                          text:
                              'Some private clinics and organizations offer specialized sexual health services. Users can inquire about these facilities locally.',
                        ),
                        Height10(),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: deepTeal,
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
                            'Botswana Sexual Health Support Network (BSHSN):',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Height10(),
                          const Text(
                            'Provides counseling, support groups, and treatment referrals for individuals struggling with sexual health issues.',
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
                                      color: deepTeal,
                                    ),
                                    Width10(),
                                    Text(
                                      '391 8233',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: deepTeal,
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
                                      color: deepTeal,
                                    ),
                                    Width10(),
                                    Text(
                                      'Website',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: deepTeal,
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
            ),
          ),
          const Height20(),
          PrimaryPadding(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: teal,
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
                    color: deepTeal,
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
                        'Sexual Health Risks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      BulletRow(
                        bulletColor: teal,
                        text:
                            'Unprotected sex increases the risk of STIs and unintended pregnancies. It is crucial to use protection consistently.',
                      ),
                      SizedBox(height: 8),
                      BulletRow(
                          bulletColor: teal,
                          text:
                              'Regular health check-ups and open communication with your partner(s) about sexual health are important for maintaining sexual well-being.'),
                      Height10(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Height20(),
        ],
      ),
    );
  }
}
