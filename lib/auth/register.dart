import 'package:provider/provider.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();
  final TextEditingController controllerFullName = TextEditingController();
  final TextEditingController controllerGender = TextEditingController();
  final TextEditingController controllerDateOfBirth = TextEditingController();
  final TextEditingController controllerMobileNumber = TextEditingController();
  final TextEditingController controllerUsername = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    controllerFullName.dispose();
    controllerGender.dispose();
    controllerDateOfBirth.dispose();
    controllerMobileNumber.dispose();
    controllerUsername.dispose();
    super.dispose();
  }

  void register() async {
  final auth = Provider.of<AuthService>(context, listen: false);
  try {
    await auth.createAccount(
      email: controllerEmail.text.trim(),
      password: controllerPassword.text.trim(),
      fullName: controllerFullName.text.trim(),
      gender: controllerGender.text.trim(),
      dateOfBirth: controllerDateOfBirth.text.trim(),
      mobileNumber: controllerMobileNumber.text.trim(),
      username: controllerUsername.text.trim(),
    );
  } on AuthException catch (e) {
    setState(() {
      errorMessage = e.message;
      debugPrint(errorMessage);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Flutter Pro'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Last step!',
              style:
                  TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 32),
              const Center(child: Text('🔑', style: TextStyle(fontSize: 36))),
              const SizedBox(height: 24),

              // Username
              TextFormField(
                controller: controllerUsername,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Full Name
              TextFormField(
                controller: controllerFullName,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Gender
              TextFormField(
                controller: controllerGender,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your gender';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Date of Birth
              TextFormField(
                controller: controllerDateOfBirth,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mobile Number
              TextFormField(
                controller: controllerMobileNumber,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: controllerEmail,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
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

              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: controllerPassword,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Password', isPassword: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Minimum 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: controllerConfirmPassword,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _inputDecoration('Confirm Password', isPassword: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != controllerPassword.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register();
                    }
                  },
                  child: const Text('Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: widget.onToggle,
                  child: const Text(
                    'Already have an account? Sign in',
                    style: TextStyle(color: Colors.tealAccent),
                  ),
                ),
              ),

              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.tealAccent),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white54,
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            )
          : null,
    );
  }
}
