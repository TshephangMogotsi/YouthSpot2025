import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';

import '../../../../../config/constants.dart';
import '../../../../../config/theme_manager.dart';
import '../../../../../db/app_db.dart';
import '../../../../../services/services_locator.dart';
import '../../../../db/models/goal_model.dart';
import '../../../../global_widgets/add_date_bar.dart';
import '../../../../global_widgets/pill_button_2.dart';
import '../../../../global_widgets/primary_button.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/section_header.dart';
import '../../../../providers/goal_provider.dart';
import 'add_goal_page.dart';
import 'widgets/goal_description_dialog.dart';
import 'widgets/goal_reminder_dialog.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Goal> goals = [];
  bool isLoading = false;
  ValueNotifier<DateTime> selectedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  void initState() {
    super.initState();
    refreshGoals();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshGoals() async {
    setState(() => isLoading = true);
    goals = await SSIDatabase.instance.readAllGoals();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, child) {
          return PrimaryScaffold(
          child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Height20(),
                PrimaryPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Goals',
                        style: headingStyle,
                      ),
                      PillButton2(
                        title: 'Add',
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddGoalPage2()),
                          );
                          refreshGoals();
                        },
                      ),
                    ],
                  ),
                ),
                const Height20(),
                const PrimaryPadding(
                  child: PrimaryContainer(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.bullseye,
                              size: 50,
                            ),
                            Width10(),
                            Expanded(
                              child: Text(
                                'Track and manage your goals to improve your adherence and effectiveness of your growth.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Height20(),
                AddDateBar(
                  displayDate: (newDate) {
                    selectedDateNotifier.value = newDate;
                    if (kDebugMode) {
                      print(newDate);
                    }
                  },
                ),
                const Height20(),
                const PrimaryPadding(
                  child: SectionHeader(title: 'My Goals'),
                ),
                const Height20(),
                ValueListenableBuilder<DateTime>(
                  valueListenable: selectedDateNotifier,
                  builder: (context, selectedDate, _) {
                    return Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : goals.isEmpty
                              ? const PrimaryPadding(
                                  child: PrimaryContainer(
                                    child: Center(
                                      child: Text(
                                        'No Goals Added',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : buildGoalList(selectedDate, goals),
                    );
                  },
                ),
                const Height20(),
              ],
            ),
          ),
        );
        });
  }

  bool isGoalToday(DateTime startDay, DateTime endDay, DateTime selectedDate) {
    DateTime start = DateTime(startDay.year, startDay.month, startDay.day);
    DateTime end = DateTime(endDay.year, endDay.month, endDay.day);
    DateTime selected =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selected.isAfter(end) || selected.isBefore(start)) {
      return false;
    }
    return true;
  }

  Widget buildGoalList(DateTime selectedDate, List<Goal> goals) {
    final themeManager = getIt<ThemeManager>();

    List<Goal> activeGoals = goals.where((goal) {
      return isGoalToday(goal.startDay, goal.endDay, selectedDate);
    }).toList();

    if (activeGoals.isEmpty) {
      return const PrimaryPadding(
        child: PrimaryContainer(
          child: Center(
            child: Text(
              'No goals scheduled for this day',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: activeGoals.length,
            itemBuilder: (context, index) {
              final goal = activeGoals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PrimaryPadding(
                  child: PrimaryContainer(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => GoalDescriptionDialog(goal: goal),
                      );
                    },
                    bgColor: theme == ThemeMode.dark
                        ? darkmodeFore
                        : setBgColor(index),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              GoalRemindersDialog(goal: goal),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: setIconBgColor(index),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.alarm,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '${goal.reminders.length}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Width10(),
                                    Row(
                                      children: [
                                        const Row(
                                          children: [
                                            Text(
                                              'GOAL',
                                            ),
                                          ],
                                        ),
                                        const Width10(),
                                        Container(
                                          height: 25,
                                          width: 2,
                                          color: Colors.grey,
                                        ),
                                        const Width10(),
                                        Text(
                                          goal.goal,
                                        ),
                                        const Width10(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Width10(),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 250,
                                  child: PrimaryContainer(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    borderRadius: BorderRadius.circular(30),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 3,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        const Height10(),
                                        PrimaryButton(
                                          label: 'Edit',
                                          onTap: () async {
                                            Navigator.pop(context);
                                            bool refresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddGoalPage2(
                                                  goal: goal,
                                                ),
                                              ),
                                            );
                                            if (refresh) {
                                              refreshGoals();
                                            }
                                          },
                                        ),
                                        const Height20(),
                                        PrimaryButton(
                                          label: 'Delete',
                                          customBackgroundColor: pinkClr,
                                          onTap: () async {
                                            Navigator.pop(context);
                                            bool refresh = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DeleteGoalDialog(goal: goal),
                                            );
                                            if (refresh) {
                                              refreshGoals();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.more_vert_rounded,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Color setBgColor(int index) {
    switch (index % 4) {
      case 0:
        return const Color(0xFFCBEFED);
      case 1:
        return const Color(0xFFEEE1FF);
      case 2:
        return const Color(0xFFFBE0D7);
      case 3:
        return const Color(0xFFFFE0E9);
      default:
        return const Color(0xFF248d92);
    }
  }

  Color setIconBgColor(int index) {
    switch (index % 4) {
      case 0:
        return const Color(0xFF248d92);
      case 1:
        return const Color(0xFF696db0);
      case 2:
        return const Color(0xFFeb683b);
      case 3:
        return const Color(0xFFff3061);
      default:
        return const Color(0xFF248d92);
    }
  }
}

class DeleteGoalDialog extends StatelessWidget {
  const DeleteGoalDialog({
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
            title: Text(
              'Delete Goal',
              style: titleStyle.copyWith(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want permanently delete this entry? This action cannot be reversed.',
                  style: TextStyle(fontSize: 18),
                ),
                const Height20(),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: "Cancel",
                        customBackgroundColor: kSSIorange,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Width20(),
                    Expanded(
                      child: PrimaryButton(
                        label: "Delete",
                        customBackgroundColor: Colors.blueGrey.withOpacity(.3),
                        onTap: () async {
                          final goalProvider =
                              Provider.of<GoalProvider>(context, listen: false);

                          await goalProvider.deleteGoal(goal);

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
