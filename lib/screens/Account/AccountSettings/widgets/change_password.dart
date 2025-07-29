import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async'; // <-- Add this import!
import '../../../../config/font_constants.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  int step = 0;
  bool isForward = true; // track animation direction

  int logoutCountdown = 5; // seconds until logout
  Timer? _logoutTimer;

  void _goToPage(int index) {
    setState(() {
      isForward = index > step;
      step = index;
    });
    if (index == 2) {
      startLogoutCountdown();
    } else {
      stopLogoutCountdown();
    }
  }

  void startLogoutCountdown() {
    logoutCountdown = 5;
    _logoutTimer?.cancel();
    _logoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        logoutCountdown--;
      });
      if (logoutCountdown <= 0) {
        timer.cancel();
        Navigator.pop(context);
        // Call your logout logic here
      }
    });
  }

  void stopLogoutCountdown() {
    _logoutTimer?.cancel();
  }

  @override
  void dispose() {
    stopLogoutCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      content: ClipRRect(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final isNewChild = child.key == ValueKey(step);
              if (isNewChild) {
                final offsetAnimation = Tween<Offset>(
                  begin: isForward ? const Offset(1, 0) : const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(position: offsetAnimation, child: child);
              } else {
                return FadeTransition(opacity: animation, child: child);
              }
            },
            child: _getStepWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _getStepWidget(BuildContext context) {
    switch (step) {
      case 0:
        return _buildCurrentPasswordStep(context, key: const ValueKey(0));
      case 1:
        return _buildNewPasswordStep(context, key: const ValueKey(1));
      case 2:
        return _buildCongratulationsStep(context, key: const ValueKey(2));
      default:
        return Container();
    }
  }

  // Step 1: Current password
  Widget _buildCurrentPasswordStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reset password',
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        const Text(
          'Your password will be replaced with a new one. Once set, you will be automatically logged out and asked to log in again.',
          style: AppTextStyles.primaryRegular,
        ),
        const SizedBox(height: 20),
        const Text('Enter Current Password', style: AppTextStyles.primaryBold),
        const SizedBox(height: 8),
        TextField(
          controller: currentPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '********',
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFC5C5C5),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Cancel',
                    style: AppTextStyles.primaryBold
                        .copyWith(color: const Color(0xFF626262))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _goToPage(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4E4E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Next',
                    style: AppTextStyles.primaryBold
                        .copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 2: New password & confirmation
  Widget _buildNewPasswordStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Set New Password',
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        const Text('Enter and confirm your new password below.',
            style: AppTextStyles.primaryRegular),
        const SizedBox(height: 20),
        const Text('New Password', style: AppTextStyles.primaryBold),
        const SizedBox(height: 8),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '********',
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Confirm Password', style: AppTextStyles.primaryBold),
        const SizedBox(height: 8),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '********',
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _goToPage(0),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFC5C5C5),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Back',
                    style: AppTextStyles.primaryBold
                        .copyWith(color: const Color(0xFF626262))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: handle password change logic here
                  _goToPage(2); // Go to congratulations page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4E4E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save',
                    style: AppTextStyles.primaryBold
                        .copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCongratulationsStep(BuildContext context, {Key? key}) {
    return Container(
      width: double.maxFinite,
      child: Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Congratulations!',
              style: AppTextStyles.title
                  .copyWith( color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Lottie.asset(
            'assets/icon/success.json',
            width: 60,
            repeat: false,
            reverse: false,
            animate: true,
            fit: BoxFit.contain
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'You will be logged out in ',
                    style: AppTextStyles.primaryBold,
                  ),
                  TextSpan(
                    text: '$logoutCountdown',
                    style: AppTextStyles.primaryBold.copyWith(
                      fontSize: AppTextStyles.primaryBigBold.fontSize! +
                          4, // Slightly larger
                    ),
                  ),
                  const TextSpan(
                    text: ' seconds.',
                    style: AppTextStyles.primaryBold,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
