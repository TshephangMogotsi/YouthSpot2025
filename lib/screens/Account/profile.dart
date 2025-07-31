import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/global_widgets/custom_textfield.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getProfile();
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
      _genderController.text = response['gender'] ?? '';
      _dobController.text = response['date_of_birth'] ?? '';
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
      setState(() => _loading = true);
      final auth = Provider.of<AuthService>(context, listen: false);

      try {
        final userId = auth.currentUser?.id;
        if (userId == null) throw Exception("User not logged in");

        await Supabase.instance.client.from('profiles').update({
          'full_name': _fullNameController.text,
          'gender': _genderController.text,
          'date_of_birth': _dobController.text,
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
                  children: [
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
                    CustomTextField(
                      controller: _genderController,
                      hintText: 'Gender',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your gender' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _dobController,
                      hintText: 'Date of Birth',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your date of birth' : null,
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
