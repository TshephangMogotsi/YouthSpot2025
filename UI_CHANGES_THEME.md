# UI Changes for Theme Preferences

## Before (Toggle Switch)
```
┌─────────────────────────────────────────┐
│  ☀️  Day Mode              [⚪️    ]   │
│                                         │
└─────────────────────────────────────────┘
```
- Single toggle switch
- Only two states: Light/Dark
- No device preference option

## After (Radio Buttons)
```
┌─────────────────────────────────────────┐
│  ☀️  Theme                              │
│                                         │
│  ○  Light                               │
│  ◉  Dark                                │
│  ○  Device Preferences                  │
│                                         │
└─────────────────────────────────────────┘
```
- Three clear options with radio buttons
- ◉ = Selected option (filled circle)
- ○ = Unselected option (empty circle)
- Selected option has highlighted background

## User Flow

### Scenario 1: User wants dark mode always
1. User taps "Dark" option
2. Radio button fills immediately
3. App switches to dark theme
4. Preference saved to device
5. App stays in dark mode even if device is in light mode

### Scenario 2: User wants to follow device settings
1. User taps "Device Preferences" option
2. Radio button fills immediately
3. App checks device theme:
   - If device is in dark mode → App uses dark theme
   - If device is in light mode → App uses light theme
4. When user changes device theme settings:
   - App automatically updates to match
   - No need to reopen the app

### Scenario 3: User prefers light mode
1. User taps "Light" option
2. Radio button fills immediately
3. App switches to light theme
4. App stays in light mode regardless of device settings

## Technical Implementation

### Theme Detection (Device Preferences Mode)
When "Device Preferences" is selected:
- Flutter's `ThemeMode.system` is used
- MaterialApp automatically listens to device theme changes
- Uses `MediaQuery.platformBrightnessOf(context)`
- Updates happen in real-time when device theme changes

### Theme Persistence
- Uses SharedPreferences with key: `theme_preference`
- Values: 'light', 'dark', or 'system'
- Loaded on app startup before UI renders
- Ensures consistent experience across app sessions

## Benefits

1. **User Control**: Three clear options instead of binary toggle
2. **Device Integration**: Respects system preferences when desired
3. **Flexibility**: Users can override device settings if needed
4. **Persistence**: Choice remembered across app restarts
5. **Accessibility**: Radio buttons are more accessible than toggles
6. **Clarity**: Labels clearly describe what each option does

## Code Structure

```dart
ThemePreference enum:
├── light    → Forces light theme
├── dark     → Forces dark theme
└── system   → Follows device preferences

ThemeManager:
├── themeMode (ValueNotifier<ThemeMode>)
├── _themePreference (ThemePreference)
├── setThemePreference() → Changes theme + saves to SharedPreferences
├── _loadThemePreference() → Loads from SharedPreferences on init
└── toggleTheme() → Backward compatibility
```

## Visual Design

The new Theme section in Account screen:
- Container with rounded corners (25px radius)
- Padding: 12px vertical, 20px horizontal
- Icon: Day/Sun icon (40x40)
- Title: "Theme" in Onest font, 18px, semi-bold
- Options list:
  - Each option in a sub-container
  - 8px spacing between options
  - Padding: 8px vertical, 12px horizontal
  - Selected option: Subtle background color
  - Radio icon + label in a row
  - 12px spacing between icon and text

The design maintains consistency with other settings tiles while providing a clearer interface for theme selection.
