import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/config/constants.dart';
import '../../../../auth/auth_switcher.dart';
import '../../../../config/font_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  String? _errorMessage;

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  int step = 0;
  bool isForward = true;
  bool _isLoading = false;

  int logoutCountdown = 5;
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();
    // Clear error message when user types
    currentPasswordController.addListener(() => _clearError());
    newPasswordController.addListener(() => _clearError());
    confirmPasswordController.addListener(() => _clearError());
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

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
    _logoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        logoutCountdown--;
      });
      if (logoutCountdown <= 0) {
        timer.cancel();

        await context.read<AuthService>().signOut();

        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthSwitcher()),
            (route) => false,
          );
        }
      }
    });
  }

  void stopLogoutCountdown() {
    _logoutTimer?.cancel();
  }

  @override
  void dispose() {
    stopLogoutCountdown();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// --- Parse and Map Supabase Errors ---
  String _parseSupabaseError(dynamic e) {
    if (e is AuthException) {
      return e.message;
    } else if (e is PostgrestException) {
      return e.message;
    } else if (e is String) {
      return e;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  String _mapFriendlyMessage(String raw) {
    if (raw.toLowerCase().contains('invalid login credentials') ||
        raw.toLowerCase().contains('password authentication failed')) {
      return 'Incorrect password. Please try again.';
    }
    if (raw.toLowerCase().contains('weak password')) {
      return 'Your new password is too weak. Please choose a stronger one.';
    }
    return 'An error occurred. Please try again.';
  }

  /// --- Step 1: Validate Current Password ---
  Future<void> _validateCurrentPassword() async {
    if (currentPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your current password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<AuthService>().reauthenticateUser(
        currentPassword: currentPasswordController.text,
      );
      _goToPage(1);
    } catch (e) {
      final friendly = _mapFriendlyMessage(_parseSupabaseError(e));
      setState(() => _errorMessage = friendly);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// --- Step 2: Change Password ---
  Future<void> _changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'New password and confirmation do not match.';
      });
      return;
    }

    if (newPasswordController.text.length < 8) {
      setState(() {
        _errorMessage = 'Your new password must be at least 8 characters long.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<AuthService>().updatePassword(
        newPassword: newPasswordController.text,
      );
      _goToPage(2);
    } catch (e) {
      final friendly = _mapFriendlyMessage(_parseSupabaseError(e));
      setState(() => _errorMessage = friendly);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  /// --- Step 1 UI: Current Password ---
  Widget _buildCurrentPasswordStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reset password',
          style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
        ),
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
          obscureText: !_currentPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Current password',
            hintStyle: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _currentPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () => setState(
                () => _currentPasswordVisible = !_currentPasswordVisible,
              ),
            ),
          ),
        ),
        if (_errorMessage != null) _buildErrorBox(),
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
                onPressed: _isLoading ? null : _validateCurrentPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4E4E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Next',
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

  /// --- Step 2 UI: New Password ---
  Widget _buildNewPasswordStep(BuildContext context, {Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set New Password',
          style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        const Text(
          'Enter and confirm your new password below.',
          style: AppTextStyles.primaryRegular,
        ),
        const SizedBox(height: 20),
        const Text('New Password', style: AppTextStyles.primaryBold),
        const SizedBox(height: 8),
        TextField(
          controller: newPasswordController,
          obscureText: !_newPasswordVisible,
          decoration: InputDecoration(
            hintText: 'New password',
            hintStyle: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _newPasswordVisible = !_newPasswordVisible),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Confirm Password', style: AppTextStyles.primaryBold),
        const SizedBox(height: 8),
        TextField(
          controller: confirmPasswordController,
          obscureText: !_confirmPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Re-enter new password',
            hintStyle: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () => setState(
                () => _confirmPasswordVisible = !_confirmPasswordVisible,
              ),
            ),
          ),
        ),
        if (_errorMessage != null) _buildErrorBox(),
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
                child: Text(
                  'Back',
                  style: AppTextStyles.primaryBold.copyWith(
                    color: const Color(0xFF626262),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4E4E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Save',
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

  Widget _buildErrorBox() {
    return Column(
      children: [
        Height20(),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _errorMessage!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// --- Step 3 UI: Success ---
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
              style: AppTextStyles.title.copyWith(color: Colors.green),
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
            fit: BoxFit.contain,
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
                      fontSize: AppTextStyles.primaryBigBold.fontSize! + 4,
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
