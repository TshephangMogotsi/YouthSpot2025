import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int totalReminders;
  final int elapsedReminders;

  const ProgressIndicatorWidget({
    super.key,
    required this.totalReminders,
    required this.elapsedReminders,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalReminders, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 10,
            color: index < elapsedReminders ? Colors.green : Colors.grey,
          ),
        );
      }),
    );
  }
}