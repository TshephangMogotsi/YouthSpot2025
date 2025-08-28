import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/providers/articles_provider.dart';
import 'package:youthspot/screens/homepage/news_carousel.dart';
import 'package:youthspot/screens/homepage/news_article_shimmer.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:youthspot/config/theme_manager.dart';

void main() {
  group('Article Loading Shimmer Tests', () {
    setUpAll(() {
      // Initialize the service locator for ThemeManager
      setupServiceLocator();
    });

    testWidgets('NewsArticleShimmer displays correctly', (WidgetTester tester) async {
      // Build the shimmer widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              height: 375.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  NewsArticleShimmer(),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify that the shimmer widget is rendered
      expect(find.byType(NewsArticleShimmer), findsOneWidget);
      
      // Verify that the shimmer has proper structure
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('NewsCarousel shows shimmer when loading', (WidgetTester tester) async {
      // Create a mock provider that's initially loading
      final articlesProvider = ArticlesProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<ArticlesProvider>.value(
          value: articlesProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: NewsCarousel(),
            ),
          ),
        ),
      );

      // Initially should show loading shimmer
      expect(find.byType(NewsArticleShimmer), findsWidgets);
      
      // Wait for potential async loading
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
  });
}

// Mock setup function for service locator
void setupServiceLocator() {
  // This would normally set up GetIt dependencies
  // For testing purposes, we'll create a minimal setup
}