import 'package:flutter/material.dart';
import 'package:youthspot/db/models/service_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceListItem extends StatelessWidget {
  final Service service;

  const ServiceListItem({super.key, required this.service});

  Future<void> _launchMaps(double? lat, double? lon) async {
    if (lat == null || lon == null) return;
    final uri = Uri.parse('geo:$lat,$lon');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not launch $uri';
    }
  }

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
                if (service.latitude != null && service.longitude != null)
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: () => _launchMaps(service.latitude, service.longitude),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
