import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/primary_scaffold.dart';
import '../widgets/bullet_row.dart';

class GenderBasedViolenceDetailsPage extends StatelessWidget {
  const GenderBasedViolenceDetailsPage({super.key});

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
                      'Signs of Gender-Based Violence',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepCherry,
                      text: 'Physical injuries such as bruises, cuts, or broken bones.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepCherry,
                      text: 'Emotional abuse such as humiliation, insults, or threats.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepCherry,
                      text: 'Controlling behavior, isolation from friends and family.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepCherry,
                      text: 'Financial control or restriction.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepCherry,
                      text: 'Sexual abuse or coercion.',
                    ),
                    Height10(),
                    BulletRow(
                      bulletColor: deepCherry,
                      text: 'Stalking or persistent harassment.',
                    ),
                    Height10(),
                    Text(
                      'These signs can indicate gender-based violence. If you recognize any of these signs, seek help immediately.',
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
                          'Where to Get Help for Gender-Based Violence in Botswana',
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
                              'Many public hospitals and health centers in Botswana provide support and services for victims of gender-based violence.',
                        ),
                        Height10(),
                        BulletRow(
                          bulletColor: deepCherry,
                          text:
                              'Some private clinics and organizations also offer specialized support services. Users can inquire about these facilities locally.',
                        ),
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
                            'Gender-Based Violence Support Network (GBVSN):',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Height10(),
                          const Text(
                            'Provides counseling, support groups, and emergency assistance for individuals experiencing gender-based violence.',
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
                                      '391 8233',
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
            ),
          ),
          const Height20(),
          PrimaryPadding(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: cherry,
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
                    color: deepCherry,
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
                        'Gender-Based Violence',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      BulletRow(
                        bulletColor: cherry,
                        text:
                            'Gender-based violence can have serious physical and emotional impacts. Recognizing the signs and seeking help early can prevent further harm.',
                      ),
                      SizedBox(height: 8),
                      BulletRow(
                          bulletColor: cherry,
                          text:
                              'If you or someone you know is experiencing gender-based violence, it is crucial to contact authorities or support organizations immediately.'),
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
