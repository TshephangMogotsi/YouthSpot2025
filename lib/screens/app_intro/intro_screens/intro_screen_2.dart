import 'package:flutter/material.dart';
import 'package:youth_spot/config/constants.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
  

    return Container(
      color: Colors.transparent,
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
                color: const Color.fromARGB(255, 255, 255, 255), // Blue border color
                width: 4, // Border width
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // Slightly smaller radius to avoid clipping the border
              child: Image.asset(
                "assets/Backgrounds/Welcome screen 2 - light.jpg",
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
              "Private & Secure Social Interactions",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                color: white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}