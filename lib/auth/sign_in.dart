import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../config/constants.dart';
import '../config/font_constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';
import '../global_widgets/primary_padding.dart';
import '../global_widgets/field_with_live_validation.dart';
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
  bool _obscurePassword = true;

  // Live validation error state for each field
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // validate each field manually
    final emailError = _validateEmail(emailController.text);
    final passwordError = _validatePassword(passwordController.text);

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    if (emailError != null || passwordError != null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on AuthException catch (e) {
      if (mounted) {
        showSnackBar(e.message);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('An unexpected error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Scaffold(
          backgroundColor: theme == ThemeMode.dark
              ? const Color(0xFF1C1C24)
              : kSSIorange,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/Backgrounds/login_background.png',
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 250),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(34),
                            topRight: Radius.circular(34),
                          ),
                        ),
                        child: PrimaryPadding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Height20(),
                              const Height20(),
                              Row(
                                children: [
                                  Width20(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back to',
                                        style: AppTextStyles.primaryBigBold
                                            .copyWith(fontSize: 30, height: .8),
                                      ),
                                      Text(
                                        'YouthSpot',
                                        style: AppTextStyles.primaryBigBold
                                            .copyWith(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                                    
                              Height20(),
                                    
                              FieldWithLiveValidation(
                                title: "Email",
                                hintText: "johndoe@mail.com",
                                controller: emailController,
                                errorText: _emailError,
                                onChanged: (value) => setState(() {
                                  _emailError = _validateEmail(value);
                                }),
                                validator: _validateEmail,
                              ),
                              const Height20(),
                              FieldWithLiveValidation(
                                title: "Password",
                                hintText: "Enter your password",
                                controller: passwordController,
                                errorText: _passwordError,
                                isPassword: _obscurePassword,
                                trailingIcon: _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onTrailingPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                                onChanged: (value) => setState(() {
                                  _passwordError = _validatePassword(value);
                                }),
                                validator: _validatePassword,
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child:  Text(
                                      "Forgot Password?",
                                     style: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              const Height20(),
                              PrimaryButton(
                                label: _isLoading ? 'Logging in...' : 'Login',
                                onTap: signIn,
                              ),
                              const Height20(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
                                  ),
                                  const Width10(),
                                  InkWell(
                                    onTap: widget.onToggle,
                                    child: Text(
                                      "Sign Up",
                                      style: AppTextStyles.primaryBold.copyWith(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              const Height20(),
                              Divider(),
                              const Height20(),
                              Spacer(),

                              Center(
                                child: Text(
                                        "Proudly sponsored by",
                                        style: AppTextStyles.secondarySmallBold.copyWith(color: Color(0Xff99999A)),
                                      ),
                              ),

                              const Height20(),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('assets/sponsors/pepfar.png', width: 50,),
                                  Image.asset('assets/sponsors/unicef.png', width: 60,),
                                  Image.asset('assets/sponsors/usaid.jpg', width: 50,),
                                  Image.asset('assets/sponsors/stepping.png', width: 50,),
                                  Image.asset('assets/sponsors/baylor.png', width: 50,),

                                ],
                              ),
                              const Height20(),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: kSSIorange),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }
    if (!EmailValidator.validate(value.trim())) {
      return "Please enter valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter password";
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
