
import 'package:flutter/material.dart';

import '../../../../global_widgets/primary_padding.dart';
import '../quiz_logic.dart';

class ResultsCardAlc extends StatelessWidget {
  const ResultsCardAlc({
    super.key,
    required this.title,
    required this.img,
    required this.color,
    required this.borderColor,
    this.quizLogic,
    required this.message,
    this.requiresAction,
    required this.heading,
    required this.trailingMessage,
    this.actionTap,
    this.actionRadius = 20,
    this.actionIcon = const Icon(Icons.expand_more),
    this.actionTitle = 'View More',
    required this.rating,
    this.headlineWidget,
  });

  final String title;
  final String heading;
  final String trailingMessage;
  final String rating;

  final String img;
  final String message;
  final Color color;
  final Color borderColor;
  final QuizLogic? quizLogic;

  final String actionTitle;
  final double? actionRadius;

  final bool? requiresAction;
  final VoidCallback? actionTap;
  final Icon? actionIcon;
  final Widget? headlineWidget;

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          headlineWidget ?? Container(),
          const SizedBox(height: 20,),
          PrimaryPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10,),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Text(
                        trailingMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          requiresAction == true
              ? Column(
                  children: [
                    Text(
                      actionTitle,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: actionTap,
                      child: CircleAvatar(
                        radius: actionRadius,
                        child: actionIcon,
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                )
              : const SizedBox(
                  height: 40,
                )
        ],
      ),
    );
  }
}