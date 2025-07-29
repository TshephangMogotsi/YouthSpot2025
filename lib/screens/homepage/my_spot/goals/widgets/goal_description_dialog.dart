import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/constants.dart';
import '../../../../../../config/theme_manager.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../db/models/goal_model.dart';
import '../../../../../global_widgets/pill_button.dart';

class GoalDescriptionDialog extends StatelessWidget {
  const GoalDescriptionDialog({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  Widget build(BuildContext context) {
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Goal'),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kSSIorange,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    goal.goalName,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.bullseye),
                    const Width10(),
                    Text(goal.goal),
                  ],
                ),
                const Height20(),
                Row(
                  children: [
                    const Icon(Icons.description_outlined),
                    const Width10(),
                    Expanded(child: Text(goal.description)),
                  ],
                ),
                const Height20(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: kSSIorange,
                                ),
                                const Width10(),
                                Text(
                                  // '${DateFormatgoal.startDay}',
                                  DateFormat('d MMMM, yyyy')
                                      .format(goal.startDay),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                const Width10(),
                                const Text('to'),
                                const Width10(),
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: kSSIorange,
                                ),
                                const Width10(),
                                Text(
                                  // '${DateFormatgoal.startDay}',
                                  DateFormat('d MMMM, yyyy')
                                      .format(goal.endDay),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Height20(),
                //list of medicine doses time

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
        });
  }
}
