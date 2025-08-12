import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/auth/widget/custom_phone_field2.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/config/font_constants.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/global_widgets/primary_container.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/field_with_live_validation.dart';
import 'package:youthspot/config/theme_manager.dart';
import 'package:youthspot/screens/homepage/my_spot/goals/widgets/date_picker_2.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:youthspot/terms_and_privacy.dart';
import 'package:youthspot/screens/onboarding/welcome_screen.dart';
import 'fullname_validator.dart';
import 'widget/custom_phone_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _mobileNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _genderError = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? selectedSex;
  DateTime dateOfBirth = DateTime.now();
  bool _agreedToTerms = false;

  // Live validation error state for each field
  String? _fullNameError;
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _mobileNumberError;

  final List<String> genderList = ['Male', 'Female', 'Non-binary'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _mobileNumber.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    // validate each field manually
    final fullNameError = _validateFullName(_fullNameController.text);
    final usernameError = _validateUsername(_userNameController.text);
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError = _validateConfirmPassword(
      _passwordConfirmController.text,
    );
    final mobileNumberError = _validateMobileNumber(_mobileNumber.text);

    setState(() {
      _fullNameError = fullNameError;
      _usernameError = usernameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmPasswordError;
      _mobileNumberError = mobileNumberError;
      _genderError = selectedSex == null;
    });

    if (fullNameError != null ||
        usernameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        mobileNumberError != null ||
        selectedSex == null) {
      setState(() {
        _isLoading = false;
      });
      if (selectedSex == null) {
        showSnackBar('Please select gender');
      }
      return;
    }

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.createAccount(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        gender: selectedSex!.trim(),
        dateOfBirth: DateFormat('dd/MM/yyyy').format(dateOfBirth).toString(),
        mobileNumber: _mobileNumber.text.trim(),
        username: _userNameController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } on AuthException catch (e) {
      showSnackBar(e.message);
    } catch (e) {
      showSnackBar('An unexpected error occurred. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
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
                      'assets/Backgrounds/register_background.png',
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  // No autovalidateMode!
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 250),
                      Container(
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
                                        'Go Ahead and set up',
                                        style: AppTextStyles.primaryBigBold
                                            .copyWith(fontSize: 30, height: .8),
                                      ),
                                      Text(
                                        'your account',
                                        style: AppTextStyles.primaryBigBold
                                            .copyWith(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Height20(),

                              FieldWithLiveValidation(
                                title: "Full Name",
                                hintText: "Full Name",
                                controller: _fullNameController,
                                errorText: _fullNameError,
                                onChanged: (value) => setState(() {
                                  _fullNameError = _validateFullName(value);
                                }),
                                validator: _validateFullName,
                              ),
                              const Height20(),
                              FieldWithLiveValidation(
                                title: "Username",
                                hintText: "Username",
                                controller: _userNameController,
                                errorText: _usernameError,
                                onChanged: (value) => setState(() {
                                  _usernameError = _validateUsername(value);
                                }),
                                validator: _validateUsername,
                              ),
                              const Height20(),
                              FieldWithLiveValidation(
                                title: "Email",
                                hintText: "johndoe@mail.com",
                                controller: _emailController,
                                errorText: _emailError,
                                onChanged: (value) => setState(() {
                                  _emailError = _validateEmail(value);
                                }),
                                validator: _validateEmail,
                              ),
                              const Height20(),
                              RegisterPhoneField(
                                title: 'Mobile Number',
                                controller: _mobileNumber,
                                errorText: _mobileNumberError,
                                onChanged: (val) => setState(() {
                                  _mobileNumberError = _validateMobileNumber(
                                    val,
                                  );
                                }),
                                initialCountryCode:
                                    "BW", // or whatever you want as default
                              ),

                              const Height20(),

                              Row(
                                children: [
                                  // Gender Dropdown
                                  Expanded(
                                    child: DropdownWithLiveValidation(
                                      title: "Gender",
                                      hintText: "Select Gender",
                                      value: selectedSex,
                                      items: genderList,
                                      errorText: _genderError
                                          ? "Please select gender"
                                          : null,
                                      onChanged: (val) {
                                        setState(() {
                                          selectedSex = val;
                                          _genderError = false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Date of Birth Picker
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Width20(),
                                            const Text(
                                              "Date of Birth",
                                              style: AppTextStyles.primaryBold,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        CustomDatePicker2(
                                          labelText: "Date of Birth",
                                          initialDate: dateOfBirth,
                                          isDoBField: true,
                                          onDateSelected: (date) {
                                            setState(() {
                                              dateOfBirth = date;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Height20(),
                              FieldWithLiveValidation(
                                title: "Password",
                                hintText: "Enter Password",
                                controller: _passwordController,
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
                              const Height20(),
                              FieldWithLiveValidation(
                                title: "Confirm Password",
                                hintText: "Re-Enter your password",
                                controller: _passwordConfirmController,
                                errorText: _confirmPasswordError,
                                isPassword: _obscureConfirmPassword,
                                trailingIcon: _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onTrailingPressed: () {
                                  setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  );
                                },
                                onChanged: (value) => setState(() {
                                  _confirmPasswordError =
                                      _validateConfirmPassword(value);
                                }),
                                validator: _validateConfirmPassword,
                              ),
                              const Height20(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _agreedToTerms,
                                      onChanged: (value) {
                                        setState(() {
                                          _agreedToTerms = value ?? false;
                                        });
                                      },
                                      activeColor: kSSIorange,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _agreedToTerms = !_agreedToTerms;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12.0,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  "I have read and agree to the ",
                                              style: AppTextStyles
                                                  .primaryBold
                                                  .copyWith(
                                                    color: Colors.grey.shade700,
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text: "Terms of Use",
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TermsPrivacyScreen(),
                                                        ),
                                                      );
                                                    },
                                                  style: AppTextStyles
                                                      .primaryBold
                                                      .copyWith(
                                                        color: Colors.blue,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: " and ",
                                                  style: AppTextStyles
                                                      .primaryBold
                                                      .copyWith(
                                                        color: Colors.grey.shade700,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: "Privacy Policy",
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TermsPrivacyScreen(),
                                                        ),
                                                      );
                                                    },
                                                  style: AppTextStyles
                                                      .primaryBold
                                                      .copyWith(
                                                        color: Colors.blue,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Height20(),
                              PrimaryButton(
                                label: 'Create Account',
                                onTap: () {
                                  signUp();
                                },
                              ),
                              const Height20(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                    "Already have an account?",
                                              style: AppTextStyles.primaryBold.copyWith(color: Colors.grey),
                                    
                                  ),
                                  const Width10(),
                                  InkWell(
                                    onTap: widget.onToggle,
                                    child:  Text(
                                      "Sign In",
                                      style: AppTextStyles.primaryBold.copyWith(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              const Height20(),
                              const Height20(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

  String? _validateFullName(String? value) {
    final result = FullNameValidator.validate(value);
    if (result != null) return result;
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? _validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Please enter username';
    }
    if (username.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username.trim())) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
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
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(value.trim())) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please confirm your password";
    }
    if (value.trim() != _passwordController.text.trim()) {
      return "Passwords don't match";
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your phone number";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return "Please enter a valid phone number";
    }
    if (value.trim().length < 7) {
      return "Phone number too short";
    }
    return null;
  }
}
