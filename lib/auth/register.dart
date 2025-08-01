import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/global_widgets/custom_textfield.dart';
import 'package:youthspot/global_widgets/full_width_dropdown.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/global_widgets/primary_container.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/screens/homepage/my_spot/goals/widgets/date_picker.dart';
import 'package:youthspot/config/theme_manager.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:youthspot/terms_and_privacy.dart';
import 'fullname_validator.dart';

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
  String? selectedSex;
  DateTime dateOfBirth = DateTime.now();
  bool? isSexSelected;

  final List<String> genderList = [
    'Male',
    'Female',
    'Non-binary',
  ];

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

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (selectedSex == null) {
      showSnackBar('Please select gender');
      setState(() {
        _isLoading = false;
      });
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Account successfully registered! Please check your email to verify your account before signing in.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 6),
          ),
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          backgroundColor:
              theme == ThemeMode.dark ? const Color(0xFF1C1C24) : kSSIorange,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/Backgrounds/register_background.png',
                    ), // Replace with your image path
                    fit: BoxFit.fitWidth, // You can adjust the fit as needed
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: backgroundColorLight,
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
                              CustomTextField(
                                title: "Full Name",
                                hintText: "Full Name",
                                controller: _fullNameController,
                                validator: FullNameValidator.validate,
                              ),
                              const Height20(),
                              CustomTextField(
                                title: "Username",
                                hintText: "Username",
                                controller: _userNameController,
                                validator: (username) {
                                  if (_userNameController.text.trim().isEmpty) {
                                    return 'Please enter username';
                                  }
                                  if (_userNameController.text.trim().length < 3) {
                                    return 'Username must be at least 3 characters';
                                  }
                                  // Check for valid username characters (alphanumeric and underscore)
                                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(_userNameController.text.trim())) {
                                    return 'Username can only contain letters, numbers, and underscores';
                                  }
                                  return null;
                                },
                              ),
                              const Height20(),
                              CustomTextField(
                                title: "Email",
                                hintText: "johndoe@mail.com",
                                controller: _emailController,
                                validator: (value) {
                                  if (!EmailValidator.validate(value!)) {
                                    return "Please enter valid email";
                                  }
                                  return null; // No error
                                },
                              ),
                              const Height20(),
                              Text('Mobile Number', style: inputTitle),
                              const Height10(),
                              IntlPhoneField(
                                controller: _mobileNumber,
                                keyboardType: TextInputType.number,
                                dropdownIconPosition: IconPosition.leading,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(mainBorderRadius)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(mainBorderRadius)),
                                    borderSide: BorderSide(
                                      width: 1.3,
                                      color: kSSIorange,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(mainBorderRadius)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                      color:
                                          kSSIorange, // Customize the color here
                                      width: 1, // Customize the width here
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                      color:
                                          pinkClr, // Customize the color here
                                      width: 1.0, // Customize the width here
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: pinkClr),
                                ),
                                initialCountryCode: 'BW',
                                onChanged: (phone) {},
                                validator: (phone) {
                                  if (phone == null ||
                                      !RegExp(r'^[0-9]+$')
                                          .hasMatch(phone.number)) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              const Height10(),
                              Text('Gender', style: inputTitle),
                              const Height20(),
                              FullWidthDropdownButton(
                                hintText: 'Select gender',
                                showError: isSexSelected != null,
                                options: genderList,
                                onOptionSelect: (option) {
                                  if (kDebugMode) {
                                    print(option);
                                  }
                                  selectedSex = option;
                                },
                              ),
                              const Height20(),
                              Text('Date of Birth', style: inputTitle),
                              const Height20(),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 1,
                                    child: PrimaryContainer(
                                      child: Icon(Icons.calendar_month),
                                    ),
                                  ),
                                  const Width20(),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryContainer(
                                          child: CustomDatePicker(
                                            initialDate: DateTime.now(),
                                            showIcon: false,
                                            isDoBField: true,
                                            labelText: 'Date of Birth',
                                            onDateSelected: (date) {
                                              setState(() {
                                                dateOfBirth = date;
                                                if (kDebugMode) {
                                                  print(dateOfBirth);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Height20(),
                              CustomTextField(
                                title: "Password",
                                hintText: "Password",
                                isPasswordField: true,
                                controller: _passwordController,
                                validator: (value) {
                                  if (_passwordController.text.trim().isEmpty) {
                                    return "Enter password";
                                  }
                                  if (_passwordController.text.trim().length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  // Add stronger password validation
                                  if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(_passwordController.text.trim())) {
                                    return 'Password must contain at least one letter and one number';
                                  }
                                  return null; // No error
                                },
                              ),
                              const Height20(),
                              CustomTextField(
                                title: "Confirm Password",
                                hintText: "Password",
                                isPasswordField: true,
                                controller: _passwordConfirmController,
                                validator: (value) {
                                  if (_passwordConfirmController.text.trim().isEmpty) {
                                    return "Please confirm your password";
                                  }
                                  if (_passwordConfirmController.text.trim() !=
                                      _passwordController.text.trim()) {
                                    return "Passwords don't match";
                                  }
                                  return null; // No error
                                },
                              ),
                              const Height20(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "By creating an account you agree to the",
                                        style: TextStyle(
                                          color: Color(0xFF263245),
                                          fontSize: 15,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
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
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: " & ",
                                                  style: TextStyle(
                                                      color: Color(0xFF263245),
                                                      fontSize: 14)),
                                              TextSpan(
                                                text: "Privacy Policy",
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const TermsPrivacyScreen(),
                                                          ),
                                                        );
                                                      },
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              PrimaryButton(
                                label: 'Create Account',
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {}
                                  signUp();
                                },
                              ),
                              const Height20(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
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
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                  color: Colors.black54, // Opaque overlay
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: kSSIorange,
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
