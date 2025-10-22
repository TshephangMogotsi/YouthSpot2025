# Device Theme Preferences Feature

## Overview
The YouthSpot app now supports device theme preferences, allowing users to choose between three theme modes:
- **Light Mode**: Forces the app to use light theme regardless of device settings
- **Dark Mode**: Forces the app to use dark theme regardless of device settings  
- **Device Preferences**: Automatically adapts to the device's system theme settings

## Implementation Details

### ThemeManager Updates
The `ThemeManager` class has been enhanced with:
1. **ThemePreference enum**: Three options (light, dark, system)
2. **Persistence**: Uses SharedPreferences to save user's theme choice
3. **Auto-load**: Loads saved preference on app startup
4. **Default**: Defaults to system theme if no preference is saved

### UI Changes
The Account screen now displays:
- A "Theme" section with three radio button options
- Visual feedback showing the currently selected theme
- Instant theme switching when user selects an option

### How It Works

#### When user selects "Device Preferences":
1. ThemeManager sets `ThemeMode.system`
2. Flutter's MaterialApp automatically responds to device theme changes
3. App theme updates when device switches between light/dark mode
4. Preference is saved to SharedPreferences

#### When user selects "Light" or "Dark":
1. ThemeManager sets fixed ThemeMode (light or dark)
2. App ignores device theme settings
3. Theme remains consistent regardless of device changes
4. Preference is saved to SharedPreferences

### Code Changes

#### Files Modified:
- `lib/config/theme_manager.dart` - Added ThemePreference enum and persistence logic
- `lib/screens/Account/account.dart` - Replaced toggle with radio options UI

#### Key Features:
- **Backward compatible**: Old toggle behavior still works via `toggleTheme()` method
- **Persistent**: Theme choice survives app restarts
- **Responsive**: Device theme changes reflected immediately when in System mode
- **Error handling**: Gracefully handles SharedPreferences failures

## User Experience

1. User navigates to Account screen
2. Scrolls to "Theme" section
3. Sees three options with current selection marked
4. Taps desired option
5. Theme changes immediately
6. Choice is remembered for future app launches

## Testing

Run the theme manager tests:
```bash
flutter test test/theme_manager_test.dart
```

Tests verify:
- Default initialization to system theme
- Theme preference switching
- Persistence to SharedPreferences
- Loading saved preferences
- Backward compatibility with toggle method

## Future Enhancements

Potential improvements:
- Add theme preview animations during selection
- Support scheduled theme switching (e.g., dark mode at night)
- Custom theme colors based on user preference
- Theme transition animations
