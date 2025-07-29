import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../config/constants.dart';
import '../../../../../../config/theme_manager.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../db/models/goal_model.dart';

import '../../../../global_widgets/custom_app_bar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../global_widgets/pill_button.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/round_icon_button.dart';
import '../../../../providers/goal_provider.dart';
import '../../../../services/notifications_helper.dart';
import '../calendar/event_color_picker.dart';
import '../medication/widgets/error_dialog.dart';
import '../medication/widgets/time_picker.dart';
import 'widgets/date_picker.dart';
import 'widgets/drop_down_widget.dart';

class AddGoalPage2 extends StatefulWidget {
  const AddGoalPage2({super.key, this.goal});

  final Goal? goal;

  @override
  State<AddGoalPage2> createState() => _AddGoalPage2State();
}

class _AddGoalPage2State extends State<AddGoalPage2> {
  final _formKey = GlobalKey<FormState>();

  //type of goal
  String goal = 'Financial';

  //goal name controller
  TextEditingController goalNameController = TextEditingController();

  //description controller
  final descriptionController = TextEditingController();

  //start date of the goal
  DateTime startDate = DateTime.now();

  //endDate of the goal
  DateTime endDate = DateTime.now();

  //list of goal reminders
  List<TimeOfDay> time = [];

  //reminders count
  int reminders = 0;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _initValues();
    } else {
      time = List<TimeOfDay>.filled(reminders, TimeOfDay.now());
    }
  }

  void _initValues() {
    if (widget.goal != null) {
      // Initialize dropdown value
      goal = widget.goal!.goalName;

      // Initialize other fields
      goalNameController.text = widget.goal!.goal;
      descriptionController.text = widget.goal!.description;
      startDate = widget.goal!.startDay;
      endDate = widget.goal!.endDay;
      reminders = widget.goal!.reminders.length;

      // Initialize reminders
      if (widget.goal!.reminders.isNotEmpty) {
        time = List<TimeOfDay>.from(widget.goal!.reminders);
      } else {
        time = List<TimeOfDay>.filled(reminders, TimeOfDay.now());
      }
    }
  }

  void handleDateSelected(DateTime date) {
    if (startDate.isAfter(date)) {
      setState(() {
        startDate = date;
      });
    } else if (startDate.isBefore(date) || startDate.isAtSameMomentAs(date)) {
      setState(() {
        endDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Scaffold(
            backgroundColor:
                theme == ThemeMode.dark ? darkmodeLight : backgroundColorLight,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: CustomAppBar(
                context: context,
                isHomePage: false,
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: PrimaryPadding(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Add Goal',
                            style: headingStyle,
                          ),
                        ],
                      ),
                      const Height20(),
                      Text('What goal would you like to set? *',
                          style: formFieldTitle),
                      const Height20(),
                      DropDownWithIcons(
                        initialValue:
                            goal, // Use the initialized goal value here
                        onDropDownOptionSelected: (option) {
                          setState(() {
                            goal = option;
                          });
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Height20(),
                            Text('Goal Name*', style: formFieldTitle),
                          const Height10(),
                          CustomTextField(
                            fillColor: theme == ThemeMode.light
                                ? Colors.white
                                : darkmodeFore,
                            controller: goalNameController,
                            hintText: 'Add Title',
                            validator: (title) => title != null && title.isEmpty
                                ? 'Title cannot be empty'
                                : null,
                          ),
                          const Height10(),
                          const Height20(),
                          Text('Description', style: formFieldTitle),
                          const Height10(),
                          CustomTextField(
                            fillColor: theme == ThemeMode.light
                                ? Colors.white
                                : darkmodeFore,
                            controller: descriptionController,
                            maxLines: 3,
                            hintText: 'Add Description',
                            validator: (title) => title != null && title.isEmpty
                                ? 'Description cannot be empty'
                                : null,
                          ),
                          const Height20(),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: kSSIorange,
                                        ),
                                        const Width10(),
                                        Text('Start Date',
                                            style: formFieldTitle),
                                      ],
                                    ),
                                    const Height10(),
                                    PrimaryContainer(
                                      child: CustomDatePicker(
                                        initialDate: DateTime.now(),
                                        showIcon: false,
                                        labelText: 'Select Start Date',
                                        onDateSelected: (date) {
                                          setState(() {
                                            startDate = date;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Width20(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: kSSIorange,
                                        ),
                                        const Width10(),
                                        Text('End Date', style: formFieldTitle),
                                      ],
                                    ),
                                    const Height10(),
                                    PrimaryContainer(
                                      child: CustomDatePicker(
                                        initialDate: DateTime.now(),
                                        showIcon: false,
                                        labelText: 'Select End Date',
                                        onDateSelected: (date) {
                                          if (startDate.isAfter(date)) {
                                            setState(() {
                                              endDate = startDate;
                                            });
                                          } else {
                                            setState(() {
                                              endDate = date;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Height20(),
                          Text('Reminders per day *', style: formFieldTitle),
                          const Height10(),
                          PrimaryContainer(
                            bgColor: theme == ThemeMode.dark
                                ? const Color(0xFF1C1C24)
                                : Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundIconButton(
                                  icon: FontAwesomeIcons.minus,
                                  onClick: () {
                                    setState(() {
                                      if (reminders > 0) {
                                        reminders--;
                                        time = time.sublist(0, reminders);
                                      }
                                    });
                                  },
                                ),
                                const Width20(),
                                Column(
                                  children: [
                                    Text(
                                      'Reminders',
                                      style: subHeadingStyle,
                                    ),
                                    const Height10(),
                                    Text(
                                      '$reminders',
                                      style: headingStyle,
                                    )
                                  ],
                                ),
                                const Width20(),
                                RoundIconButton(
                                  icon: FontAwesomeIcons.plus,
                                  onClick: () {
                                    setState(() {
                                      if (reminders < 10) {
                                        reminders++;
                                        time = List<TimeOfDay>.filled(
                                          reminders,
                                          TimeOfDay.now(),
                                        );
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: time.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  index == 0 ? const Height20() : Container(),
                                  TimePickerWidget(
                                    title: 'Reminder At:',
                                    initialTime: time[index],
                                    onTimeSelected: (selectedTime) {
                                      setState(() {
                                        time[index] = selectedTime;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const Height20(),
                          const EventColorPicker()
                        ],
                      ),
                      const Height20(),
                      const Height10(),
                      PillButton(
                        icon: Icons.add,
                        title: "Save",
                        backgroundColor: kSSIorange,
                        onTap: () async {
                          if (isFormValid()) {
                            await addOrUpdateGoal(context);
                            Navigator.of(context).pop(true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: pinkClr,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Please Enter Required fields',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ErrorDialog();
                                          },
                                        );
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 10,
                                        child: Icon(
                                          Icons.question_mark_sharp,
                                          color: pinkClr,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  bool isFormValid() {
    return goalNameController.text.isNotEmpty;
  }

  Future<void> addOrUpdateGoal(BuildContext context) async {
    final goalProvider = Provider.of<GoalProvider>(context, listen: false);

    final adjustedEndDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    final numDays = adjustedEndDate.difference(startDate).inDays + 1;
    final totalReminders = numDays * time.length;

    final goal = Goal(
      id: widget.goal?.id, // Use the existing ID if updating
      goalName: this.goal,
      goal: goalNameController.text,
      description: descriptionController.text,
      startDay: startDate,
      endDay: endDate,
      reminders: time,
      notificationIds: widget.goal?.notificationIds ?? [],
      totalReminders: totalReminders,
    );

    // Debugging statement to check the goal object before updating
    print('Goal before update: ${goal.toJson()}');

    try {
      if (widget.goal != null) {
        // Update existing goal
        await goalProvider.editGoal(goal, widget.goal!);

        // Cancel previous notifications for this goal before scheduling new ones
        await _cancelPreviousNotifications(goal);

        // Schedule notifications for each reminder time
        final notificationIds = await _scheduleGoalNotifications(goal);

        // Update the goal with the new notification IDs
        final updatedGoal = goal.copy(notificationIds: notificationIds);

        // Save the updated goal with notification IDs
        await goalProvider.editGoal(updatedGoal, widget.goal!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Goal updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Insert new goal
        final newGoal = await goalProvider.addGoal(goal);

        // Cancel previous notifications for this goal before scheduling new ones
        await _cancelPreviousNotifications(newGoal);

        // Schedule notifications for each reminder time
        final notificationIds = await _scheduleGoalNotifications(newGoal);

        // Update the goal with the new notification IDs
        final updatedGoal = newGoal.copy(notificationIds: notificationIds);

        // Save the updated goal with notification IDs
        await goalProvider.editGoal(updatedGoal, newGoal);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Goal added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Print the total number of reminders
      print('Total number of reminders: $totalReminders');
    } catch (e) {
      // Handle any exceptions
      print('Error updating goal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update goal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cancelPreviousNotifications(Goal goal) async {
    // Use a consistent way to generate notification IDs
    for (final notificationId in goal.notificationIds) {
      await NotificationService.cancelNotification(notificationId);
    }
  }

  int generateNotificationId(Goal goal, int reminderIndex) {
    // Generate a consistent notification ID based on goal name and reminder index
    return goal.goalName.hashCode + reminderIndex;
  }

  Future<List<int>> _scheduleGoalNotifications(Goal goal) async {
    List<int> notificationIds = [];
    DateTime currentDate = goal.startDay;

    while (currentDate.isBefore(goal.endDay) ||
        currentDate.isAtSameMomentAs(goal.endDay)) {
      for (int i = 0; i < goal.reminders.length; i++) {
        final reminderTime = goal.reminders[i];
        final notificationId = generateNotificationId(goal, i);

        final notificationTitle = 'Reminder for ${goal.goal}';
        final notificationBody = goal.description.isNotEmpty
            ? 'Note: ${goal.description}'
            : 'Don\'t forget your goal!';

        await NotificationService.scheduleNotification(
          notificationId: notificationId,
          title: notificationTitle,
          body: notificationBody,
          scheduledDate: DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            reminderTime.hour,
            reminderTime.minute,
          ),
        );

        notificationIds.add(notificationId);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return notificationIds;
  }
}