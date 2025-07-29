import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../quiz_results.dart';

class IsNotTakingMedicationRegularly extends StatelessWidget {
  const IsNotTakingMedicationRegularly({
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
                      color: bluishClr,
                      border: Border.all(
                        color: bluishClr,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
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
              'Are you taking your medication regularly as prescribed by the doctor?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Height20(),
            Lottie.asset(
              'assets/QuizResultsAnimations/risk-assessment.json',
              width: 140,
              repeat: true,
              reverse: false,
              animate: true,
            ),
            const Height10(),
            const Text(
              " Taking ART regularly will help you stay healthy and prevent HIV from spreading to others. Talk to someone at a health facility ",
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
