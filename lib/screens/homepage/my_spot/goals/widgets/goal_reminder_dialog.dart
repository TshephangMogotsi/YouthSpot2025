import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/constants.dart';
import '../../../../../../config/theme_manager.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../db/models/goal_model.dart';
import '../../../../../global_widgets/pill_button.dart';
import '../../../../../global_widgets/primary_container.dart';

class GoalRemindersDialog extends StatelessWidget {
  const GoalRemindersDialog({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainBorderRadius),
          ),
          backgroundColor: theme == ThemeMode.dark
              ? backgroundColorDark
              : backgroundColorLight,
          title: const Text('Goal Reminders'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: kSSIorange,
                  ),
                  const Width10(),
                  Text('${DateTime.now().day} '),
                  Text('${DateFormat('MMMM').format(DateTime.now())} '),
                  Text('${DateTime.now().year}'),
                ],
              ),
              const Height10(),

              const Height20(),
              //list of medicine doses time
              Column(
                children: goal.reminders
                    .map(
                      (e) => Column(
                        children: [
                          Opacity(
                            opacity: now.isAfter(
                              DateTime(
                                now.year,
                                now.month,
                                now.day,
                                e.hour,
                                e.minute,
                              ),
                            )
                                ? 0.2 // If dose time has passed, set opacity to 0.5
                                : 1.0, // Otherwise, set opacity to 1.0
                            child: PrimaryContainer(
                              activeBorder: Border.all(
                                color: // If dose time has passed, set border color to grey
                                    now.isAfter(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    e.hour,
                                    e.minute,
                                  ),
                                )
                                        ? Colors.grey
                                        : kSSIorange,
                                width: 2,
                              ),
                              borderColor: kSSIorange,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //display time in timeofday format
                                  //dose number
                                  Text(
                                      'Reminder ${goal.reminders.indexOf(e) + 1} '),
                                  Text(e.format(context)),
                                ],
                              ),
                            ),
                          ),
                          const Height20()
                        ],
                      ),
                    )
                    .toList(),
              ),
              PillButton(
                title: "Cancel",
                backgroundColor: kSSIorange,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
