import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:youthspot/providers/articles_provider.dart';
import 'package:youthspot/screens/homepage/article_view.dart';
import 'package:youthspot/screens/homepage/news_article_list_tile.dart';

class AllArticlesView extends StatefulWidget {
  const AllArticlesView({super.key});

  @override
  State<AllArticlesView> createState() => _AllArticlesViewState();
}

class _AllArticlesViewState extends State<AllArticlesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticlesProvider>().fetchAllArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final articlesProvider = Provider.of<ArticlesProvider>(context);
    return PrimaryScaffold(
      child: PrimaryPadding(
        child: ListView.builder(
          itemCount: articlesProvider.allArticles.length,
          itemBuilder: (context, index) {
            final article = articlesProvider.allArticles[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: NewsArticleListTile(
                imgURL: article.imageUrl,
                title: article.title,
                duration: '10 min read',
                author: article.author,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleView(article: article),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
