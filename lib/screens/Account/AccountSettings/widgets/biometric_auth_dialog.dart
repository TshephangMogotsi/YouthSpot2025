import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/font_constants.dart';

class BiometricAuthDialog extends StatefulWidget {
  const BiometricAuthDialog({super.key});

  @override
  State<BiometricAuthDialog> createState() => _BiometricAuthDialogState();
}

class _BiometricAuthDialogState extends State<BiometricAuthDialog> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isChecking = true;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (mounted) {
        setState(() {
          _isBiometricAvailable = isAvailable && canCheckBiometrics && availableBiometrics.isNotEmpty;
          _availableBiometrics = availableBiometrics;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
          _isChecking = false;
        });
      }
    }
  }

  String _getBiometricTypeText() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      return 'Iris';
    } else {
      return 'Biometric';
    }
  }

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
          
          if (_isChecking)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (!_isBiometricAvailable)
            Column(
              children: [
                const Text(
                  'Biometric authentication is not available on this device. This could be because:',
                  style: AppTextStyles.secondaryRegular,
                ),
                const SizedBox(height: 10),
                const Text(
                  '• No biometric sensors are available\n'
                  '• Biometric authentication is not set up\n'
                  '• Device security requirements are not met',
                  style: AppTextStyles.secondaryRegular,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please set up biometric authentication in your device settings to use this feature.',
                          style: AppTextStyles.secondaryRegular.copyWith(
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  'To further enhance security of your account you can use your device\'s ${_getBiometricTypeText().toLowerCase()} security feature. You will be prompted for biometric authentication everytime you open the app.',
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
                  title: 'Enable ${_getBiometricTypeText()}',
                  initialValue: false,
                  onChanged: (value) {
                    // Handle toggle change
                  },
                ),
              ],
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