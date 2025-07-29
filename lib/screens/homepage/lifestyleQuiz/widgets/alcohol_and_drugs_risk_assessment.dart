import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../quiz_logic.dart';
import '../quiz_results.dart';

class AlcoholAndDrugsAssessment extends StatelessWidget {
  const AlcoholAndDrugsAssessment({
    super.key,
    required this.widget,
  });

  final QuizResults widget;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      bgColor: pinkClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.quizLogic.displayAnimation() == SectionOneResults.congrats
              ? Lottie.asset(
                  'assets/QuizResultsAnimations/trophy.json',
                  width: 140,
                  repeat: true,
                  reverse: false,
                  animate: true,
                )
              : widget.quizLogic.displayAnimation() ==
                      SectionOneResults.reduceIntake
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Lottie.asset(
                        'assets/QuizResultsAnimations/beer-mug.json',
                        width: 140,
                        repeat: true,
                        reverse: false,
                        animate: true,
                      ),
                    )
                  : Lottie.asset(
                      'assets/QuizResultsAnimations/target.json',
                      width: 140,
                      repeat: true,
                      reverse: false,
                      animate: true,
                    ),
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.quizLogic.sectionOneResults(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
