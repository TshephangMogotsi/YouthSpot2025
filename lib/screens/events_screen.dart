import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/community_events_provider.dart';
import '../providers/event_provider.dart';
import '../models/community_event.dart';
import '../config/constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';
import '../global_widgets/custom_app_bar.dart';
import '../global_widgets/primary_padding.dart';

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
      context.read<CommunityEventsProvider>().loadCommunityEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return Scaffold(
          backgroundColor:
              theme == ThemeMode.dark ? darkmodeLight : backgroundColorLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(
              context: context,
              isHomePage: false,
            ),
          ),
          body: Consumer<CommunityEventsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: kSSIorange),
                );
              }

              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme == ThemeMode.dark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          provider.clearError();
                          provider.loadCommunityEvents();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final upcomingEvents = provider.upcomingEvents;

              return Column(
                children: [
                  PrimaryPadding(
                    child: Row(
                      children: [
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme == ThemeMode.dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => provider.loadCommunityEvents(),
                          icon: Icon(
                            Icons.refresh,
                            color: theme == ThemeMode.dark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: upcomingEvents.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No upcoming events',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: theme == ThemeMode.dark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check back later for new events!',
                                  style: TextStyle(
                                    color: theme == ThemeMode.dark ? Colors.white54 : Colors.black38,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => provider.loadCommunityEvents(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kSSIorange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Refresh Events'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: provider.loadCommunityEvents,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: upcomingEvents.length,
                              itemBuilder: (context, index) {
                                final event = upcomingEvents[index];
                                return EventCard(
                                  event: event,
                                  theme: theme,
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final CommunityEvent event;
  final ThemeMode theme;

  const EventCard({
    super.key,
    required this.event,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: theme == ThemeMode.dark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme == ThemeMode.dark ? Colors.white70 : Colors.black54,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Consumer2<CommunityEventsProvider, EventProvider>(
                  builder: (context, communityProvider, eventProvider, child) {
                    return ElevatedButton(
                      onPressed: event.isFull && !event.isUserAttending
                          ? null
                          : () async {
                              if (event.isUserAttending) {
                                await communityProvider.leaveEvent(event.id, eventProvider);
                              } else {
                                await communityProvider.joinEvent(event.id, eventProvider);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: event.isUserAttending 
                            ? Colors.orange 
                            : event.isFull 
                                ? Colors.grey 
                                : kSSIorange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        event.isUserAttending 
                            ? 'Going' 
                            : event.isFull 
                                ? 'Full' 
                                : 'Join',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  '${dateFormat.format(event.eventDate)} • ${timeFormat.format(event.eventDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
            if (event.location != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location!,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (event.organizer != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Organized by ${event.organizer}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
            if (event.maxAttendees != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.group,
                    size: 16,
                    color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${event.currentAttendees} / ${event.maxAttendees} attendees',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme == ThemeMode.dark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: event.currentAttendees / event.maxAttendees!,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        event.isFull ? Colors.red : kSSIorange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}