import 'package:flutter/material.dart';

import '../quiz_logic.dart';
import 'results_card_circ.dart';

class CircumcisionStatusCard extends StatelessWidget {
  const CircumcisionStatusCard({
    super.key,
    required this.quizLogic,
  });

  final QuizLogic quizLogic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(_createRoute());
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
          child: quizLogic.isCircumcised
              ? ResultsCardCirc(
                  message: 'Congratulations! Keep taking care and use a condom',
                  quizLogic: quizLogic,
                  title: 'Circumcision',
                  img: 'assets/Backgrounds/results_card_yellow.png',
                  color: const Color(0xFF7a561f),
                  borderColor: const Color(0xFFf6e59c),
                )
              : ResultsCardCirc(
                  message: 'Circumcision can benefit you and your partner',
                  quizLogic: quizLogic,
                  title: 'Circumcision',
                  img: 'assets/Backgrounds/results_card_yellow.png',
                  color: const Color(0xFF7a561f),
                  borderColor: const Color(0xFFf6e59c),
                ),
        ),
      ),
    );
  }
}
