import 'package:flutter/material.dart';

import '../../../services/local_auth.dart';

class LocalAuthTest extends StatefulWidget {
  const LocalAuthTest({super.key});

  @override
  State<LocalAuthTest> createState() => _LocalAuthTestState();
}

class _LocalAuthTestState extends State<LocalAuthTest> {
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final authenticate = await LocalAuth.authenticate();
                setState(() {
                  authenticated = authenticate;
                });
              },
              child: const Text('Authenticate'),
            ),
            if (authenticated)
              const Text(
                'You are authenticated',
              ),
            if (authenticated)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    authenticated = false;
                  });
                },
                child: const Text('Log Out'),
              ),
          ],
        ),
      ),
    );
  }
}
