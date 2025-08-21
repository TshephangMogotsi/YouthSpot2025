import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/global_widgets/primary_container.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/field_with_live_validation.dart';
import 'package:youthspot/global_widgets/initials_avatar.dart';
import 'package:youthspot/screens/homepage/my_spot/goals/widgets/date_picker_2.dart';
import 'package:youthspot/auth/widget/custom_phone_field2.dart';
import 'package:youthspot/config/font_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  bool _loading = true;
  bool _isSaving = false;
  String? selectedGender;
  DateTime dateOfBirth = DateTime.now();

  // Validation errors
  String? _fullNameError;
  String? _usernameError;
  String? _emailError;
  String? _mobileError;
  String? _genderError;

  final List<String> genderList = ['Male', 'Female', 'Non-binary'];

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _getProfile() async {
    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);

    try {
      final userId = auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in!");

      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      _fullNameController.text = response['full_name'] ?? '';
      _userNameController.text = response['username'] ?? '';
      _mobileController.text = response['mobile_number'] ?? '';
      _emailController.text = response['email'] ?? '';
      selectedGender = response['gender'] ?? '';

      String dobString = response['date_of_birth'] ?? '';
      if (dobString.isNotEmpty) {
        try {
          dateOfBirth = DateFormat('dd/MM/yyyy').parse(dobString);
        } catch (e) {
          dateOfBirth = DateTime.now();
        }
      } else {
        dateOfBirth = DateTime.now();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (_isSaving) return;
    // Run all validators
    final fullNameError = _validateFullName(_fullNameController.text);
    final usernameError = _validateUsername(_userNameController.text);
    final emailError = _validateEmail(_emailController.text);
    final mobileError = _validateMobileNumber(_mobileController.text);

    setState(() {
      _fullNameError = fullNameError;
      _usernameError = usernameError;
      _emailError = emailError;
      _mobileError = mobileError;
      _genderError = selectedGender == null ? 'Please select gender' : null;
    });

    if (fullNameError != null ||
        usernameError != null ||
        emailError != null ||
        mobileError != null ||
        selectedGender == null) {
      return;
    }

    setState(() => _isSaving = true);
    final auth = Provider.of<AuthService>(context, listen: false);

    try {
      final userId = auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");

      await Supabase.instance.client.from('profiles').update({
        'full_name': _fullNameController.text,
        'username': _userNameController.text,
        'email': _emailController.text,
        'gender': selectedGender,
        'date_of_birth': DateFormat('dd/MM/yyyy').format(dateOfBirth),
        'mobile_number': _mobileController.text,
      }).eq('id', userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // -- Validators (identical to RegisterPage) --
  String? _validateFullName(String? value) {
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

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: InitialsAvatar(
                        fullName: _fullNameController.text,
                        radius: 50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PrimaryPadding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Profile Information",
                              style: AppTextStyles.primaryBigBold.copyWith(fontSize: 26),
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
                            RegisterPhoneField(
                              title: 'Mobile Number',
                              controller: _mobileController,
                              errorText: _mobileError,
                              onChanged: (val) => setState(() {
                                _mobileError = _validateMobileNumber(val);
                              }),
                              initialCountryCode: "BW",
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownWithLiveValidation(
                                    title: "Gender",
                                    hintText: "Select Gender",
                                    value: selectedGender,
                                    items: genderList,
                                    errorText: _genderError,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedGender = val;
                                        _genderError = null;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Date of Birth",
                                        style: AppTextStyles.primaryBold,
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
                            const SizedBox(height: 32),
                            _isSaving
                                ? const Center(
                                    child: CircularProgressIndicator(color: kSSIorange),
                                  )
                                : PrimaryButton(
                                    label: 'Update Profile',
                                    onTap: _updateProfile,
                                  ),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}