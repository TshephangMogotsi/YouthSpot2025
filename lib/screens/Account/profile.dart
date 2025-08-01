import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/global_widgets/custom_textfield.dart';
import 'package:youthspot/global_widgets/full_width_dropdown.dart';
import 'package:youthspot/global_widgets/initials_avatar.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/global_widgets/primary_container.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:youthspot/screens/homepage/my_spot/goals/widgets/date_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _loading = true;
  String? selectedGender;
  DateTime? dateOfBirth;
  bool? isGenderSelected;

  final List<String> genderList = [
    'Male',
    'Female',
    'Non-binary',
  ];

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _usernameController.dispose();
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
      selectedGender = response['gender'] ?? '';
      String dobString = response['date_of_birth'] ?? '';
      if (dobString.isNotEmpty) {
        try {
          // Try to parse the date from DD/MM/YYYY format
          dateOfBirth = DateFormat('dd/MM/yyyy').parse(dobString);
          _dobController.text = dobString;
        } catch (e) {
          // If parsing fails, try other formats or set to current date
          dateOfBirth = DateTime.now();
          _dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
        }
      } else {
        dateOfBirth = DateTime.now();
        _dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
      }
      _mobileController.text = response['mobile_number'] ?? '';
      _usernameController.text = response['username'] ?? '';
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
    if (_formKey.currentState!.validate()) {
      if (selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select gender'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _loading = true);
      final auth = Provider.of<AuthService>(context, listen: false);

      try {
        final userId = auth.currentUser?.id;
        if (userId == null) throw Exception("User not logged in");

        await Supabase.instance.client.from('profiles').update({
          'full_name': _fullNameController.text,
          'gender': selectedGender,
          'date_of_birth': dateOfBirth != null ? DateFormat('dd/MM/yyyy').format(dateOfBirth!) : '',
          'mobile_number': _mobileController.text,
          'username': _usernameController.text,
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
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Avatar at the top
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: InitialsAvatar(
                          fullName: _fullNameController.text,
                          radius: 50,
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your username' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _fullNameController,
                      hintText: 'Full Name',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your full name' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Gender', style: inputTitle),
                    const Height10(),
                    FullWidthDropdownButton(
                      hintText: 'Select gender',
                      showError: isGenderSelected != null,
                      initialValue: selectedGender,
                      options: genderList,
                      onOptionSelect: (option) {
                        if (kDebugMode) {
                          print(option);
                        }
                        setState(() {
                          selectedGender = option;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Date of Birth', style: inputTitle),
                    const Height10(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryContainer(
                                child: CustomDatePicker(
                                  initialDate: dateOfBirth ?? DateTime.now(),
                                  showIcon: false,
                                  isDoBField: true,
                                  labelText: 'Date of Birth',
                                  onDateSelected: (date) {
                                    setState(() {
                                      dateOfBirth = date;
                                      _dobController.text = DateFormat('dd/MM/yyyy').format(date);
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _mobileController,
                      hintText: 'Mobile Number',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your mobile number' : null,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Update Profile',
                      onTap: _updateProfile,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
