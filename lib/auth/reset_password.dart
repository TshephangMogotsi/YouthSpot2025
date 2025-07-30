import 'package:youthspot/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../global_widgets/custom_textfield.dart';
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
  String? error;

  Future<void> resetPassword() async {
    try {
      await authService.value.resetPassword(
        email: emailController.text.trim(),
      );
      setState(() {
        isSubmitted = true;
        error = null;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'An unknown error occurred';
        if (kDebugMode) print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, _) {
        return Scaffold(
          backgroundColor:
              theme == ThemeMode.dark ? const Color(0xFF1C1C24) : Colors.white,
          body: Stack(
            children: [
              Image.asset(
                'assets/Backgrounds/Reset password.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Height20(),
                    PrimaryPadding(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back, size: 28),
                            const Width10(),
                            Text(
                              'Back',
                              // style: titleStyle.copyWith(
                              //   fontSize: 22,
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isSubmitted) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "If the email exists, a password reset link has been sent to ${emailController.text.trim()}",
                          textAlign: TextAlign.center,
                          // style: titleStyle.copyWith(
                          //   fontSize: 16,
                          // ),
                        ),
                      ),
                      const Height10(),
                      PrimaryButton(
                        label: 'Back to Login',
                        customBackgroundColor: kSSIorange,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Height20(),
                    ],
                  ],
                ),
              ),
              if (!isSubmitted)
                Center(
                  child: Form(
                    key: _formKey,
                    child: PrimaryPadding(
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColorLight,
                          borderRadius: BorderRadius.circular(mainBorderRadius),
                        ),
                        child: PrimaryPadding(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Reset your password',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Height10(),
                              CustomTextField(
                                hintText: 'Email',
                                controller: emailController,
                                isOnWhiteBackground: true,
                                fillColor: Colors.grey[300],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!regex.hasMatch(value.trim())) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const Height20(),
                              if (error != null)
                                Text(
                                  error!,
                                  style: const TextStyle(
                                      color: pinkClr, fontSize: 14),
                                ),
                              const Height10(),
                              PrimaryButton(
                                label: 'Reset Password',
                                customBackgroundColor: kSSIorange,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    resetPassword();
                                  }
                                },
                              ),
                              const Height20(),
                            ],
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
}
