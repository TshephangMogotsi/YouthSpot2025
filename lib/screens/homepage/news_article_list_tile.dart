import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

class NewsArticleListTile extends StatelessWidget {
  const NewsArticleListTile({
    super.key,
    required this.imgURL,
    required this.title,
    required this.author,
    required this.duration,
    required this.onTap,
  });

  final String imgURL;
  final String title;
  final String author;
  final String duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme == ThemeMode.dark
                  ? const Color(0xFF191919)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                if (theme != ThemeMode.dark)
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,  // Center content vertically
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: imgURL,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Text info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // Left-align text
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,  // Left-align author/duration
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "By $author",
                            style: const TextStyle(
                              color: Color(0xFFFF9600),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
