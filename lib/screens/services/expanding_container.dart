import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
    required this.contact,
    this.onCall
  });

  final ValueNotifier<bool> isExpanded;
  final String location;
  final String contact;
  final double latitude;
  final double longitude;
  final Function()? onCall;

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
                        onTap: onCall,
                        child: Row(children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: kSSIorange,
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
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      latitude, longitude);
                                },
                                child: Container(
                                  //add light blue rounded shape decoration
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: const Text('Open Maps',
                                      style: TextStyle(color: Colors.white)),
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