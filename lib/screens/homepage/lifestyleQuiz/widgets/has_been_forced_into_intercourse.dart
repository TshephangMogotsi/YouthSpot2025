import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../quiz_results.dart';

class HasBeenForcedIntoIntercourse extends StatelessWidget {
  const HasBeenForcedIntoIntercourse({
    super.key,
    required this.widget,
  });

  final QuizResults widget;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
        borderColor: Colors.transparent,
        bgColor: bluishClr,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You answered'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    'YES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: bluishClr,
                    ),
                  ),
                ),
                const Text('to:')
              ],
            ),
            const Height10(),
            const Text(
              'Have you ever been forced to have sex by any of partner/s or anyone else?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Lottie.asset(
              'assets/QuizResultsAnimations/seek-help.json',
              width: 140,
              repeat: true,
              reverse: false,
              animate: true,
            ),
            const Height10(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'You are likely to feel better if you talk it out. You do not need to keep it in.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }
}
