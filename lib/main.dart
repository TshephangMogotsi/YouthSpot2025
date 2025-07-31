import 'package:youthspot/auth/auth_layout.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/services/notifications_helper.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/articles_provider.dart';
import 'providers/event_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/medication_provider.dart';

import 'providers/quotes_provider.dart';
import 'providers/services_provider.dart';
import 'providers/user_provider.dart';
import 'screens/homepage/lifestyleQuiz/quiz_logic.dart';

void main() async {
  setupGetIt();

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initializeNotification();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Supabase.initialize(
    url: "https://xcznelduagrrfzwkcrrs.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhjem5lbGR1YWdycmZ6d2tjcnJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3ODkxMjAsImV4cCI6MjA2NTM2NTEyMH0.Rmp0pnQEc7RRW80oU-MI_OwnEzwJl0v0niyZHIcu8Qw",
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
              create: (_) => EventProvider()..loadEventsFromDB(),
            ),
            ChangeNotifierProvider(
              create: (context) => QuizLogic(),
            ),
            ChangeNotifierProvider(
              create: (_) => GoalProvider()..fetchGoals(),
            ),
            ChangeNotifierProvider(
              create: (context) => MedicationProvider()..fetchMedications(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserProvider(), // Kept for backward compatibility
            ),
            ChangeNotifierProvider(
              create: (_) => ArticlesProvider(),
            ),

            ChangeNotifierProvider(
              create: (_) => ServiceProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => LeaderboardProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => QuoteProvider(),
            ),
            // ChangeNotifierProvider(
            //   create: (_) => AuthState(),
            // ),
            // ChangeNotifierProvider(
            //   create: (_) => DocumentProvider(),
            // ),

             ChangeNotifierProvider(
          create: (_) => AuthService(), // Add your AuthService here
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthLayout()
      ),
    );
  }
}