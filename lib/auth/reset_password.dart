import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/config/font_constants.dart';
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../global_widgets/field_with_live_validation.dart';
import '../global_widgets/primary_button.dart';
import '../global_widgets/primary_padding.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;
  bool isLoading = false;
  String? error;

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

    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      await auth.resetPassword(email: emailController.text.trim());
      if (!mounted) return;
      setState(() {
        isSubmitted = true;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
      });
      if (kDebugMode) print('Reset password error: $error');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Network error. Please check your internet connection and try again.';
      });
      if (kDebugMode) print('Reset password error: $e');
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
    final double panelHeight = size.height - (isSubmitted ? 0 : _collapsedTopOffset);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, _) {
        return Scaffold(
          backgroundColor: theme == ThemeMode.dark ? const Color(0xFF1C1C24) : Colors.white,
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
                  alignment: !isSubmitted ? Alignment.topCenter : null,
                  height: panelHeight.clamp(0.0, size.height),
                  width: double.infinity,
                  color: Colors.white,
                  child: SafeArea(
                    top: false, // allow panel to cover the top when expanded
                    child: PrimaryPadding(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isSubmitted ? _buildSuccessContent() : _buildFormContent(),
                      ),
                    ),
                  ),
                ),
              ),

              // Back button row (visible only pre-submit so success stays all white)
              if (!isSubmitted)
                SafeArea(
                  child: PrimaryPadding(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, size: 28, color: Colors.white),
                          const Width10(),
                          Text(
                            'Back',
                            style: AppTextStyles.primaryBold.copyWith(color: Colors.white),
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
                      color: Colors.black.withOpacity(0.15),
                      child: const Center(
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.white,
                          ),
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
                  style: AppTextStyles.primaryBigBold.copyWith(fontSize: 30, height: .8),
                ),
              ],
            ),
            const Height20(),
            Row(
              children: [
                const Width20(),
                Flexible(
                  child: Text(
                    'Enter the email address with your account and we`ll send an email link to reset your password',
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
              customBackgroundColor: kSSIorange,
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

  Widget _buildSuccessContent() {
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
                'Password Reset\nEmail has been Sent',
                textAlign: TextAlign.center,
                style: AppTextStyles.primaryBigBold.copyWith(fontSize: 30, height: 1.1),
              ),
            ],
          ),
          const Height20(),
          Row(
            children: [
              const Width20(),
              Flexible(
                child: Text(
                  'A password reset email has been sent \nto your email address',
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
            Text(
              error!,
              style: const TextStyle(color: pinkClr, fontSize: 14),
            ),
          const Height10(),
          PrimaryButton(
            label: 'Back to login',
            customBackgroundColor: Colors.black,
            onTap: () => Navigator.of(context).pop(),
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
                    style: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSubmitted = false;
                        error = null;
                      });
                    },
                    child: Text(
                      "Try another email",
                      style: AppTextStyles.primaryBold.copyWith(color: Colors.blue),
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
}