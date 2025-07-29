import 'package:flutter/material.dart';

import '../../../../db/models/event_model.dart';
import 'event_editing_page.dart';

class EventViewingPage extends StatelessWidget {
  const EventViewingPage({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => EventEditingPage(event: event),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => EventEditingPage(event: event),
              ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          buildDateTime(event),
          Text(
            event.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            event.description,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return const Column(
      children: [
        // buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        // if (!event.isAllDay) buildDate('To', event.to)
      ],
    );
  }
}
