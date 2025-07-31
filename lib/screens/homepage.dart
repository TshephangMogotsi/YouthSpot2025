import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../db/models/goal_model.dart';
import '../global_widgets/primary_padding.dart';
import '../providers/goal_provider.dart';
import '../providers/medication_provider.dart';
import '../services/services_locator.dart';
import 'extras.dart';
import 'homepage/my_spot.dart';
import 'homepage/news_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final goalProvider = Provider.of<GoalProvider>(context, listen: false);
    final medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);

    // User auth is now handled by AuthService - no need to fetch user here
    if (kDebugMode) {
      print('Auth handled by Supabase AuthService.');
    }

    goalProvider.deleteInactiveGoals();
    medicationProvider.deleteInactiveMedications();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      backgroundColor: themeManager.themeMode.value == ThemeMode.dark
          ? darkmodeLight
          : backgroundColorLight,
      body: ListView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        children: [
          const Height10(),
          Center(
            child: SvgPicture.asset(
              'assets/icon/appicon_homepage.svg',
              height: 35,
              width: 35,
              colorFilter: ColorFilter.mode(
                themeManager.themeMode.value == ThemeMode.dark
                    ? Colors.white
                    : kSSIorange,
                BlendMode.srcIn,
              ),
            ),
          ),
          const Height20(),

          // Articles Section
          const NewsCarousel(),
          const Height10(),

          // MySpot Section
          const MySpot(),
          const Height10(),

          // Show progress tracker if there are goals
          if (goalProvider.goals.isNotEmpty) ...[
            PrimaryPadding(
              child: buildProgressTracker(goalProvider.goals),
            ),
            const Height20(),
          ],

          // Extras Section
          const Extras(),
          const Height20(),
          const Height20(),
        ],
      ),
    );
  }

  Widget buildProgressTracker(List<Goal> goals) {
    int totalReminders = 0;
    int expiredReminders = 0;

    for (var goal in goals) {
      totalReminders += goal.totalReminders;
      expiredReminders += calculateExpiredReminders(goal);
    }

    double progress =
        totalReminders == 0 ? 0.0 : expiredReminders / totalReminders;
    int progressPercentage = (progress * 100).toInt();

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const Goals(),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          image: DecorationImage(
            image: AssetImage('assets/Backgrounds/ProgressIndicator.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Goal\nProgression',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF2A5451),
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 6),
                  child: Text(
                    '$progressPercentage%',
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
            const Height10(),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF2A5451),
            ),
          ],
        ),
      ),
    );
  }

  int calculateExpiredReminders(Goal goal) {
    int expiredReminders = 0;
    DateTime now = DateTime.now();

    for (var reminder in goal.reminders) {
      DateTime reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        reminder.hour,
        reminder.minute,
      );

      if (reminderDateTime.isBefore(now)) {
        expiredReminders++;
      }
    }

    return expiredReminders;
  }
}
