import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../global_widgets/primary_padding.dart';
import '../../models/upcoming_event.dart';
import '../../providers/upcoming_events_provider.dart';
import '../../providers/event_provider.dart';
import '../../services/services_locator.dart';
import '../../db/models/event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UpcomingEventsProvider>(context, listen: false).loadSampleEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return Scaffold(
          backgroundColor: theme == ThemeMode.dark ? darkmodeLight : backgroundColorLight,
          appBar: AppBar(
            backgroundColor: theme == ThemeMode.dark ? const Color(0xFF0A0A0A) : backgroundColorLight,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: theme == ThemeMode.dark ? Colors.white : const Color(0xFF272727),
              ),
            ),
            title: Text(
              'Upcoming Events',
              style: TextStyle(
                color: theme == ThemeMode.dark ? Colors.white : const Color(0xFF272727),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Consumer<UpcomingEventsProvider>(
            builder: (context, upcomingEventsProvider, child) {
              final events = upcomingEventsProvider.upcomingEvents;

              if (events.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kSSIorange,
                  ),
                );
              }

              return PrimaryPadding(
                child: ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(event: event);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final UpcomingEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    final upcomingEventsProvider = Provider.of<UpcomingEventsProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final isAttending = upcomingEventsProvider.isAttending(event.id);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return Container(
          decoration: BoxDecoration(
            color: theme == ThemeMode.dark ? darkmodeLight : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image placeholder
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kSSIorange.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.event,
                  size: 48,
                  color: kSSIorange,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme == ThemeMode.dark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Date and time
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: theme == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy • HH:mm').format(event.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: theme == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: theme == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Organizer
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 16,
                          color: theme == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.organizer,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Description
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme == ThemeMode.dark ? Colors.white : Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    
                    // Going button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          upcomingEventsProvider.toggleAttendance(event.id);
                          
                          if (!isAttending) {
                            // Add to calendar
                            final calendarEvent = event.toCalendarEvent();
                            
                            try {
                              await eventProvider.addEvent(calendarEvent);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Event added to your calendar!'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to add event to calendar'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('You are no longer attending this event'),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAttending ? Colors.green : kSSIorange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          isAttending ? Icons.check_circle : Icons.event_available,
                          size: 20,
                        ),
                        label: Text(
                          isAttending ? 'Going' : 'Mark as Going',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}