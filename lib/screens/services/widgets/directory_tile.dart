import 'package:flutter/material.dart';

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
    required this.contact,
  });

  final String title;
  final String location;
  final String imageURL;
  final IconData trailing;
  final bool borderVisible;
  final double latitude;
  final double longitude;
  final String contact;

  final Function()? onTap;
  final Function()? onCall;

  @override
  Widget build(BuildContext context) {
    final isExpanded = ValueNotifier<bool>(false);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
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
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: borderVisible,
          child: const PrimaryDivider(),
        ),
        ExpandingContainer(
          isExpanded: isExpanded,
          location: location,
          latitude: latitude,
          longitude: longitude,
          contact: contact,
          onCall: onCall,
        ),
      ],
    );
  }
}