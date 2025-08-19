import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/auth/auth_diagnostics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/config/font_constants.dart';
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../global_widgets/field_with_live_validation.dart';
import '../global_widgets/primary_button.dart';
import '../global_widgets/primary_padding.dart';

enum ResetPasswordState {
  emailEntry,
  emailSent,
  tokenEntry,
  newPasswordForm,
  resetComplete,
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _tokenFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // Flow states
  bool isSubmitted = false;
  bool isLoading = false;
  String? error;

  // New states for token-based flow
  ResetPasswordState currentState = ResetPasswordState.emailEntry;

  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  // How far from the top the panel should start BEFORE submit
  static const double _collapsedTopOffset = 250;

  Future<void> resetPassword() async {
    // Use a null-safe validate guard
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    // Run diagnostics in release mode to help debug issues
    if (kReleaseMode) {
      final diagnostics = await AuthDiagnostics.checkSupabaseConnection();
      AuthDiagnostics.printDiagnostics(diagnostics);
      
      if (diagnostics['supabase_reachable'] != true) {
        setState(() {
          error = 'Unable to connect to authentication service. Please check your internet connection.';
          isLoading = false;
        });
        return;
      }
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      // Use diagnostics for detailed logging in release mode
      if (kReleaseMode) {
        final testResult = await AuthDiagnostics.testPasswordReset(emailController.text.trim());
        AuthDiagnostics.printDiagnostics(testResult);
        
        if (!testResult['success']) {
          throw AuthException(testResult['error'] ?? 'Password reset failed');
        }
      } else {
        // Use normal auth service in debug mode
        await auth.resetPassword(email: emailController.text.trim());
      }
      
      if (!mounted) return;
      setState(() {
        currentState = ResetPasswordState.emailSent;
        isSubmitted = true;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
      });
      debugPrint('YouthSpot: Reset password error: $error');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error =
            'Network error. Please check your internet connection and try again.';
      });
      debugPrint('YouthSpot: Reset password error: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyToken() async {
    final isValid = _tokenFormKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      await auth.verifyResetToken(
        email: emailController.text.trim(),
        token: tokenController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        currentState = ResetPasswordState.newPasswordForm;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
      });
      if (kDebugMode) print('Token verification error: $error');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error =
            'Network error. Please check your internet connection and try again.';
      });
      if (kDebugMode) print('Token verification error: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePassword() async {
    // First validate the form including password matching
    final isValid = _tokenFormKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Additional password validation before consuming the token
    if (newPasswordController.text.trim().isEmpty) {
      setState(() {
        error = 'Password is required';
      });
      return;
    }

    if (newPasswordController.text.length < 6) {
      setState(() {
        error = 'Password must be at least 6 characters long';
      });
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        error = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      // Only after password validation succeeds, verify token and update password
      await auth.updatePasswordWithToken(
        email: emailController.text.trim(),
        token: tokenController.text.trim(),
        newPassword: newPasswordController.text,
      );
      if (!mounted) return;
      setState(() {
        currentState = ResetPasswordState.resetComplete;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
      });
      if (kDebugMode) print('Password update error: $error');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error =
            'Network error. Please check your internet connection and try again.';
      });
      if (kDebugMode) print('Password update error: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    final size = MediaQuery.of(context).size;

    // Panel height is full height minus the top offset (0 after submit -> full screen)
    final double panelHeight =
        size.height -
        (currentState == ResetPasswordState.emailEntry
            ? _collapsedTopOffset
            : 0);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, _) {
        return Scaffold(
          backgroundColor: theme == ThemeMode.dark
              ? const Color(0xFF1C1C24)
              : Colors.white,
          body: Stack(
            children: [
              // Background image (visible only before submit above the panel)
              Positioned.fill(
                child: Image.asset(
                  'assets/Backgrounds/login_background.png',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),

              // White panel that grows upward to full screen on success
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  // Your tweak: keep content at top before submit
                  alignment: currentState == ResetPasswordState.emailEntry
                      ? Alignment.topCenter
                      : null,
                  height: panelHeight.clamp(0.0, size.height),
                  width: double.infinity,
                  color: Colors.white,
                  child: SafeArea(
                    top: false, // allow panel to cover the top when expanded
                    child: PrimaryPadding(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _buildCurrentContent(),
                      ),
                    ),
                  ),
                ),
              ),

              // Back button row (visible only pre-submit so success stays all white)
              if (currentState == ResetPasswordState.emailEntry)
                SafeArea(
                  child: PrimaryPadding(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: Colors.white,
                          ),
                          const Width10(),
                          Text(
                            'Back',
                            style: AppTextStyles.primaryBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Loading overlay: dim background + centered circular progress + input blocker
              if (isLoading)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentContent() {
    switch (currentState) {
      case ResetPasswordState.emailEntry:
        return _buildFormContent();
      case ResetPasswordState.emailSent:
        return _buildEmailSentContent();
      case ResetPasswordState.tokenEntry:
        return _buildTokenEntryContent();
      case ResetPasswordState.newPasswordForm:
        // This state is now handled by tokenEntry, but keep for backward compatibility
        return _buildTokenEntryContent();
      case ResetPasswordState.resetComplete:
        return _buildResetCompleteContent();
    }
  }

  // Form content wrapped in a Form with the key
  Widget _buildFormContent() {
    // Keep a small spacer so content sits ~20–30px from the top of the sheet.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const Width20(),
                Text(
                  'Reset password',
                  style: AppTextStyles.primaryBigBold.copyWith(
                    fontSize: 30,
                    height: .8,
                  ),
                ),
              ],
            ),
            const Height20(),
            Row(
              children: [
                const Width20(),
                Flexible(
                  child: Text(
                    'Enter the email address with your account and we`ll send a reset token to your email',
                    style: AppTextStyles.primarySemiBold.copyWith(
                      height: 1.2,
                      color: const Color(0xFF454545),
                    ),
                  ),
                ),
              ],
            ),
            const Height20(),
            FieldWithLiveValidation(
              leadingAsset: 'assets/icon/mail.png',
              title: "Email",
              hintText: "johndoe@mail.com",
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!regex.hasMatch(value.trim())) return 'Enter a valid email';
                return null;
              },
            ),
            const Height20(),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: pinkClr, fontSize: 14),
              ),
            const Height10(),
            PrimaryButton(
              label: 'Reset Password',
              customBackgroundColor: Colors.black,
              onTap: () async {
                final isValid = _formKey.currentState?.validate() ?? false;
                if (isValid) {
                  await resetPassword();
                }
              },
            ),
            const Height20(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSentContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Height20(),
          const Height20(),
          const SizedBox(height: 10),
          Lottie.asset(
            'assets/icon/Settings/email.json',
            width: 180,
            repeat: true,
            reverse: false,
            animate: true,
            fit: BoxFit.contain,
          ),
          Row(
            children: [
              const Width20(),
              Text(
                'Password Reset\nToken has been Sent',
                textAlign: TextAlign.center,
                style: AppTextStyles.primaryBigBold.copyWith(
                  fontSize: 30,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const Height20(),
          Row(
            children: [
              const Width20(),
              Flexible(
                child: Text(
                  'A password reset token has been sent \nto your email address',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.primaryBigSemiBold.copyWith(
                    height: 1.2,
                    color: const Color(0x95454545),
                  ),
                ),
              ),
            ],
          ),
          const Height20(),
          if (error != null)
            Text(error!, style: const TextStyle(color: pinkClr, fontSize: 14)),
          const Height10(),
          PrimaryButton(
            label: 'Proceed',
            customBackgroundColor: Colors.black,
            onTap: () {
              setState(() {
                currentState = ResetPasswordState.tokenEntry;
                error = null;
              });
            },
          ),
          const Height20(),
          Column(
            children: [
              Text(
                "Did not get your email? Check your",
                style: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
              ),
              const Width10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "spam folder or ",
                    style: AppTextStyles.primaryBold.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        currentState = ResetPasswordState.emailEntry;
                        error = null;
                      });
                    },
                    child: Text(
                      "Try another email",
                      style: AppTextStyles.primaryBold.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Height20(),
        ],
      ),
    );
  }

  Widget _buildTokenEntryContent() {
    return Form(
      key: _tokenFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const Width20(),
                Text(
                  'Reset Your Password',
                  style: AppTextStyles.primaryBigBold.copyWith(
                    fontSize: 30,
                    height: .8,
                  ),
                ),
              ],
            ),
            const Height20(),
            Row(
              children: [
                const Width20(),
                Flexible(
                  child: Text(
                    'Enter the reset token and your new password',
                    style: AppTextStyles.primarySemiBold.copyWith(
                      height: 1.2,
                      color: const Color(0xFF454545),
                    ),
                  ),
                ),
              ],
            ),
            const Height20(),
            FieldWithLiveValidation(
              leadingAsset: 'assets/icon/Calendar.png',
              title: "Reset Token",
              hintText: "Enter the 6-digit token",
              controller: tokenController,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Token is required';
                if (value.trim().length < 6)
                  return 'Token must be at least 6 characters';
                return null;
              },
            ),
            const Height20(),
            FieldWithLiveValidation(
              leadingAsset: 'assets/image_assets/Padlock.png',
              title: "New Password",
              hintText: "Enter new password",
              controller: newPasswordController,
              isPassword: !_newPasswordVisible,
              trailingIcon: _newPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              onTrailingPressed: () {
                setState(() {
                  _newPasswordVisible = !_newPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password is required';
                if (value.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const Height20(),
            FieldWithLiveValidation(
              leadingAsset: 'assets/image_assets/Padlock.png',
              title: "Confirm Password",
              hintText: "Confirm new password",
              controller: confirmPasswordController,
              isPassword: !_confirmPasswordVisible,
              trailingIcon: _confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              onTrailingPressed: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password confirmation is required';
                if (value != newPasswordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),
            const Height20(),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: pinkClr, fontSize: 14),
              ),
            const Height10(),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Back',
                    customBackgroundColor: Colors.black,
                    customTextColor: Colors.white,
                    onTap: () {
                      setState(() {
                        currentState = ResetPasswordState.emailSent;
                        error = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Reset Password',
                    customBackgroundColor: Colors.black,
                    onTap: () async {
                      final isValid =
                          _tokenFormKey.currentState?.validate() ?? false;
                      if (isValid) {
                        // Skip verifyToken() and go directly to updatePassword()
                        await updatePassword();
                      }
                    },
                  ),
                ),
              ],
            ),
            const Height20(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordContent() {
    return Form(
      key: _passwordFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const Width20(),
                Text(
                  'Set New Password',
                  style: AppTextStyles.primaryBigBold.copyWith(
                    fontSize: 30,
                    height: .8,
                  ),
                ),
              ],
            ),
            const Height20(),
            Row(
              children: [
                const Width20(),
                Flexible(
                  child: Text(
                    'Enter your new password',
                    style: AppTextStyles.primarySemiBold.copyWith(
                      height: 1.2,
                      color: const Color(0xFF454545),
                    ),
                  ),
                ),
              ],
            ),
            const Height20(),
            FieldWithLiveValidation(
              leadingAsset: 'assets/image_assets/Padlock.png',
              title: "New Password",
              hintText: "Enter new password",
              controller: newPasswordController,
              isPassword: !_newPasswordVisible,
              trailingIcon: _newPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              onTrailingPressed: () {
                setState(() {
                  _newPasswordVisible = !_newPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password is required';
                if (value.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const Height20(),
            FieldWithLiveValidation(
              leadingAsset: 'assets/image_assets/Padlock.png',
              title: "Confirm Password",
              hintText: "Confirm new password",
              controller: confirmPasswordController,
              isPassword: !_confirmPasswordVisible,
              trailingIcon: _confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              onTrailingPressed: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password confirmation is required';
                if (value != newPasswordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),
            const Height20(),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: pinkClr, fontSize: 14),
              ),
            const Height10(),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Back',
                    customBackgroundColor: Colors.black,
                    customTextColor: Colors.white,
                    onTap: () {
                      setState(() {
                        currentState = ResetPasswordState.tokenEntry;
                        error = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Reset Password',
                    customBackgroundColor: Colors.black,
                    onTap: () async {
                      final isValid =
                          _passwordFormKey.currentState?.validate() ?? false;
                      if (isValid) {
                        await updatePassword();
                      }
                    },
                  ),
                ),
              ],
            ),
            const Height20(),
          ],
        ),
      ),
    );
  }

  Widget _buildResetCompleteContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Height20(),
          const Height20(),
          const SizedBox(height: 50), // Extra spacing instead of animation
          
          // Centered title without Row wrapper
          Text(
            'Password Reset\nSuccessful',
            textAlign: TextAlign.center,
            style: AppTextStyles.primaryBigBold.copyWith(
              fontSize: 30,
              height: 1.1,
            ),
          ),
          const Height20(),
          
          // Centered description without Row wrapper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Your password has been successfully reset.\nYou can now sign in with your new password.',
              textAlign: TextAlign.center,
              style: AppTextStyles.primaryBigSemiBold.copyWith(
                height: 1.2,
                color: const Color(0x95454545),
              ),
            ),
          ),
          const Height20(),
          if (error != null)
            Text(error!, style: const TextStyle(color: pinkClr, fontSize: 14)),
          const Height10(),
          PrimaryButton(
            label: 'Back to login',
            customBackgroundColor: Colors.black,
            onTap: () async {
              // Sign out the user before going back to login
              final auth = Provider.of<AuthService>(context, listen: false);
              await auth.signOut();
              if (!mounted) return;
              Navigator.of(context).pop();
            },
          ),
          const Height20(),
        ],
      ),
    );
  }
}
