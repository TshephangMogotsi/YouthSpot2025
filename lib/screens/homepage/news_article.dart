import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/config/font_constants.dart';

import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

class NewsArticle extends StatelessWidget {
  const NewsArticle({
    super.key,
    required this.imgURL,
    required this.title,
    required this.duration,
    required this.author,
    required this.onTap,
    required this.articleId,
  });

  final String imgURL;
  final String title;
  final String duration;
  final String author;
  final void Function()? onTap;
  final String articleId;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 30, right: 20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article image
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  height: 220,
                  width: 320,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: CachedNetworkImage(
                      imageUrl: imgURL,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: Colors.grey[600],
                          size: 48.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Article content
                Container(
                  width: 300,
                  padding: const EdgeInsets.only(
                    left: 25.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        style: AppTextStyles.primaryBold,
                        // style: TextStyle(
                        //   color: theme == ThemeMode.dark
                        //       ? Colors.white
                        //       : Colors.black,
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 19,
                        // ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'By $author',
                            style: AppTextStyles.secondarySmallBold.copyWith(
                              color: Color(0xFFFF9600),
                            ),
                            // style: const TextStyle(
                            //   color: Color(0xFFFF9600),
                            //   fontSize: 12,
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                          Text(
                            duration,
                              style: AppTextStyles.secondarySmallBold.copyWith(
                              color: Colors.grey,
                            ),
                            // style: const TextStyle(
                            //   color: Colors.grey,
                            //   fontSize: 12,
                            //   fontWeight: FontWeight.bold,
                            // ),
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
