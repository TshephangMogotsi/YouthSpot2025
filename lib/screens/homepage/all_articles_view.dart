import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../db/models/articles_model.dart';
import '../../global_widgets/primary_divider.dart';
import '../../global_widgets/primary_padding.dart';
import '../../global_widgets/snack_pill.dart';
import '../../providers/articles_provider.dart';
import '../../providers/pointsProviders/article_points_provider.dart';
import '../../services/services_locator.dart';
import 'article_view.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ArticlesProvider
    final articlesProvider = Provider.of<ArticlesProvider>(context);
    final themeManager = getIt<ThemeManager>();


    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return Scaffold(
          backgroundColor: themeManager.themeMode.value == ThemeMode.dark
              ? darkmodeLight
              : backgroundColorLight,
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              PrimaryPadding(
                child: Text(
                  "Articles",
                  style: headingStyle,
                ),
              ),
              const Height20(),
              // Build the article list using the articles from the provider
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: articlesProvider.articles.length,
                itemBuilder: (BuildContext context, int index) {
                  final article = articlesProvider.articles[index];
                  return Column(
                    children: [
                      index == 0 ? const SizedBox() : const Height20(),
                      PrimaryPadding(
                        child: ArticleListTile(
                          article: article,
                        ),
                      ),
                      const Height20(),
                      const PrimaryDivider(),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }
}

class ArticleListTile extends StatelessWidget {
  const ArticleListTile({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // Access the PointsProvider and add points for reading the article
            final pointsProvider =
                Provider.of<ArticlePointsProvider>(context, listen: false);

            // Award points for reading the article only if it hasn't been read before
            pointsProvider.addArticlePoints(article.id);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleView(
                  article: article,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: article.imageUrl,
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
              const Width20(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.title,
                      style: subHeadingStyle,
                    ),
                    const Height10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SnackPill(
                              pillColor: kSSIorange,
                              title: "5 days ago",
                            ),
                            const Width10(),
                            SnackPill(
                              pillColor: Colors.grey,
                              title: article.category,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
