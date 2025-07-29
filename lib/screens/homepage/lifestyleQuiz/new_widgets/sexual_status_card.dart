import 'package:flutter/material.dart';

import 'results_card.dart';

class SexualStatusCard extends StatelessWidget {
  const SexualStatusCard({
    super.key,
    required this.ontap,
  });

  final VoidCallback ontap;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: ontap,
        child: const Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
          child: ResultsCard(
            title: 'Current sexual status,\nRelationships and Drugs',
            img: 'assets/Backgrounds/results_card_green.png',
            message: 'Your responses indicate a low risk in your current sexual status, relationships, and drug use. Continue to practice safe behaviors and maintain open communication with your partners. Keep up the good work in making healthy choices.',
            color: Color(0xFF345351),
            borderColor: Color(0xFF9be7e0),
          ),
        ),
      ),
    );
  }
}
