# Events Feature - UI Preview

## Bottom Navigation Changes

**Before:**
```
[ Home ] [ Resources ] [ Services ] [ Account ]
```

**After:**
```
[ Home ] [ Resources ] [ Services ] [ Events ] [ Account ]
```

The leaderboard tab has been replaced with an Events tab that uses a calendar icon.

## Events Screen Layout

```
┌─────────────────────────────────┐
│ YouthSpot Header                │
├─────────────────────────────────┤
│ Upcoming Events            🔄   │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ Youth Wellness Workshop     │ │
│ │ Interactive workshop focus… │ │
│ │                       [Join]│ │
│ │ 📅 Feb 15, 2025 • 10:00 AM │ │
│ │ 📍 Community Center Hall A │ │
│ │ 👤 Organized by YouthSpot   │ │
│ │ 👥 ███████░░░░ 10/50        │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Career Development Seminar  │ │
│ │ Learn about career opport…  │ │
│ │                      [Going]│ │
│ │ 📅 Feb 20, 2025 • 2:00 PM  │ │
│ │ 📍 Business Center          │ │
│ │ 👤 Organized by Career Team │ │
│ │ 👥 ████████░░ 15/30         │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Mental Health Support Group │ │
│ │ Safe space for youth to…    │ │
│ │                       [Full]│ │
│ │ 📅 Feb 25, 2025 • 6:00 PM  │ │
│ │ 📍 Wellness Center Room B   │ │
│ │ 👤 Organized by Therapists  │ │
│ │ 👥 ██████████ 20/20         │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

## Key Features Demonstrated

### Event Card States:
1. **Available Events** - Shows "Join" button in orange
2. **Joined Events** - Shows "Going" button (user has joined)
3. **Full Events** - Shows "Full" button in grey (disabled)

### Information Displayed:
- Event title and description
- Date and time with proper formatting
- Location with location icon
- Organizer information
- Attendance progress bar and count
- Visual capacity indicators

### Interactions:
- **Join Event**: Adds event to personal calendar with green color
- **Leave Event**: Removes event from personal calendar
- **Pull to Refresh**: Reloads events from Supabase
- **Scroll**: Browse through all upcoming events

### Integration Points:
- **Calendar Sync**: Joined events appear in existing Syncfusion calendar
- **Theme Support**: Respects dark/light theme settings
- **Navigation**: Seamlessly integrated into bottom navigation
- **Error Handling**: Shows helpful error messages with retry options

## Calendar Integration Example

When user taps "Join" on "Youth Wellness Workshop":

1. Event gets added to `event_attendees` table in Supabase
2. Attendance count updates in UI and database
3. Personal calendar event created with:
   - Title: "Youth Wellness Workshop" 
   - Description: "Interactive workshop focusing on mental health and wellness strategies for young adults.\n\nLocation: Community Center Hall A\nOrganizer: YouthSpot Team"
   - Start: Feb 15, 2025 10:00 AM
   - End: Feb 15, 2025 4:00 PM
   - Color: Green (indicates community event)

## Database Structure

```sql
community_events
├── id (UUID, Primary Key)
├── title (VARCHAR)
├── description (TEXT)
├── event_date (TIMESTAMP)
├── end_date (TIMESTAMP)
├── location (VARCHAR)
├── organizer (VARCHAR)
├── max_attendees (INTEGER)
├── current_attendees (INTEGER)
└── is_active (BOOLEAN)

event_attendees
├── id (UUID, Primary Key)
├── event_id (UUID, Foreign Key)
├── user_id (UUID, Foreign Key)
└── joined_at (TIMESTAMP)
```

This implementation provides a complete events system that integrates seamlessly with the existing app architecture while providing modern, user-friendly functionality.