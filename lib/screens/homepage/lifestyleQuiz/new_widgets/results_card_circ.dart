import 'package:flutter/material.dart';

import '../quiz_logic.dart';


class ResultsCardCirc extends StatelessWidget {
  const ResultsCardCirc({
    super.key,
    required this.title,
    required this.img,
    required this.color,
    required this.borderColor,
    this.quizLogic,
    required this.message,
  });

  final String title;
  final String img;
  final String message;
  final Color color;
  final Color borderColor;
  final QuizLogic? quizLogic;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 1000,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            img,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 20,),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
