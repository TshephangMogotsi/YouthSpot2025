import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../global_widgets/primary_button.dart';
import '../../../global_widgets/primary_padding.dart';
import 'actual_quiz.dart';

class LifestyleQuiz extends StatefulWidget {
  const LifestyleQuiz({super.key});

  @override
  State<LifestyleQuiz> createState() => _LifestyleQuizState();
}

class _LifestyleQuizState extends State<LifestyleQuiz> {
  late PageController _pageController;

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 1.0);
    _pageController.addListener(() {
      setState(() {
        currentPageIndex = _pageController.page!.round();
      });
    });
  }

  final images = [
    'assets/Backgrounds/QuizWelcome.png',
    'assets/Backgrounds/QuizBrain.png',
    'assets/Backgrounds/QuizDefense.png',
  ];

  final List<String> pageTexts = [
    "Hi, Welcome to\nthe Lifestyle Quiz",
    "Discover yourself\nthrough a quiz and\ngoal-setting exercise\nto enhance\nyour lifestyle",
    "Remember, your\nprivacy is important\nto us. We will never\nshare your information\nwith anyone",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bottom layer with background color
        const Scaffold(
          backgroundColor: Color(0xFF8697FC),
        ),
        // Top layer with SafeArea and content
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent, // Keep it transparent to show the underlying Scaffold
            body: Stack(
              children: [
                // PageView for background images and texts
                PageView.builder(
                  itemCount: images.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        // Background image
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Centered text
                        Center(
                          child: Text(
                            pageTexts[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Overlay content (back button and "Get Started" button)
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    PrimaryPadding(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Color(0xFF333E80),
                                          foregroundColor: Color(0xFFFFFFFF),
                                          child: Icon(Icons.arrow_back),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      Text(
                                        'Back',
                                        style: titleStyle.copyWith(
                                            color: const Color(0xFF333E80),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                    const Spacer(),
                    PrimaryPadding(
                      child: PrimaryButton(
                        customBackgroundColor: const Color(0xFF333E80),
                        label: 'Get Started',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ActualQuiz(),
                            ),
                          );
                        },
                      ),
                    ),
                    const Height20(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
