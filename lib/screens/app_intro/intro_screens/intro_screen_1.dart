import 'package:flutter/material.dart';
import 'package:youth_spot/config/constants.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 130,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 390,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              border: Border.all(
                color: white, // Blue border color
                width: 4, // Border width
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // Slightly smaller radius to avoid clipping the border
              child: Image.asset(
                "assets/Backgrounds/Advice.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              "Free Healthy Minds Advice Tips",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}