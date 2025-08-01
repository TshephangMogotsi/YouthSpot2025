import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/font_constants.dart';
import '../../global_widgets/primary_padding.dart';
import '../../global_widgets/section_header.dart';
import '../../providers/articles_provider.dart';

import 'all_articles_view.dart';
import 'article_view.dart';
import 'news_article.dart';

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final articlesProvider = Provider.of<ArticlesProvider>(context);

    return Column(
      children: [
        PrimaryPadding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               SectionHeader(title: 'Articles',),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllArticlesView(),
                    ),
                  );
                },
                child:  Text(
                  "Read All",
                    style: AppTextStyles.secondarySemiBold.copyWith(
                              color: Color(0xFFFF9600),
                            ),
                  // style: TextStyle(
                  //   color: kSSIorange,
                  //   fontSize: 12,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20.0),
          height: 375.0,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: articlesProvider.articles.length,
            itemBuilder: (BuildContext context, int index) {
              final article = articlesProvider.articles[index];

              return NewsArticle(
                imgURL: article.imageUrl,
                title: article.title,
                duration: '10 min read',
                author: article.author,
                articleId: article.id, // Pass the article ID here
                onTap: () {
                  // Navigate to the article view
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleView(article: article),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
