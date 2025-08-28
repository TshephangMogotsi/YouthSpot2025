import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

class ExpandingContainer extends StatelessWidget {
  const ExpandingContainer({
    super.key,
    required this.isExpanded,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.locationUrl,
    required this.contact,
    this.onCall
  });

  final ValueNotifier<bool> isExpanded;
  final String location;
  final String contact;
  final double latitude;
  final double longitude;
  final String? locationUrl;
  final String? locationUrl;
  final Function()? onCall;

  bool get hasLocationData => 
      (locationUrl != null && locationUrl!.isNotEmpty) || 
      (latitude != 0.0 && longitude != 0.0);

  Future<void> _launchLocation() async {
    if (locationUrl != null && locationUrl!.isNotEmpty) {
      // Use URL if available
      final uri = Uri.parse(locationUrl!);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Fallback to coordinates if URL fails
        if (latitude != 0.0 && longitude != 0.0) {
          MapsLauncher.launchCoordinates(latitude, longitude);
        }
      }
    } else if (latitude != 0.0 && longitude != 0.0) {
      // Use coordinates if URL not available
      MapsLauncher.launchCoordinates(latitude, longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder(
      valueListenable: isExpanded,
      builder: (context, value, child) {
        return ValueListenableBuilder<ThemeMode>(
            valueListenable: themeManager.themeMode,
            builder: (context, theme, snapshot) {
              return AnimatedContainer(
                alignment: Alignment.center,
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: theme == ThemeMode.dark
                ? const Color(0xFF191919)
                : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    // color: Colors.grey[300]!.withOpacity(0.4),
                    width: 0.5,
                  ),
                ),
                duration: const Duration(milliseconds: 100),
                height: value ? 122 : 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: contact.toLowerCase().contains('no contact') ? null : onCall,
                        child: Row(children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: contact.toLowerCase().contains('no contact') 
                                  ? Colors.grey[400] 
                                  : kSSIorange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.phone,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(contact),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //row with 2 rows of inside it

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: kSSIorange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(location),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: hasLocationData ? _launchLocation : null,
                                child: Container(
                                  //add light blue rounded shape decoration
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: hasLocationData 
                                        ? Colors.blue[400] 
                                        : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: Text(
                                    hasLocationData 
                                        ? 'Open Maps' 
                                        : 'No Location',
                                    style: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}