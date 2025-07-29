import 'package:provider/provider.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../config/theme_manager.dart';
import '../../../services/services_locator.dart';
import '../global_widgets/custom_textfield.dart';
import '../global_widgets/primary_padding.dart';
import 'reset_password.dart';
import 'auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: pinkClr,
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  } finally {
    setState(() => _isLoading = false);
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
              theme == ThemeMode.dark ? const Color(0xFF1C1C24) : kSSIorange,
          body: Stack(
            children: [
              Image.asset(
                'assets/Backgrounds/login_background.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
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
                            const Height20(),
                            CustomTextField(
                              title: "Email",
                              hintText: "Enter your email",
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const Height20(),
                            CustomTextField(
                              title: "Password",
                              hintText: "Enter your password",
                              controller: passwordController,
                              isPasswordField: true,
                              // obscureText: !_isPasswordVisible,
                              // togglePassword: () {
                              //   setState(() => _isPasswordVisible = !_isPasswordVisible);
                              // },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const Height10(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ResetPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const Height20(),
                            PrimaryButton(
                              label: _isLoading ? 'Logging in...' : 'Login',
                              customBackgroundColor: kSSIorange,
                              onTap: signIn,
                            ),
                            const Height10(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Width10(),
                                InkWell(
                                  onTap: widget.onToggle,
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Height10(),
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
