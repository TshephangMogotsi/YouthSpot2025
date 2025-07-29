import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/models/event_model.dart';
import '../../../../config/constants.dart';
import '../../../../providers/event_provider.dart';
import '../../../../services/services_locator.dart';
import 'event_editing_page.dart';

class EventDetailsDialog extends StatelessWidget {
  final Event event;

  const EventDetailsDialog({super.key, required this.event});

  String formatDateTime(DateTime dateTime) {
    // Format the date and time as 'MMM dd, yyyy, HH:mm'
    return DateFormat('MMM dd, yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return AlertDialog(
          backgroundColor: theme == ThemeMode.dark ? darkmodeFore : backgroundColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainBorderRadius),
          ),
          title: Text(
            event.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(event.description),
              const SizedBox(height: 10),
              const Text(
                'From:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(formatDateTime(event.from)), // Properly formatted
              const SizedBox(height: 10),
              const Text(
                'To:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(formatDateTime(event.to)), // Properly formatted
              const SizedBox(height: 10),
              const Text(
                'All Day Event:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(event.isAllDay ? 'Yes' : 'No'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventEditingPage(event: event),
                  ),
                );
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () async {
                final provider = Provider.of<EventProvider>(context, listen: false);
                await provider.deleteEvent(event);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      }
    );
  }
}