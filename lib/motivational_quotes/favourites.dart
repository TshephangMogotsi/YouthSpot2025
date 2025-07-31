import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/constants.dart';
import '../global_widgets/primary_container.dart';
import '../global_widgets/primary_padding.dart';
import '../global_widgets/primary_scaffold.dart';
import '../providers/quotes_provider.dart';


class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<String> removingIndexes = [];

  void toggleFavorite(String id) async {
    setState(() {
      removingIndexes.add(id); // Mark the item as being removed
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Wait for the animation to complete

    Provider.of<QuoteProvider>(context, listen: false).toggleFavorite(id);

    setState(() {
      removingIndexes.remove(id); // Clean up after removal
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteQuotes = Provider.of<QuoteProvider>(context).favoriteQuotes;

    return PrimaryScaffold(
      child: favoriteQuotes.isEmpty
          ? const Center(
              child: Text(
                'No Favorites Added',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            )
          : PrimaryPadding(
              child: ListView.builder(
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  final quote = favoriteQuotes[index];
                  final isRemoving = removingIndexes.contains(quote.id);

                  return AnimatedOpacity(
                    opacity: isRemoving ? 0 : 1,
                    duration: const Duration(milliseconds: 100),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      transform: Matrix4.translationValues(
                          isRemoving ? -200 : 0, 0, 0), // Slide left when removing
                      child: Column(
                        children: [
                          PrimaryContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quote.author,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const Height10(),
                                Row(
                                  children: [
                                    Expanded(child: Text(quote.quote)),
                                    IconButton(
                                      icon: Icon(
                                        quote.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: quote.isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () => toggleFavorite(quote.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Height20(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
