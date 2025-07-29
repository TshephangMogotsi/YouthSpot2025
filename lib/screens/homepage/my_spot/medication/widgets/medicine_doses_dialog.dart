import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../config/constants.dart';
import '../../../../../config/theme_manager.dart';
import '../../../../../global_widgets/pill_button.dart';
import '../../../../../global_widgets/primary_container.dart';
import '../../../../../services/services_locator.dart';

class MedicineDoseDialog extends StatelessWidget {
  const MedicineDoseDialog({
    super.key,
    this.medicineDoses,
    required this.startDate,
    required this.endDate,
  });

  final List<TimeOfDay>? medicineDoses;
  final DateTime startDate; // Added startDate
  final DateTime endDate; // Added endDate

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final themeManager = getIt<ThemeManager>();
    final dateFormatter = DateFormat('dd MMMM yyyy');

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
          title: Text(
            'Medication Schedule',
            style: titleStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.date_range,
                    color: kSSIorange,
                  ),
                  const Width10(),
                  Text(
                    'Start Date:',
                    style: subHeadingStyle,
                  ),
                  const Width10(),
                  Text(
                    dateFormatter.format(startDate),
                    style: subTitleStyle,
                  ),
                ],
              ),
              const Height10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.date_range,
                    color: kSSIorange,
                  ),
                  const Width10(),
                  Text(
                    'End Date:',
                    style: subHeadingStyle,
                  ),
                  const Width10(),
                  Text(
                    dateFormatter.format(endDate),
                    style: subTitleStyle,
                  ),
                ],
              ),
              const Height20(),
              Text(
                'Daily Doses',
                style: subHeadingStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Height10(),
              // List of medicine doses
              Column(
                children: medicineDoses!
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
                                ? 0.2 // If dose time has passed, set opacity to 0.2
                                : 1.0, // Otherwise, set opacity to 1.0
                            child: PrimaryContainer(
                              activeBorder: Border.all(
                                color: now.isAfter(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    e.hour,
                                    e.minute,
                                  ),
                                )
                                    ? Colors.grey // If dose time passed, grey border
                                    : kSSIorange, // Otherwise, orange border
                                width: 2,
                              ),
                              borderColor: kSSIorange,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dose ${medicineDoses!.indexOf(e) + 1}',
                                    style: subTitleStyle,
                                  ),
                                  Text(
                                    e.format(context),
                                    style: subTitleStyle,
                                  ),
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
              const Height20(),
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
