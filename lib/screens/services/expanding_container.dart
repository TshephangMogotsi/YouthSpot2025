import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthspot/config/font_constants.dart';

import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

// Utility widgets for spacing
class Height10 extends StatelessWidget {
  const Height10({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(height: 10);
}

class Width10 extends StatelessWidget {
  const Width10({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(width: 10);
}

class Width20 extends StatelessWidget {
  const Width20({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(width: 20);
}

class ExpandingContainer extends StatelessWidget {
  const ExpandingContainer({
    super.key,
    required this.isExpanded,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.locationUrl,
    required this.contact,
    this.onCall,
  });

  final ValueNotifier<bool> isExpanded;
  final String location;
  final String contact;
  final double latitude;
  final double longitude;
  final String? locationUrl;
  final Function()? onCall;

  bool get hasLocationData =>
      (locationUrl != null && locationUrl!.isNotEmpty) ||
      (latitude != 0.0 && longitude != 0.0);

  Future<void> _copyToClipboard(String phoneNumber) async {
    await Clipboard.setData(ClipboardData(text: phoneNumber));
    // Optionally show a snackbar or toast here
  }

  Future<void> _launchLocation() async {
    if (locationUrl != null && locationUrl!.isNotEmpty) {
      final uri = Uri.parse(locationUrl!);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (latitude != 0.0 && longitude != 0.0) {
          MapsLauncher.launchCoordinates(latitude, longitude);
        }
      }
    } else if (latitude != 0.0 && longitude != 0.0) {
      MapsLauncher.launchCoordinates(latitude, longitude);
    }
  }

  Future<void> _callNumber(String number) async {
    // Prepend 'tel:' and launch the dialer with the number
    final Uri telUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      // Optionally show an error to the user
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
              ),
              duration: const Duration(milliseconds: 100),
              height: value ? 170 : 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Width20(),
                        Text(
                          'Contact Details',
                          style: AppTextStyles.primaryBold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _copyToClipboard(contact),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Image(
                                    image: AssetImage('assets/icons/Call.png'),
                                    width: 22,
                                  ),
                                  Text(
                                    contact,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.primarySemiBold
                                        .copyWith(color: const Color(0xFF372727)),
                                  ),
                                  const Image(
                                    image: AssetImage('assets/icons/Copy.png'),
                                    width: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Width10(),
                        GestureDetector(
                          onTap: contact.toLowerCase().contains('no contact')
                              ? null
                              : () => _callNumber(contact),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 40,
                            ),
                            decoration: BoxDecoration(
                              color: hasLocationData
                                  ? const Color(0xFF00FF4D)
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Call',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.primaryBold.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Height10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: hasLocationData ? _launchLocation : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: hasLocationData
                                    ? const Color(0xFFE8F5FF)
                                    : Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                hasLocationData ? 'Open Maps' : 'No Location',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.primaryBold.copyWith(
                                  color: const Color(0xFF426FFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}