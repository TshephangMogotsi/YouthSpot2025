import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';
import '../../config/constants.dart';

class QoutesCard extends StatelessWidget {
  const QoutesCard({
    super.key,
    required this.id,
    required this.quote,
    required this.author,
    required this.backgroundImage,
    this.isFavorite = false,
    this.onTap,
  });

  final String id;
  final String quote;
  final String author;
  final String backgroundImage; // URL of the image
  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mainBorderRadius),
      ),
      child: Stack(
        children: [
          // Check if backgroundImage is null or empty
          if (backgroundImage.isNotEmpty)
            // CachedNetworkImage with loading and error handling
            CachedNetworkImage(
              imageUrl: backgroundImage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mainBorderRadius),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child:
                    _buildQuoteContent(), // Display the text when image is loaded
              ),
              placeholder: (context, url) =>
                  _buildShimmerEffect(), // Shimmer while loading
              errorWidget: (context, url, error) => _buildDefaultBackground(),
            )
          else
            // Use default background when no image URL is provided
            _buildDefaultBackground(),
        ],
      ),
    );
  }

  Widget _buildDefaultBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mainBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kSSIorange.withOpacity(0.8),
            kSSIorange.withOpacity(0.6),
          ],
        ),
      ),
      child: _buildQuoteContent(),
    );
  }

  Widget _buildQuoteContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            quote,
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              shadows: [
                Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(1.0, 1.0)),
              ],
            ),
            maxLines: 6,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onTap, // This will trigger the toggle function
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build the shimmer effect while loading
  Widget _buildShimmerEffect() {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context,theme ,snapshot) {
        return Shimmer.fromColors(
          baseColor: theme == ThemeMode.dark ? Colors.grey[900]!:Colors.grey[300]!,
          highlightColor: theme == ThemeMode.dark ? Colors.grey[800]!: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            height: double.infinity,
          ),
        );
      }
    );
  }
}
