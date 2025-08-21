import 'package:youthspot/auth/auth_layout.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/services/notifications_helper.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:youthspot/services/release_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/theme_manager.dart';
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
  
  // Enhanced Supabase initialization with comprehensive error handling
  bool supabaseInitialized = false;
  try {
    await ReleaseLogger.logInfo('Initializing Supabase...');
    
    await Supabase.initialize(
      url: "https://xcznelduagrrfzwkcrrs.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhjem5lbGR1YWdycmZ6d2tjcnJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3ODkxMjAsImV4cCI6MjA2NTM2NTEyMH0.Rmp0pnQEc7RRW80oU-MI_OwnEzwJl0v0niyZHIcu8Qw",
    );
    
    // Test Supabase connection
    final client = Supabase.instance.client;
    if (client.auth.currentUser == null) {
      await ReleaseLogger.logInfo('Supabase initialized successfully - no current user');
    } else {
      await ReleaseLogger.logInfo('Supabase initialized successfully - user logged in');
    }
    
    supabaseInitialized = true;
    
  } catch (e, stackTrace) {
    // Enhanced error logging for Supabase initialization failures
    await ReleaseLogger.logError('Supabase initialization failed', error: e, stackTrace: stackTrace);
    
    // Try to identify specific failure reasons
    if (e.toString().contains('network') || e.toString().contains('timeout')) {
      await ReleaseLogger.logError('Network-related Supabase initialization failure');
    } else if (e.toString().contains('Invalid API key')) {
      await ReleaseLogger.logError('Invalid Supabase API key');
    } else {
      await ReleaseLogger.logError('Unknown Supabase initialization error');
    }
    
    supabaseInitialized = false;
  }
  
  // Log initialization status for debugging
  await ReleaseLogger.logInfo('App starting with Supabase initialized: $supabaseInitialized');
  
  runApp(MyApp(supabaseInitialized: supabaseInitialized));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  final bool supabaseInitialized;

  const MyApp({super.key, this.supabaseInitialized = true});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
            ChangeNotifierProvider(
              create: (_) => AuthService(), // Add your AuthService here
            ),
      ],
      child: Builder(
        builder: (context) {
          final themeManager = getIt<ThemeManager>();
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: themeManager.themeMode,
            builder: (context, themeMode, child) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'YouthSpot',
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                  brightness: Brightness.light,
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: Brightness.dark,
                  ),
                  useMaterial3: true,
                  brightness: Brightness.dark,
                ),
                home: const AuthLayout(),
              );
            },
          );
        },
      ),
    );
  }
}