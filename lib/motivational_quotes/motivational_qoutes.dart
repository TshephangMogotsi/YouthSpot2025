import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/theme_manager.dart';


import '../config/constants.dart';
import '../global_widgets/primary_divider.dart';
import '../global_widgets/primary_padding.dart';
import '../global_widgets/primary_scaffold.dart';

import '../providers/quotes_provider.dart';
import '../services/services_locator.dart';
import 'favourites.dart';
import 'widgets/qoutes_card.dart';

class MotivationalQuotes extends StatefulWidget {
  const MotivationalQuotes({super.key});

  @override
  State<MotivationalQuotes> createState() => _MotivationalQuotesState();
}

class _MotivationalQuotesState extends State<MotivationalQuotes> {
  final PageController _pageController = PageController();
  int motivationalQoutesIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<QuoteProvider>(context, listen: false).fetchQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Height20(),
          PrimaryPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Quotes', style: headingStyle),
                PillButton2(
                  title: 'Favorites',
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Favorites()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Height20(),
          const PrimaryDivider(),
          Expanded(
            child: Consumer<QuoteProvider>(
              builder: (context, quoteProvider, child) {
                if (quoteProvider.isLoading) {
                  return _buildShimmerEffect(); // Show shimmer while loading
                }

                return PageView.builder(
                  controller: _pageController,
                  itemCount: quoteProvider.quotes.length,
                  onPageChanged: (index) {
                    setState(() {
                      motivationalQoutesIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final quote = quoteProvider.quotes[index];
                    return Center(
                      child: PrimaryPadding(
                        verticalPadding: true,
                        child: QoutesCard(
                          id: quote.id,
                          author: quote.author,
                          quote: quote.quote,
                          backgroundImage: quote.backgroundImage,
                          isFavorite: quote.isFavorite,
                          onTap: () {
                            Provider.of<QuoteProvider>(context, listen: false)
                                .toggleFavorite(quote.id);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              const Width20(),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const Width20(),
            ],
          ),
          const Height20(),
        ],
      ),
    );
  }

  // Shimmer effect while loading
  Widget _buildShimmerEffect() {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context,theme, snapshot) {
        return Shimmer.fromColors(
          baseColor: theme == ThemeMode.dark ? Colors.grey[900]!:Colors.grey[300]!,
          highlightColor:  theme == ThemeMode.dark ? Colors.grey[800]!: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      }
    );
  }
}

class PillButton2 extends StatelessWidget {
  const PillButton2({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
  });

  final String title;
  final void Function()? onTap;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mainBorderRadius),
          color: kSSIorange,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? Container(),
            icon != null
                ? const SizedBox(
                    width: 5,
                  )
                : Container(),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            icon != null
                ? const SizedBox(
                    width: 10,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}