import 'package:flutter/material.dart';

import '../quiz_logic.dart';
import 'results_card.dart';

class GenderBasedViolenceStatusCard extends StatelessWidget {
  const GenderBasedViolenceStatusCard({
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
        child: const Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
          child: ResultsCard(
            // quizLogic: quizLogic,
            title: 'Gender Based Violence',
            img: 'assets/Backgrounds/results_card_red.png',
            message: 'Your answers suggest a moderate risk of experiencing gender-based violence. Consider seeking support and resources to ensure your safety and well-being.',
            color: Color(0xFF7d3d38),
            borderColor: Color.fromARGB(255, 255, 175, 168),
          ),
        ),
      ),
    );
  }
}