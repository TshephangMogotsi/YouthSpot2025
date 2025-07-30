import 'package:youthspot/auth/auth_layout.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/firebase_options.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/articles_provider.dart';
import 'providers/event_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/medication_provider.dart';
import 'providers/pointsProviders/article_points_provider.dart';
import 'providers/pointsProviders/journal_points_provider.dart';
import 'providers/pointsProviders/login_points_providers.dart';
import 'providers/pointsProviders/mood_points_provider.dart';
import 'providers/pointsProviders/motivational_points_provider.dart';
import 'providers/points_provider.dart';
import 'providers/quotes_provider.dart';
import 'providers/services_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  setupGetIt();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: "https://xcznelduagrrfzwkcrrs.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhjem5lbGR1YWdycmZ6d2tjcnJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3ODkxMjAsImV4cCI6MjA2NTM2NTEyMH0.Rmp0pnQEc7RRW80oU-MI_OwnEzwJl0v0niyZHIcu8Qw",
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  static var navigatorKey;

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
              create: (_) => EventProvider()..loadEventsFromDB(),
            ),
            // ChangeNotifierProvider(
            //   create: (context) => QuizLogic(),
            // ),
            ChangeNotifierProvider(
              create: (_) => GoalProvider()..fetchGoals(),
            ),
            ChangeNotifierProvider(
              create: (context) => MedicationProvider()..fetchMedications(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserProvider()..fetchUser(),
            ),
            ChangeNotifierProvider(
              create: (_) => ArticlesProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => ArticlePointsProvider(
                Provider.of<UserProvider>(context, listen: false),
              )..initializeArticlePoints(),
            ),
            ChangeNotifierProvider(
              create: (context) => MoodPointsProvider(
                Provider.of<UserProvider>(context, listen: false),
              )..initializeMoodPoints(),
            ),
            ChangeNotifierProvider(
              create: (context) => JournalPointsProvider(
                Provider.of<UserProvider>(context, listen: false),
              )..initializeJournalPoints(), // Register JournalPointsProvider
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
              create: (context) => PointsProvider(
                Provider.of<UserProvider>(context, listen: false),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => LoginPointsProvider(
                Provider.of<UserProvider>(context, listen: false),
              )..initializeLoginPoints(),
            ),
            ChangeNotifierProvider(
              create: (context) => MotivationalQuotesProvider(
                Provider.of<UserProvider>(context, listen: false),
              )..initializeQuotePoints(), // Register MotivationalQuotesProvider
            ),
             ChangeNotifierProvider(
          create: (_) => AuthService(), // Add your AuthService here
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthLayout(),
      ),
    );
  }
}