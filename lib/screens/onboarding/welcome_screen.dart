import 'package:flutter/material.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/navigation_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Backgrounds/register_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Welcome text
                const Text(
                  'Welcome to\nYouthSpot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Onest',
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Your journey to better health and wellness starts now!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Onest',
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // Begin button
                PrimaryButton(
                  label: 'Begin',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AppNavigationLayout(),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}