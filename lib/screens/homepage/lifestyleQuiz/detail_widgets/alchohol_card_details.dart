import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/primary_scaffold.dart';
import '../widgets/bullet_row.dart';

class AlcoholAndDrugsDetailsPage extends StatefulWidget {
  const AlcoholAndDrugsDetailsPage({super.key});

  @override
  State<AlcoholAndDrugsDetailsPage> createState() =>
      _AlcoholAndDrugsDetailsPageState();
}

class _AlcoholAndDrugsDetailsPageState
    extends State<AlcoholAndDrugsDetailsPage> {
  bool isExpanded = false;

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
                color: blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    mainBorderRadius,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryPadding(
                    // verticalPadding: true,
                    
                    child: Column(
                      children: [
                        const Height20(),
                        const Text(
                          'Signs of Alcohol and/or Substance Abuse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Height10(),
                        AnimatedCrossFade(
                          firstChild: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Craving: Strong desire or compulsion to drink.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Loss of Control: Inability to limit alcohol intake.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Physical Dependence: Tolerance and withdrawal symptoms.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Neglecting Activities: Spending a lot of time on alcohol-related activities.',
                              ),
                              Height10(),
                            ],
                          ),
                          secondChild: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Craving: Strong desire or compulsion to drink.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Loss of Control: Inability to limit alcohol intake.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Physical Dependence: Tolerance and withdrawal symptoms.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Neglecting Activities: Spending a lot of time on alcohol-related activities.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Continued Use Despite Consequences: Drinking despite knowing it causes problems.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Social Problems: Alcohol-related conflicts with others.',
                              ),
                              Height10(),
                              BulletRow(
                                bulletColor: deepBlue,
                                text:
                                    'Risk-Taking: Engaging in risky behaviors while drinking.',
                              ),
                              Height10(),
                            ],
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isExpanded ? 'Show Less' : 'View More',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const Height10(),
                      ],
                    ),
                  ),
                  // const Height10(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: deepBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          24,
                        ),
                      ),
                    ),
                    child: const PrimaryPadding(
                      verticalPadding: true,
                      child: Text(
                        'These symptoms can range from mild to severe, and the presence of two or more within a 12-month period may indicate the presence of alcohol use disorder. Seeking help from healthcare professionals, counselors, or support groups is crucial for managing and overcoming AUD.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const Height10(),
                ],
              ),
            ),
          ),
          const Height20(),
          PrimaryPadding(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: blue,
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
                          'Where to Get Help for Alcoholism in Botswana',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Height10(),
                        BulletRow(
                          bulletColor: deepBlue,
                          text:
                              'Many public hospitals and health centers in Botswana provide alcohol and substance abuse treatment services.',
                        ),
                        Height10(),
                        BulletRow(
                          bulletColor: deepBlue,
                          text:
                              'Some private clinics also offer substance abuse services. Users can inquire about these clinics locally.',
                        ),
                        Height10(),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: deepBlue,
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
                                      color: deepBlue,
                                    ),
                                    Width10(),
                                    Text(
                                      '392 8892',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: deepBlue,
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
                                      color: deepBlue,
                                    ),
                                    Width10(),
                                    Text(
                                      'Website',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: deepBlue,
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
                    color: blue,
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
                    color: deepBlue,
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
                        'Alcohol Abuse',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      BulletRow(
                        bulletColor: blue,
                        text:
                            'Excessive drinking can lead to serious health problems, including liver disease and heart issues.',
                      ),
                      SizedBox(height: 8),
                      BulletRow(
                          bulletColor: blue,
                          text:
                              'Avoid binge drinking and seek help if you find it difficult to control your alcohol consumption.'),
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
