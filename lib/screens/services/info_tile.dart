import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.imageURL,
    required this.title,
    required this.isExpanded,
  });

  final String imageURL;
  final String title;
  final ValueNotifier<bool> isExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CachedNetworkImage(
              
              height: 30,
              width: 30,
              imageUrl: imageURL,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => Icon(
                Icons.image,
                color: Colors.grey[600],
                size: 25.0,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.grey[600],
                  size: 15.0,
                ),
              ),
              cacheKey: imageURL,
              useOldImageOnUrlChange: true,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Expanded(
          flex: 1,
          child: ValueListenableBuilder(
            valueListenable: isExpanded,
            builder: (context, value, child) {
              return RotationTransition(
                turns: AlwaysStoppedAnimation(value ? 0.5 : 0),
                child: const Icon(
                  Icons.expand_more,
                  color: kSSIorange,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}