import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';
// import '../my_spot/goals/add_goal_page.dart';
import '../../../global_widgets/pill_button.dart';
import '../../../global_widgets/primary_button.dart';
import '../../../global_widgets/primary_divider.dart';
import '../../../global_widgets/primary_padding.dart';
import '../../../global_widgets/primary_scaffold.dart';
import 'detail_widgets/alchohol_card_details.dart';
import 'detail_widgets/gbv_detials.dart';
import 'detail_widgets/health_and_relationships_card_details.dart';
import 'new_widgets/results_card_alc.dart';
import 'quiz_logic.dart';
import 'quiz_results.dart';
import 'detail_widgets/reproductive_health_card_details.dart';

class QuizzzResults extends StatelessWidget {
  const QuizzzResults({super.key});

  @override
  Widget build(BuildContext context) {
    final quizLogic = Provider.of<QuizLogic>(context);

    return PrimaryScaffold(
      child: Column(
        children: [
          PrimaryPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz Results',
                  style: headingStyle,
                ),
                PillButton(
                  title: "Retake Quiz",
                  backgroundColor: kSSIorange,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizResults(
                          quizLogic: quizLogic,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Height20(),
          const PrimaryDivider(),
          const Height20(),
          Expanded(
            child: PrimaryPadding(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8,
                        ),
                        child: ResultsCardAlc(
                          title: 'Alcohol & Drugs',
                          heading: quizLogic.getAlcoholSectionHeadline(),
                          img: 'assets/Backgrounds/alcohol_assessment_bg.png',
                          rating: quizLogic.getAlcoholSectionRiskRating(),
                          message: quizLogic.getAlcoholSectionRiskMessage(),
                          trailingMessage:
                              quizLogic.getAlcoholSectionTrailingMessage(),
                          color: const Color(0xFF6170DE),
                          borderColor: const Color(0xFF8D9AF7),
                          requiresAction: true,
                          headlineWidget: AlchoholSectionRiskRating(
                            rating: quizLogic.getAlcoholSectionRiskRating(),
                          ),
                          actionTap: () {
                            Navigator.of(context).push(
                              _createRoute(
                                const AlcoholAndDrugsDetailsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8,
                        ),
                        child: ResultsCardAlc(
                          title: 'Sexual Health & Relationships',
                          heading: quizLogic.getHealthStatusHeadline(),
                          img: 'assets/Backgrounds/results_card_green.png',
                          rating: quizLogic.getHealthStatusRiskRating(),
                          message: quizLogic.getHealthStatusRiskMessage(),
                          trailingMessage:
                              quizLogic.getHealthStatusTrailingMessage(),
                          color: const Color(0xFF5C928E),
                          borderColor: const Color(0xFF84CFC8),
                          requiresAction: true,
                          headlineWidget: AlchoholSectionRiskRating(
                            rating: quizLogic.getHealthStatusRiskRating(),
                          ),
                          actionTap: () {
                            Navigator.of(context).push(
                              _createRoute(
                                const SexualHealthDetailsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8,
                        ),
                        child: ResultsCardAlc(
                          title: 'Gender Based Violence',
                          heading: quizLogic.getGBVStatusHeadline(),
                          img: 'assets/Backgrounds/results_card_red.png',
                          rating: quizLogic.getGBVStatusRiskRating(),
                          message: quizLogic.getGBVStatusRiskMessage(),
                          trailingMessage:
                              quizLogic.getGBVStatusTrailingMessage(),
                          color: const Color(0xFFDB6B61),
                          borderColor: const Color(0xFFFFBCB6),
                          requiresAction: true,
                          headlineWidget: AlchoholSectionRiskRating(
                            rating: quizLogic.getGBVStatusRiskRating(),
                          ),
                          actionTap: () {
                            Navigator.of(context).push(
                              _createRoute(
                                const GenderBasedViolenceDetailsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8,
                        ),
                        child: ResultsCardAlc(
                          title: 'Reproductive Health',
                          heading: "Reproductive Health Status",
                          img: 'assets/Backgrounds/results_card_yellow.png',
                          rating: quizLogic.getReproductiveHealthStatus(),
                          message: quizLogic.getReproductiveHealthMessage(),
                          trailingMessage:
                              quizLogic.getReproductiveHealthTrailingMessage(),
                          color: const Color(0xFFBC9045),
                          borderColor: const Color(0xFFFAE492),
                          requiresAction:
                              quizLogic.getReproductiveHealthRequiresAction(),
                          headlineWidget: ReproductiveHealthStatus(
                            rating: quizLogic.getReproductiveHealthStatus(),
                          ),
                          actionTap: () {
                            Navigator.of(context).push(
                              _createRoute(
                                const ReproductiveHealthDetailsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Height20(),
          PrimaryPadding(
            child: PrimaryButton(
              label: 'Exit',
              onTap: () {
                Navigator.popUntil(context, (route) {
                  return route
                      .isFirst; // Or you can check route.settings.name if you use route names
                });
              },
            ),
          ),
          const Height20(),
        ],
      ),
    );
  }

  Route _createGoalRoute(Widget route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return route;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from right
        const end = Offset.zero; // End at the center
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route _createRoute(Widget route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return route;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return Stack(
          children: [
            SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0.0, -1.0),
              ).animate(animation),
              child: this,
            ),
          ],
        );
      },
    );
  }
}

class AlchoholSectionRiskRating extends StatelessWidget {
  final String rating;

  const AlchoholSectionRiskRating({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    Color getTextColor(String rating) {
      switch (rating) {
        case 'Low':
          return Colors.green;
        case 'Moderate':
          return Colors.blue;
        case 'High':
          return Colors.red;
        default:
          return Colors.white;
      }
    }

    return Column(
      children: [
        const Height20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Risk Rating',
              style: TextStyle(color: Colors.white),
            ),
            const Width10(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: StadiumBorder(),
              ),
              child: Text(
                rating,
                style: TextStyle(
                  color: getTextColor(rating),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReproductiveHealthStatus extends StatelessWidget {
  final String rating;

  const ReproductiveHealthStatus({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    Color getTextColor(String rating) {
      switch (rating) {
        case 'Circumcised':
          return Colors.green;
        case 'Uncircumcised':
          return Colors.red;
        default:
          return Colors.white;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Height20(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: StadiumBorder(),
          ),
          child: Text(
            rating,
            style: TextStyle(
              color: getTextColor(rating),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
