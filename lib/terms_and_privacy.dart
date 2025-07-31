import 'package:flutter/material.dart';
import 'package:youthspot/global_widgets/primary_container.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

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
                // You may want to wrap this in a GestureDetector for navigation!
             
                Text(
                  "Youth Spot – Terms & Privacy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "Welcome to YouthSpot!\n\n"
                  "Before using our app, please read these Terms of Service and Privacy Policy carefully. By accessing or using YouthSpot, you agree to abide by these terms and our practices for safeguarding your personal information.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "1. What This App Is For",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "YouthSpot is designed to help you track your mood, journal your thoughts, and access tips for personal growth and mental health. It is not a replacement for professional medical advice, diagnosis, or treatment. If you are in crisis or need emergency help, contact a trusted adult, helpline, or emergency services immediately.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "2. Who Can Use YouthSpot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "• You must be at least 13 years old to use YouthSpot.\n"
                  "• If you are under 18, please obtain permission from your parent or guardian.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "3. Be Cool & Respectful",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Please use YouthSpot responsibly and respectfully:\n"
                  "• Do not post or share any content that is illegal, abusive, threatening, or harmful.\n"
                  "• Respect other users in any community features.\n"
                  "• Do not attempt to hack, disrupt, or misuse the app.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "4. Privacy Policy – How We Use Your Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "We value your privacy. Here’s how we handle your information:\n\n"
                  "• **Information We Collect**: When you sign up, we may collect basic information such as your name, email address, phone number, and age. We also collect information you enter into the app, such as mood logs, journal entries, and feedback.\n\n"
                  "• **How We Use Your Information**: We use your data to provide app features, personalize your experience, and improve YouthSpot. Your information will not be sold or shared with third parties except as required by law, or if you give us explicit permission.\n\n"
                  "• **Data Storage**: Your data is securely stored using industry-standard practices. We take reasonable measures to protect your information against unauthorized access or loss. However, no online service is completely secure, so please use the app wisely.\n\n"
                  "• **Parental Rights**: If you are a parent or guardian and believe your child has provided us with personal information without your consent, please contact us to have the information removed.\n\n"
                  "• **Cookies & Tracking**: We may use cookies or similar technologies to understand how you use YouthSpot and improve your experience. You can disable cookies in your device settings, but some features may not work properly.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "5. Data Retention & Deletion",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "We retain your data while your account is active. If you delete your account, your personal data and entries will be permanently removed from our systems within a reasonable timeframe.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "6. Your Rights",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "You have the right to access, update, or delete your data at any time. If you wish to exercise these rights, please contact our support team.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "7. Changes to These Terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "We may update these terms and privacy policy from time to time. We will notify you of significant changes within the app. Continued use of YouthSpot after changes means you accept the updated terms.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text(
                  "8. Contact Us",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "If you have any questions about these Terms or our Privacy Policy, feel free to reach out via the app’s support section or email us at privacy@youthspot.app.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 24),
                Text(
                  "By tapping 'Accept' in the app, you confirm that you have read, understood, and agreed to these Terms of Service and Privacy Policy.",
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
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