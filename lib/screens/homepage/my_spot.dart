import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme_manager.dart';
// import '../../../provider/event_provider.dart';
// import '../../../provider/medication_provider.dart';
import '../../../services/services_locator.dart';
// import '../../../widgets/heights_and_widths.dart';
// import '../../../widgets/my_spot_card/my_spot_card.dart';
// import '../../../widgets/primary_padding.dart';
import '../../global_widgets/primary_padding.dart';
import '../../motivational_quotes/motivational_qoutes.dart';
import '../../providers/event_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/medication_provider.dart';
import '../../providers/quotes_provider.dart';
// import '../my_spot/calendar/calendar_page.dart';
// import '../my_spot/goals/goals.dart';
// import '../my_spot/medication/medication.dart';
// import '../my_spot/mood_tracker/mood_tracker.dart';
import 'my_spot/calendar/calendar_page.dart';
import 'my_spot/goals/goals.dart';
import 'my_spot/medication/medication.dart';
import 'my_spot/mood_tracker/mood_tracker.dart';
import 'my_spot_card.dart';

class MySpot extends StatelessWidget {
  const MySpot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return PrimaryPadding(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeManager.themeMode,
                builder: (context, theme, snapshot) {
                  return Text(
                    "My spot",
                    style: TextStyle(
                      color:
                          theme == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: MySpotCard(
                  notifications: null,
                  notificationsBgColor: const Color(0xFF333E80),
                  title: "Mood\nTracker",
                  iconURL: "assets/icon/theater_comedy.png",
                  iconPadding: 5,
                  iconBgColor: const Color(0xFF333E80),
                  imageURL: 'assets/Backgrounds/Mood_tracker_bg.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoodTracker(),
                      ),
                    );
                  },
                  color: const Color(0xFF1D43E8),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Consumer<MedicationProvider>(
                    builder: (context, medicineProvider, child) {
                  final medicine = medicineProvider.getActiveMedications();
                  return MySpotCard(
                    notifications: medicine.length,
                    notificationsBgColor: const Color(0xFF873835),
                    title: "Medication",
                    iconURL: "assets/icon/Pill.png",
                    iconPadding: 5,
                    iconBgColor: const Color(0xFF873835),
                    imageURL: 'assets/Backgrounds/Medication_bg.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Medication(),
                        ),
                      );
                    },
                    color: const Color(0xFFC1E5C3),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
               Expanded(
                child: Consumer<EventProvider>(
                  builder: (context, eventProvider, child) {
                    final activeEventsCount = eventProvider.getActiveEventCount();
                    return MySpotCard(
                      notifications: activeEventsCount,
                      notificationsBgColor: const Color(0xFF80540D),
                      title: "Schedule",
                      iconURL: "assets/icon/Calendar.png",
                      iconBgColor: const Color(0xFF80540D),
                      iconPadding: 7,
                      imageURL: 'assets/Backgrounds/Schedule_bg.png',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CalendarPage(),
                          ),
                        );
                      },
                      color: const Color(0xFFF5E1C9),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                 child: Consumer<GoalProvider>(
                    builder: (context, goalProvider, child) {
                  final goalCount = goalProvider.getActiveGoals();
                      return MySpotCard(
                        notifications: goalCount.length,
                        notificationsBgColor: const Color(0xFF2A5451),
                        title: "Goals",
                        iconURL: "assets/icon/Goal.png",
                        iconPadding: 5,
                        iconBgColor: const Color(0xFF2A5451),
                        imageURL: 'assets/Backgrounds/Goals_bg.png',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Goals(),
                            ),
                          );
                        },
                        color: const Color(0xFFBACBEC),
                        svgColor: const Color(0xFF6742A7),
                      );
                    }),
              ),
            ],
          ),
          
          
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}