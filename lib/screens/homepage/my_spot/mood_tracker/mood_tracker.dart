import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/app_db.dart';
import '../../../../db/models/mood_model.dart';

import '../../../../global_widgets/custom_textfield.dart';
import '../../../../global_widgets/pill_button_2.dart';
import '../../../../global_widgets/primary_button.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/primary_divider.dart';
import '../../../../global_widgets/primary_padding.dart';

import '../../../../services/notifications_helper.dart';
import '../../../../services/services_locator.dart';
import 'widgets/mood_calendar.dart';
import 'widgets/moods_slider.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  bool isLoading = false;
  bool isMoodRecorded = false;

  @override
  void initState() {
    super.initState();
    initMood();
  }

  //controller for mood description
  final TextEditingController moodDescriptionController = TextEditingController();
  //form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //mood slider value
  String mood = '';

  //mood color
  Color moodColor = Colors.yellow;

  Future<void> initMood() async {
    setState(() => isLoading = true);
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final startOfDayString = dateFormat.format(DateTime(now.year, now.month, now.day, 0, 0, 0));
    final endOfDayString = dateFormat.format(DateTime(now.year, now.month, now.day, 23, 59, 59));
    isMoodRecorded = await SSIDatabase.instance.isMoodToday(startOfDayString, endOfDayString);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return PrimaryScaffold(
          child: Column(
            children: [
              PrimaryPadding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mood Tracker',
                      style: headingStyle,
                    ),
                    PillButton2(
                      title: 'Calendar',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MoodCalendar(),
                          ),
                        );
                        // Refresh mood state after returning from calendar
                        await initMood();
                      },
                    ),
                  ],
                ),
              ),
              const Height10(),
              const PrimaryDivider(),
              isLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : !isMoodRecorded
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrimaryPadding(
                                child: PrimaryContainer(
                                  child: Column(
                                    children: [
                                      const Height10(),
                                      const Text(
                                        'How are you feeling today?',
                                        style: TextStyle(
                                          color: properBlack,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Height20(),
                                      const Height10(),
                                      ReviewSlider(
                                        optionStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: theme == ThemeMode.dark
                                              ? Colors.white
                                              : properBlack,
                                        ),
                                        onChange: (value) {
                                          setState(() {
                                            if (value == 0) {
                                              mood = 'terrible';
                                              moodColor = const Color(0xFFFF8A80); // Pastel Red
                                            } else if (value == 1) {
                                              mood = 'bad';
                                              moodColor = const Color(0xFFFFCC80); // Pastel Orange
                                            } else if (value == 2) {
                                              mood = 'okay';
                                              moodColor = const Color(0xFFFFF59D); // Pastel Yellow
                                            } else if (value == 3) {
                                              mood = 'good';
                                              moodColor = const Color(0xFFA5D6A7); // Pastel Green
                                            } else if (value == 4) {
                                              mood = 'great';
                                              moodColor = const Color(0xFF90CAF9); // Pastel Blue
                                            }
                                          });
                                        },
                                      ),
                                      const Height10(),
                                      CustomTextField(
                                        fillColor: Colors.grey[200],
                                        hintText: 'Why do you feel like that...',
                                        controller: moodDescriptionController,
                                        isOnWhiteBackground: true,
                                      ),
                                      const SizedBox(height: 20),
                                      PrimaryButton(
                                        label: "Submit",
                                        onTap: () async {
                                          if (mood.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Please select your mood!"),
                                              ),
                                            );
                                            return;
                                          }
                                          DateTime now = DateTime.now();
                                          String dateTimeString = DateFormat(
                                            'yyyy-MM-dd HH:mm:ss',
                                          ).format(now);
                                          if (kDebugMode) {
                                            print('DateTime as string: $dateTimeString');
                                          }
                                          await addMood(
                                            mood: mood,
                                            description: moodDescriptionController.text,
                                            date: dateTimeString,
                                          );
                                          await initMood();
                                          moodDescriptionController.clear();
                                        },
                                      ),
                                      const Height10(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Congratulations!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                              const Height10(),
                              Text(
                                'You have already recorded your mood today',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: theme == ThemeMode.dark
                                        ? Colors.white
                                        : properBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Lottie.asset(
                                'assets/QuizResultsAnimations/trophy.json',
                                width: 140,
                                repeat: true,
                                reverse: false,
                                animate: true,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 70),
                                child: Text(
                                  'Go to Mood Calendar to see your mood',
                                  style: TextStyle(
                                      color: theme == ThemeMode.dark
                                          ? Colors.white
                                          : properBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addMood({
    required String mood,
    required String description,
    required String date,
  }) async {
    try {
      final moodObject = Mood(
        mood: mood,
        description: description,
        date: date,
      );

      // Add the mood entry to the database
      await SSIDatabase.instance.addMood(moodObject);

      // Trigger a notification after mood is added (non-blocking)
      try {
        await NotificationService.sendImmediateNotification(
          notificationId: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          title: 'Mood Recorded!',
          body: 'Your mood for today ($mood) has been recorded.',
        );
      } catch (e) {
        // Log notification error but don't prevent mood recording success
        if (kDebugMode) {
          print('Notification failed: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding mood: $e');
      }
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to record mood: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }
}