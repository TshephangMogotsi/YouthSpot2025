
import 'package:flutter/material.dart';

import '../../../../../config/constants.dart';
import '../../../../../global_widgets/pill_button.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          const Color(0xFF1C1C24),
      title: const Text(
          'Required Fields'),
      content: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Text(
              'A required field is a field that must be completed by the user before the form can be submitted.'),
          const Height10(),
          const Text(
              "Required fields are marked with an asterisk (*)"),
          const Height20(),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              PillButton(
                title: "Ok",
                backgroundColor:
                    kSSIorange,
                onTap: () {
                  Navigator.pop(
                      context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
