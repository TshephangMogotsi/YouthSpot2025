import 'package:youthspot/auth/auth_layout.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/config/supabase_manager.dart';
import 'package:youthspot/global_widgets/connection_status_widget.dart';
import 'package:youthspot/services/notifications_helper.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/articles_provider.dart';
import 'providers/community_events_provider.dart';
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
  
  // Initialize Supabase with better error handling
  await SupabaseManager.initialize();
  
  runApp(const MyApp());
}

SupabaseClient? get supabase => SupabaseManager.client;

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectionStatusWidget(
      child: MultiProvider(
        providers: [
           ChangeNotifierProvider(
                create: (_) => EventProvider()..loadEventsFromDB(),
              ),
              ChangeNotifierProvider(
                create: (_) => CommunityEventsProvider(),
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
          title: 'YouthSpot',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AuthLayout()
        ),
      ),
    );
  }
}