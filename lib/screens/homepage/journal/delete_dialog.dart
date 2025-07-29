import 'package:flutter/material.dart';

import '../../../../../config/constants.dart';
import '../../../../services/services_locator.dart';
import '../../../config/theme_manager.dart';
import '../../../global_widgets/primary_button.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<Object>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: theme == ThemeMode.dark
                ? backgroundColorDark
                : backgroundColorLight,
            title: Text(
              'Delete Journal Entry',
              style: titleStyle.copyWith(fontSize: 26),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Height20(),
                const Text(
                  'Are you sure you want permanently delete this entry?',
                  style: TextStyle(fontSize: 22),
                ),
                const Height20(),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: "Cancel",
                        customBackgroundColor: kSSIorange,
                        onTap: () {
                          // Pass false to indicate cancel
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    const Width20(),
                    Expanded(
                      child: PrimaryButton(
                        label: "Delete",
                        customBackgroundColor: Colors.blueGrey.withValues(alpha: 0.3),
                        onTap: () {
                          // Pass true to indicate delete
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
