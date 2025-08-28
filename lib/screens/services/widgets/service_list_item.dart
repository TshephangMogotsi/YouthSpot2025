import 'package:flutter/material.dart';
import 'package:youthspot/db/models/service_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ServiceListItem extends StatelessWidget {
  final Service service;

  const ServiceListItem({super.key, required this.service});

  Future<void> _launchLocation() async {
    if (service.locationUrl != null && service.locationUrl!.isNotEmpty) {
      // Use URL if available
      final uri = Uri.parse(service.locationUrl!);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Fallback to coordinates if URL fails
        if (service.latitude != null && service.longitude != null) {
          MapsLauncher.launchCoordinates(service.latitude!, service.longitude!);
        }
      }
    } else if (service.latitude != null && service.longitude != null) {
      // Use coordinates if URL not available
      MapsLauncher.launchCoordinates(service.latitude!, service.longitude!);
    }
  }

  bool get hasLocationData => 
      (service.locationUrl != null && service.locationUrl!.isNotEmpty) || 
      (service.latitude != null && service.longitude != null);

  Future<void> _launchDialer(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(uri);
    } catch (e) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(service.name),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (service.location != null) Text('Location: ${service.location}'),
                if (service.contacts != null && service.contacts!.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: service.contacts!
                        .map((contact) => ActionChip(
                              label: Text(contact),
                              onPressed: () => _launchDialer(contact),
                            ))
                        .toList(),
                  ),
                if (service.type != null) Text('Type: ${service.type}'),
                if (hasLocationData)
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: _launchLocation,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
