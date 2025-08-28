import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

class NewsArticleShimmer extends StatelessWidget {
  const NewsArticleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Container(
          margin: const EdgeInsets.only(top: 10, bottom: 30, left: 20),
          decoration: BoxDecoration(
            color: theme == ThemeMode.dark
                ? const Color(0xFF191919)
                : Colors.white,
            borderRadius: BorderRadius.circular(28.0),
            border: theme == ThemeMode.dark
                ? const Border.fromBorderSide(
                    BorderSide(color: Colors.transparent, width: 0.5))
                : const Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 0.5)),
          ),
          child: Shimmer.fromColors(
            baseColor: theme == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[300]!,
            highlightColor: theme == ThemeMode.dark ? Colors.grey[800]! : Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article image shimmer
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  height: 220,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                const SizedBox(height: 15),
                // Article content shimmer
                Container(
                  width: 300,
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title shimmer (2 lines)
                      Container(
                        width: double.infinity,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Author and duration shimmer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}