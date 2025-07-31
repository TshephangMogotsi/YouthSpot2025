import 'package:flutter/material.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
     child: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About YouthSpot",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "YouthSpot is your go-to space for personal growth, wellness, and mental health support. "
              "We know life can be tough, and we’re here to help you keep track of how you feel, stay motivated, and build healthy habits — all in one place!\n\n"
              "With tools like mood tracking, journaling, goal setting, and motivational tips, YouthSpot is built to give you the support you need to stay on top of your mental and emotional well-being.\n\n"
              "Important: YouthSpot does not replace therapy, medical treatment, or emergency services. If you’re in crisis or need urgent help, please reach out to a trusted adult, call a helpline, or visit your nearest emergency service.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text(
              "Our Mission",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "YouthSpot aims to empower young people by providing simple, accessible tools for mental health management and personal growth. "
              "We believe everyone deserves a safe space to reflect, plan, and grow — without judgment.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text(
              "How We Build YouthSpot",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "YouthSpot is proudly built using Flutter, allowing us to bring the app to both Android and iOS users seamlessly. "
              "We work hard to ensure your experience is smooth, fast, and reliable.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text(
              "Acknowledgments & 3rd-Party Tools",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We’d like to thank the developers and platforms that help make YouthSpot amazing:\n\n"
              "• Lottie – For beautiful and engaging animations that bring our interface to life.\n"
              "• Syncfusion – For advanced, high-quality UI components like charts and controls that make tracking and displaying your data simple and clear.\n"
              "• Flaticon – For providing the icons that give YouthSpot its modern, friendly visual style.\n\n"
              "These tools help us create a visually appealing, interactive, and meaningful experience for you!",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text(
              "Stay Connected",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Got feedback, questions, or ideas? We’d love to hear from you!\n"
              "Contact us at support@youthspot.app (replace with your actual contact email).",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
