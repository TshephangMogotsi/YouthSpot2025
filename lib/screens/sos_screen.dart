import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/global_widgets/primary_button.dart';
import 'package:youthspot/global_widgets/primary_container.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitSOS() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not identify user. Please log in again.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        // Get user profile data from Supabase
        final profileResponse = await Supabase.instance.client
            .from('profiles')
            .select('full_name, mobile_number')
            .eq('id', user.id)
            .single();

        await Supabase.instance.client.from('sos_requests').insert({
          'user_id': user.id,
          'full_name': profileResponse['full_name'] ?? 'Unknown',
          'phone': profileResponse['mobile_number'] ?? 'Unknown',
          'distress_message': _messageController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS submitted successfully!')),
        );
        Navigator.of(context).pop(); // Go back after submission
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting SOS: $error')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: PrimaryContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Describe your situation below. Your name and contact number will be sent to our support team automatically.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _messageController,
                    decoration:  InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'How are you in distress?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe your situation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(label: 'Send SOS', onTap: _submitSOS),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
