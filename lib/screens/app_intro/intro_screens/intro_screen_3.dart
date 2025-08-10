import 'package:flutter/material.dart';
import 'package:youth_spot/config/constants.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {


    return Container(
      color: Colors.transparent,
      child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            const SizedBox(
            height: 120,
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
                "assets/Backgrounds/Privacy.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              "Access to Free Social Workers & Social Services",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}