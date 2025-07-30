import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/providers/articles_provider.dart';
import 'package:youthspot/screens/homepage/article_view.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Articles'),
      ),
      body: ListView.builder(
        itemCount: articlesProvider.allArticles.length,
        itemBuilder: (context, index) {
          final article = articlesProvider.allArticles[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleView(article: article),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'By ${article.authorName}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          article.categoryName,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
