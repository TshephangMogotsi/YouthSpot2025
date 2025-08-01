
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/font_constants.dart';

class BiometricAuthDialog extends StatelessWidget {
  const BiometricAuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biometric Authentication',
            style: AppTextStyles.title.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'To further enhance security of your account you can use your device’s biometric security features such as FaceID, Face Unlock or Fingerprint login. You will be prompted for biometric authentication everytime you open the app.',
            style: AppTextStyles.secondaryRegular,
          ),
        
          Center(
            child: Lottie.asset(
              'assets/icon/Settings/AccountSettings/fingerprint.json',
              height: 160,
              frameRate: FrameRate.max,
              repeat: true,
              reverse: false,
              animate: true,
              fit: BoxFit.cover,
            ),
          ),
          BiometricAuthToggle(
            title: 'Enabled',
            initialValue: false,
            onChanged: (value) {
              // Handle toggle change
            },
          ),
        ],
      ),
    );
  }
}


class BiometricAuthToggle extends StatefulWidget {
  const BiometricAuthToggle({
    super.key,
    required this.title,
    this.initialValue = false,
    this.onChanged,
  });

  final String title;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  @override
  State<BiometricAuthToggle> createState() => _BiometricAuthToggleState();
}

class _BiometricAuthToggleState extends State<BiometricAuthToggle> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFEAEAEA),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section (icon + title)
          Row(
            children: [
              // Image.asset(
              //   'assets/icon/Settings/DayIcon.png',
              //   width: 40,
              //   height: 40,
              // ),
              // const SizedBox(width: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Onest',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Right section (custom toggle)
          GestureDetector(
            onTap: () {
              setState(() => isOn = !isOn);
              if (widget.onChanged != null) widget.onChanged!(isOn);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: 60,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isOn ? Colors.yellow : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastEaseInToSlowEaseOut,
                alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
