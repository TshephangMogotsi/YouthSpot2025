import 'package:flutter/material.dart';
import 'package:youthspot/config/constants.dart';

import '../../../global_widgets/primary_divider.dart';
import '../expanding_container.dart';
import '../info_tile.dart';

class CustomDirectoryTile extends StatelessWidget {
  const CustomDirectoryTile({
    super.key,
    required this.title,
    required this.imageURL,
    required this.trailing,
    required this.borderVisible,
    this.onTap,
    this.onCall,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.locationUrl,
    required this.contact,
  });

  final String title;
  final String location;
  final String imageURL;
  final IconData trailing;
  final bool borderVisible;
  final double latitude;
  final double longitude;
  final String? locationUrl;
  final String contact;

  final Function()? onTap;
  final Function()? onCall;

  @override
  Widget build(BuildContext context) {
    final isExpanded = ValueNotifier<bool>(false);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            isExpanded.value = !isExpanded.value;
            onTap?.call();
          },
          child: InfoTile(
            imageURL: imageURL,
            title: title,
            isExpanded: isExpanded,
          ),
        ),
        Height10(),

        ExpandingContainer(
          isExpanded: isExpanded,
          location: location,
          latitude: latitude,
          longitude: longitude,
          locationUrl: locationUrl,
          contact: contact,
          onCall: onCall,
        ),
        const SizedBox(height: 5),
        Height10(),
      ],
    );
  }
}
