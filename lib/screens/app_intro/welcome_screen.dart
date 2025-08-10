import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youth_spot/screens/app_entry.dart';
import 'package:youth_spot/screens/app_intro/intro_screens/intro_screen_1.dart';
import 'package:youth_spot/screens/app_intro/intro_screens/intro_screen_2.dart';
import 'package:youth_spot/screens/app_intro/intro_screens/intro_screen_3.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int currentPageIndex = 0;
  Color backgroundColor = const Color(0xFF96B9FF); // Initial background color

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPageIndex = _controller.page!.round();
        // Update the background color based on the current index
        backgroundColor = _getBackgroundColor(currentPageIndex);
      });
    });
  }

  Color _getBackgroundColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF0A369D);
      case 1:
        return const Color(0xFF06402b);
      case 2:
        return const Color(0xFF2708A0);
      default:
        return Colors.white; // Default background color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration:
                const Duration(milliseconds: 500), // Duration for fade-in/out
            color: backgroundColor, // Set the background color here
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                  backgroundColor = _getBackgroundColor(currentPageIndex);
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const IntroScreen1();
                  case 1:
                    return const IntroScreen2();
                  case 2:
                    return const IntroScreen3();
                  default:
                    return Container(); // You can return an empty container for other indices
                }
              },
            ),
          ),
          Positioned(
            bottom: 50, // Adjust the value to lower the position
            left: 0,
            right: 0,
            child: Container(
              alignment: const Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                  ),
                  InkWell(
                    onTap: () {
                      currentPageIndex == 2
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppEntry(),
                              ),
                            )
                          : _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                    },
                    child: Text(
                      currentPageIndex == 2 ? 'Done' : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}