import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/db/app_db.dart';
import '../../../../config/font_constants.dart';

class DeleteAccountDataDialog extends StatefulWidget {
  const DeleteAccountDataDialog({super.key});

  @override
  State<DeleteAccountDataDialog> createState() =>
      _DeleteAccountDataDialogState();
}

class _DeleteAccountDataDialogState extends State<DeleteAccountDataDialog> {
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

  /// Step 1: Initial info page
  Widget _buildInitialStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delete Account Data?',
          style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        const Text(
          'All data associated with your account will be deleted apart from your account data. This includes all data stored online and in your local storage.',
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

  /// Step 2: Slide to delete
  Widget _buildConfirmStep(BuildContext context, {Key? key}) {
    final GlobalKey<SlideActionState> _sliderKey = GlobalKey();
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Data Deletion',
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Slide to confirm deletion of all your account data. This action cannot be undone.',
          style: AppTextStyles.primaryRegular,
        ),
        const SizedBox(height: 40),
        Builder(
          builder: (context) {
            return SlideAction(
              key: _sliderKey,
              onSubmit: () async {
                try {
                  await Future.delayed(const Duration(seconds: 1));
                  
                  // Delete all data from local database
                  await SSIDatabase.instance.deleteAllData();
                  
                  // Refresh the database to ensure safe operation after deletion
                  await SSIDatabase.instance.database;
                  
                  _goToPage(2); // Go to success step
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.pop(context); // Close after success animation
                } catch (e) {
                  // Handle error
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
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
                animate: true,
                fit: BoxFit.cover,
              ),
              // Replace checkmark with spinning loader
              submittedIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.red,
                ),
              ),
              text: 'Slide to Delete Data',
              textStyle: AppTextStyles.primaryBold.copyWith(color: Colors.red),
              sliderRotate: false,
            );
          },
        ),
        Height20(),
      ],
    );
  }

  /// Step 3: Success screen
  Widget _buildSuccessStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/icon/success.json',
          width: 80,
          repeat: false,
          animate: true,
        ),
        const SizedBox(height: 16),
        Text(
          'Data Deleted Successfully!',
          style: AppTextStyles.title.copyWith(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'All your stored account data has been permanently deleted.',
          style: AppTextStyles.primaryRegular,
          textAlign: TextAlign.center,
        ),
        Height20(),
      ],
    );
  }
}
