import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../quiz_results.dart';

class KnowsStatusOfPartners extends StatelessWidget {
  const KnowsStatusOfPartners({
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
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF1DB08F),
                      border: Border.all(
                        color: const Color(0xFF1DB08F),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    'YES',
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
              'Do you know the status of your partner(s)?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Lottie.asset(
              'assets/QuizResultsAnimations/health.json',
              width: 220,
              repeat: true,
              reverse: false,
              animate: true,
            ),
            const Text(
              "Great knowing your HIV status and your partners HIV status reduces your risk and helps you make informed choices ",
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
