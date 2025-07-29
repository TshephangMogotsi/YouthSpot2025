import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../quiz_results.dart';

class IsNotCircumcised extends StatelessWidget {
  const IsNotCircumcised({
    super.key,
    required this.widget,
  });

  final QuizResults widget;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
        bgColor: const Color(0xFF1DB08F),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You answered'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    'NO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1DB08F),
                    ),
                  ),
                ),
                const Text('to:')
              ],
            ),
            const Height10(),
            const Text(
              'Are you circumcised?',
              style: TextStyle(fontSize: 16),
            ),
            const Height20(),
            Lottie.asset(
              'assets/QuizResultsAnimations/couple.json',
              width: 180,
              repeat: true,
              reverse: false,
              animate: true,
            ),
            const Height20(),
            const Text(
              "Circumcision can benefit you and your partner",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
