import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../global_widgets/primary_button.dart';
import '../../../global_widgets/primary_padding.dart';
import '../../../global_widgets/primary_scaffold.dart';
import 'quiz_logic.dart';
import 'quizzz_results.dart';

class QuizComplete extends StatefulWidget {
  const QuizComplete({super.key, required this.quizLogic});

  final QuizLogic quizLogic;

  @override
  State<QuizComplete> createState() => _QuizCompleteState();
}

class _QuizCompleteState extends State<QuizComplete> {
  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: PrimaryPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quiz Complete",
              style: headingStyle,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thank you for completing the Lifestyle Quiz. You can now view your results and see how you can improve your lifestyle.",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                const Height20(),
                PrimaryButton(
                  label: 'View Results',
                  customBackgroundColor: kSSIorange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const QuizzzResults()),
                    );
                  },
                ),
                const Height20(),
                const Height20(),
                const Height20(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
