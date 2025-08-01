# Events Feature Implementation

This document outlines the implementation of the community events feature that replaces the leaderboard in the bottom navigation.

## Overview

The events feature allows users to:
- Browse upcoming community events in a scrollable list
- Join events by marking them as "going" 
- Automatically sync joined events to their personal Syncfusion calendar
- View event details including date, time, location, organizer, and attendance

## Files Added/Modified

### New Files Created:
1. **`lib/models/community_event.dart`** - Data model for community events
2. **`lib/providers/community_events_provider.dart`** - Provider for managing community events state
3. **`lib/screens/events_screen.dart`** - Main events screen with scrollable list UI
4. **`supabase_events_table.sql`** - Database schema for Supabase tables
5. **`test/community_event_test.dart`** - Unit tests for the community event model

### Modified Files:
1. **`lib/main.dart`** - Added CommunityEventsProvider to the provider tree
2. **`lib/app_entry.dart`** - Replaced leaderboard with Events in bottom navigation
3. **`test/widget_test.dart`** - Updated basic widget test

## Database Schema

Execute the SQL in `supabase_events_table.sql` in your Supabase dashboard to create:

### Tables:
- **`community_events`** - Stores community event information
- **`event_attendees`** - Junction table tracking which users are attending which events

### Key Features:
- Row Level Security (RLS) enabled
- Proper foreign key relationships
- Sample data included
- Optimized indexes for performance

## Usage

### Setting up Supabase
1. Run the SQL script in your Supabase dashboard
2. Ensure your app has the correct Supabase credentials (already configured in main.dart)

### Features Available
1. **Browse Events**: Users see a scrollable list of upcoming community events
2. **Join Events**: Tap "Join" to mark attendance and add to personal calendar
3. **Leave Events**: Tap "Going" to leave an event and remove from calendar
4. **Event Details**: Each card shows comprehensive event information
5. **Capacity Tracking**: Visual progress bars show attendance vs. capacity

### Integration with Calendar
When a user joins an event:
- A new personal calendar event is created automatically
- The event appears in the existing Syncfusion calendar
- Event details include location and organizer information
- Uses a distinct green color to identify community events

## Testing

Run the unit tests:
```bash
flutter test test/community_event_test.dart
```

## Code Structure

### CommunityEvent Model
- Comprehensive data model with all event properties
- Helper methods for checking event status (upcoming, full, etc.)
- JSON serialization/deserialization

### CommunityEventsProvider
- Manages state for all community events
- Handles loading from Supabase
- Manages join/leave functionality
- Integrates with personal calendar via EventProvider

### EventsScreen
- Modern card-based UI
- Pull-to-refresh functionality
- Error handling with retry capability
- Responsive design for different screen sizes

## Implementation Notes

### Minimal Changes Approach
- Leveraged existing event system for calendar integration
- Reused existing UI components and theme system
- Maintained consistency with app's design patterns

### Error Handling
- Comprehensive error handling throughout
- User-friendly error messages
- Graceful fallbacks for offline scenarios

### Performance Considerations
- Efficient Supabase queries
- Proper state management
- Optimized list rendering

## Future Enhancements

Potential improvements for future iterations:
1. Event search and filtering
2. Event categories
3. Push notifications for events
4. Event creation by users
5. Event sharing functionality
6. Calendar view of events
7. Event reminders

## Dependencies

No new dependencies were added. The implementation uses existing packages:
- `supabase_flutter` for backend communication
- `provider` for state management
- `syncfusion_flutter_calendar` for calendar integration
- `intl` for date formatting
- Standard Flutter widgets for UI