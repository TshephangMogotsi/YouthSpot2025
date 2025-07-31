import 'package:flutter/material.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

class TermsAndPrivacyPage extends StatelessWidget {
  const TermsAndPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
    child: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "YouthSpot – Terms & Privacy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Hey there! 👋 Welcome to YouthSpot!\n\n"
              "We’re super excited to have you here. Before you dive in, let’s go over a few important things. "
              "By using YouthSpot, you agree to these Terms & Conditions and our Privacy Policy. "
              "If you don’t agree, that’s totally okay — but you’ll need to stop using the app.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("1. What YouthSpot Is For",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "YouthSpot is designed to support your mental health, wellness, and personal growth.\n\n"
              "Here’s what you can do in the app:\n"
              "• Track your moods and feelings\n"
              "• Keep a personal journal\n"
              "• Set goals and check your progress\n"
              "• Access motivational tips, articles, and other helpful tools\n\n"
              "But here’s the important part:\n"
              "YouthSpot is not a substitute for professional help. We don’t provide medical, psychological, or emergency services. "
              "If you ever feel unsafe, overwhelmed, or in crisis:\n"
              "• Talk to a trusted adult,\n"
              "• Call a mental health helpline, or\n"
              "• Go to your nearest emergency service.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("2. Who Can Use YouthSpot",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "• You must be at least 13 years old to use this app.\n"
              "• If you’re under 18, make sure you have permission from a parent or guardian.\n\n"
              "If we find out someone is using the app who doesn’t meet these requirements, we may have to deactivate their account for safety reasons.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("3. Be Cool & Respectful",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We want YouthSpot to stay a safe and positive space. Here’s what that means:\n"
              "• No bullying, harassment, or hate speech.\n"
              "• No illegal content or sharing harmful material.\n"
              "• Don’t misuse the app — no hacking, spamming, or trying to break it.\n\n"
              "If we notice any harmful or unsafe behavior, we may take action, including removing content or suspending accounts.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("4. Your Privacy – What We Do With Your Info",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We care about your privacy. Here’s how we handle your data:\n"
              "• Personal data: We may collect basic info like your username, email, or preferences so the app works properly.\n"
              "• Wellness data: Your mood tracker, journal entries, and goals are stored securely. Most of these stay private to you and are not shared unless you choose to share them.\n"
              "• Analytics: We may collect anonymous data to improve the app (like which features are most used).\n\n"
              "We don’t sell your data. Your information will never be sold to advertisers or third parties.\n\n"
              "If the law requires us to share information (for example, if someone is in serious danger), we may have to cooperate with authorities — but that’s only in extreme cases.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("5. Keeping Your Account Safe",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "• Don’t share your password with anyone.\n"
              "• If you notice strange activity on your account, let us know right away.\n"
              "• We can’t be responsible for what happens if you share your account with others.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("6. Updates & Changes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Sometimes, we’ll update these Terms or Privacy Policy to keep YouthSpot safe and running smoothly. "
              "When that happens, we’ll let you know in the app. By continuing to use YouthSpot after changes, you agree to the new terms.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text("7. Contact Us",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Got questions? Concerns? Ideas?\nReach out to us anytime at support@youthspot.app (replace with your actual contact email).",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text(
              "In short: YouthSpot is here to help you grow and take care of yourself, "
              "but it’s not a replacement for real-world help. Stay safe, be kind, and use the app responsibly.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
