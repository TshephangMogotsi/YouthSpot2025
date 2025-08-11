import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/main.dart';

import '../../../../config/font_constants.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  int step = 0;
  bool isForward = true;

  void _goToPage(int index) {
    setState(() {
      isForward = index > step;
      step = index;
    });
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
        return _buildInitialStep(context, key: const ValueKey(0));
      case 1:
        return _buildConfirmStep(context, key: const ValueKey(1));
      case 2:
        return _buildSuccessStep(context, key: const ValueKey(2));
      default:
        return Container();
    }
  }

  /// Step 1: Initial prompt
  Widget _buildInitialStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delete Profile?',
          style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your profile will be deleted in 30 days. Log in within this period to cancel the deletion. After 30 days without logging in, your profile and data will be permanently deleted.',
          style: AppTextStyles.primaryRegular,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFC5C5C5)),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.primaryBold.copyWith(
                    color: const Color(0xFF626262),
                  ),
                ),
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
                child: Text(
                  'Continue',
                  style: AppTextStyles.primaryBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Step 2: Slide-to-delete confirmation
  Widget _buildConfirmStep(BuildContext context, {Key? key}) {
    final GlobalKey<SlideActionState> _sliderKey = GlobalKey();
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Deletion',
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Slide to confirm deletion of your profile. This action will schedule your account for permanent deletion after 30 days.',
          style: AppTextStyles.primaryRegular,
        ),
        const SizedBox(height: 40),
        Builder(
          builder: (context) {
            return SlideAction(
              key: _sliderKey,
              onSubmit: () async {
                final userId = supabase.auth.currentUser?.id;
                if (userId != null) {
                  await supabase.functions.invoke('delete-user-soft', body: {'userId': userId});
                }
                await supabase.auth.signOut();
                _goToPage(2); // Go to success step
                return null;
              },
              borderRadius: 10,
              elevation: 0,
              animationDuration: const Duration(milliseconds: 700),
              innerColor: Colors.white,
              outerColor: Colors.grey.shade200,
              sliderButtonIcon: Lottie.asset(
                'assets/icon/Settings/AccountSettings/arrow.json',
                width: 25,
                repeat: true,
                reverse: false,
                animate: true,
                fit: BoxFit.cover,
              ),
              // Replace checkmark with a spinner
              submittedIcon: const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.red,
                ),
              ),
              text: 'Slide to Delete',
              textStyle: AppTextStyles.primaryBold.copyWith(color: Colors.red),
              sliderRotate: false,
            );
          },
        ),
        Height20(),
      ],
    );
  }

  /// Step 3: Success animation
  Widget _buildSuccessStep(BuildContext context, {Key? key}) {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/icon/success.json',
          width: 100,
          repeat: false,
          animate: true,
        ),
        const SizedBox(height: 16),
        Text(
          'Your account deletion is scheduled!',
          style: AppTextStyles.title.copyWith(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'You can still log in within 30 days to cancel.',
          style: AppTextStyles.primaryRegular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
