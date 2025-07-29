import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/primary_divider.dart';
import '../quiz_results.dart';

class HasReportedAbuse extends StatelessWidget {
  const HasReportedAbuse({
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
                    'NO',
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
              'Have you ever asked for help or reported any abuse?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Lottie.asset(
              'assets/QuizResultsAnimations/support-agent.json',
              width: 180,
              repeat: true,
              reverse: false,
              animate: true,
            ),
            const Height10(),
            const Text(
              "It's important to know that seeking help is a brave step and it's never too late to reach out for support if you need it.If you ever feel the need to seek help or report abuse in the future, contact the Botswana GBV Prevention and Support Center, details are below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const Height10(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 110),
              child: PrimaryDivider(),
            ),
            const Height10(),
            const Text(
              'Botswana GBV Prevention \nand Support Centre',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Height10(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: bluishClr,
                      ),
                      Text(
                        '74265081',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: bluishClr,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: bluishClr,
                      ),
                      Text(
                        '390 7659',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: bluishClr,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
