import 'package:youthspot/auth/register.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';

class AuthSwitcher extends StatefulWidget {
  final bool showSignInInitially;

  const AuthSwitcher({super.key, this.showSignInInitially = true});

  @override
  State<AuthSwitcher> createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<AuthSwitcher> {
  late bool showSignIn;

  @override
  void initState() {
    super.initState();
    showSignIn = widget.showSignInInitially;
  }

  void toggle() => setState(() => showSignIn = !showSignIn);

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignInPage(onToggle: toggle)
        : RegisterPage(onToggle: toggle);
  }
}
