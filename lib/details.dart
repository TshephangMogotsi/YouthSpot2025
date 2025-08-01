import 'package:flutter/material.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

class AppDescriptionScreen extends StatelessWidget {
  const AppDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: Center(
        child: PrimaryPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
        
                Text(
                  "About YouthSpot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "YouthSpot is your safe space for personal growth, emotional well-being, and mental health awareness. "
                  "Designed for young people, it offers practical tools to help you track your moods, set personal goals, "
                  "journal your thoughts, and access helpful resources – all in one supportive environment.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "Why We Built YouthSpot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Mental health is an important part of overall well-being, but many young people don’t have access to easy-to-use tools "
                  "to help them reflect, express themselves, and find helpful resources. YouthSpot was created to bridge that gap — "
                  "giving you a private, non-judgmental space to understand and take charge of your emotional health.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "What You Can Do in YouthSpot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "• **Track Your Mood** – Log your daily feelings and spot patterns over time.\n"
                  "• **Journal Your Thoughts** – Write down what’s on your mind in a safe and private space.\n"
                  "• **Set Personal Goals** – Stay motivated with small, achievable milestones.\n"
                  "• **Access Helpful Resources** – Explore tips, guides, and contacts for mental health support.\n"
                  "• **Get Motivated** – Receive uplifting quotes and reminders to stay encouraged.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "Our Promise to You",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your privacy and safety matter to us. YouthSpot is designed to keep your personal reflections and data private. "
                  "We do not sell your information, and your entries stay with you unless you choose to share them.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "A Supportive Companion – Not a Replacement for Care",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "YouthSpot is a self-help tool meant to support your mental health journey. It does not replace professional counseling, therapy, or medical care. "
                  "If you are experiencing a crisis or need urgent help, please reach out to a trusted adult, a mental health professional, or emergency services.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "Third-Party Libraries & Assets",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "YouthSpot uses trusted third-party tools and libraries to improve your experience:\n\n"
                  "• **Lottie** – For beautiful, interactive animations that make the app more engaging.\n"
                  "• **Syncfusion Calendar** – To provide a rich and interactive calendar for goal and schedule tracking.\n"
                  "• **Flaticon** – For high-quality icons that enhance the visual design and usability of the app.\n\n"
                  "We carefully select these tools to ensure they are secure, reliable, and enhance your experience.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
