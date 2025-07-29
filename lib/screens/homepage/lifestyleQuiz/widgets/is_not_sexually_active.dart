
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../quiz_results.dart';

class IsNotSexuallyActive extends StatelessWidget {
  const IsNotSexuallyActive({
    super.key,
    required this.widget,
  });

  final QuizResults widget;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      bgColor: yellowClr,
      child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You answered'),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: pinkClr,
                          border: Border.all(
                            color: pinkClr,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(20))),
                      child: const Text(
                        'NO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text('to:')
                  ],
                ),
                const Height10(),
                const Text(
                  'Have you ever been sexually active?',
                  style: TextStyle(fontSize: 16),
                ),
                Lottie.asset(
                  'assets/QuizResultsAnimations/mouth.json',
                  width: 180,
                  repeat: true,
                  reverse: false,
                  animate: true,
                ),
                const Text(
                  "Keep it up. You should wait until you are physically and emotionally ready to have sex. When you are ready to have sex make sure you are protected from HIV.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
    );
  }
}
