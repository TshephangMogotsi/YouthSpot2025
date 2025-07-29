// import 'package:flutter/material.dart';
// import 'package:youth_spot/screens/homepage/lifestyleQuiz/quiz_logic.dart';
// import 'package:youth_spot/screens/homepage/lifestyleQuiz/new_widgets/results_card_alc.dart';

// class AlcholUseStatusCard extends StatelessWidget {
//   const AlcholUseStatusCard({
//     super.key,
//     required this.quizLogic,
//   });

//   final QuizLogic quizLogic;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           // Navigator.of(context).push(_createRoute());
//         },
//         child: Padding(
//             padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
//             child: quizLogic.displayAnimation() == SectionOneResults.congrats
//                 ? const ResultsCardAlc(
//                     title: 'Alcohol and Drugs',
//                     img: 'assets/Backgrounds/alcohol_assessment_bg.png',
//                     message: 'Congratulations! You are doing well. Keep it up!',
//                     color: Color(0xFF345351),
//                     borderColor: Color(0xFF9be7e0),
//                   )
//                 : quizLogic.displayAnimation() == SectionOneResults.reduceIntake
//                     ? const ResultsCardAlc(
//                         title:
//                             'Alcohol and Drugs',
//                         message: 'onsider reducing your intake',
//                         img: 'assets/Backgrounds/alcohol_assessment_bg.png',
//                         color: Color(0xFF345351),
//                         borderColor: Color(0xFF9be7e0),
//                         requiresGoal: true,
//                       )
//                     : const ResultsCardAlc(
//                         title:'Alcohol and Drugs',
//                         message: 'Consider setting a goal to reduce intake',
//                         img: 'assets/Backgrounds/alcohol_assessment_bg.png',
//                         color: Color(0xFF345351),
//                         borderColor: Color(0xFF9be7e0),
//                         requiresGoal: true,
//                       )),
//       ),
//     );
//   }
// }
