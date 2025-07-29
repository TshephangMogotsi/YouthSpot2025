import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../quiz_logic.dart';

class QuestionPill extends StatelessWidget {
  const QuestionPill({
    super.key,
    required this.index,
    required this.quizLogic,
    required this.selectedOptions,
    required this.isNoneSelected,
  });

  final int index;
  final QuizLogic quizLogic;
  final List<int> selectedOptions;
  final bool isNoneSelected;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isNoneSelected ? 0.4 : 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
            selectedOptions.contains(index) ? kSSIorange : Colors.transparent,
          border: Border.all(
            color: selectedOptions.contains(index) ? kSSIorange : Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          quizLogic.getAnswer(index),
        ),
      ),
    );
  }
}

class QuestionPill2 extends StatelessWidget {
  const QuestionPill2({
    super.key,
    required this.isNoneSelected,
  });

  final bool isNoneSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isNoneSelected ? kSSIorange : Colors.transparent,
        border: Border.all(
          color: isNoneSelected ? kSSIorange : Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'None',
      ),
    );
  }
}
