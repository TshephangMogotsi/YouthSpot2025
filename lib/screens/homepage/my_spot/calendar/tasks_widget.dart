import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../providers/event_provider.dart';
import 'calendar_page.dart';
import 'event_viewing_page.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events found',
        ),
      );
    }

    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selected,
      appointmentBuilder: appointmentBuilder,
      headerHeight: 0,
      selectionDecoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      onTap: (details) {
        if (details.appointments == null) return;
        final event = details.appointments!.first;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventViewingPage(event: event),
          ),
        );
      },
    );
  }
}

Widget appointmentBuilder(
  BuildContext context,
  CalendarAppointmentDetails details,
) {
  final event = details.appointments.first;

  return Container(
    width: details.bounds.width,
    height: details.bounds.height,
    decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12)),
    child: Center(
      child: Text(
        event.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
