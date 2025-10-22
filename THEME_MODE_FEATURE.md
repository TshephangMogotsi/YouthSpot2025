# Theme Mode Feature Documentation

## Overview
This document describes the theme mode feature implementation that allows users to choose between Day Mode, Night Mode, and System Default modes in the YouthSpot app.

## Features

### Theme Modes
The app now supports three theme modes:

1. **Day Mode** - Forces the app to use light theme regardless of system settings
2. **Night Mode** - Forces the app to use dark theme regardless of system settings  
3. **System Default** - Automatically follows the device's system theme setting (recommended)

### User Interface
The theme mode selector is located in the Account section of the app. Users can select their preferred theme by tapping on one of the three options:

- **Day Mode**: Displays with a sun icon (☀️)
- **Night Mode**: Displays with a moon icon (🌙)
- **System Default**: Displays with an auto brightness icon (⚙️)

The selected option is highlighted with:
- A yellow circular background behind the icon
- A yellow checkmark indicator on the right side

#### Visual Layout
```
┌─────────────────────────────────────────┐
│  Account                                │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [👤] My Profile               │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [⚙️] Account Settings          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ... (other settings) ...              │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [☀️] Day Mode            [✓]   │   │ ← Selected
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [🌙] Night Mode          [ ]   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [⚙️] System Default      [ ]   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │         Logout                  │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

### Persistence
The user's theme preference is automatically saved using SharedPreferences and will be restored when the app is restarted.

## Technical Implementation

### Files Modified

1. **lib/config/theme_manager.dart**
   - Added support for `ThemeMode.system`
   - Implemented SharedPreferences for theme persistence
   - Added `setThemeMode()` method for setting theme
   - Added `_loadThemePreference()` for loading saved theme
   - Added `_saveThemePreference()` for persisting theme choice
   - Kept `toggleTheme()` for backward compatibility

2. **lib/screens/Account/account.dart**
   - Replaced `ThemeModeListTile` toggle widget with `ThemeModeSelector`
   - Added `_ThemeModeOption` widget for individual theme options
   - Changed UI from toggle switch to radio-style selection
   - Used Material icons for better visual distinction

3. **test/theme_manager_test.dart** (New)
   - Comprehensive unit tests for ThemeManager
   - Tests for theme mode setting and persistence
   - Tests for loading saved preferences
   - Tests for backward compatibility

### How It Works

1. **Initialization**: When `ThemeManager` is created, it initializes with `ThemeMode.system` as the default and attempts to load any saved preference from SharedPreferences.

2. **User Selection**: When a user taps on a theme option, the `setThemeMode()` method is called with the selected mode.

3. **Persistence**: The selected mode is immediately saved to SharedPreferences with the key `'theme_mode_preference'`.

4. **Restoration**: On app restart, the saved preference is loaded during ThemeManager initialization.

5. **Theme Application**: The MaterialApp's `themeMode` property is bound to the ThemeManager's `themeMode` ValueNotifier, which automatically updates the UI when the theme changes.

### System Default Behavior

When "System Default" is selected:
- On devices with light mode enabled: App uses light theme
- On devices with dark mode enabled: App uses dark theme
- Theme automatically changes when device theme changes (no app restart required)

## Benefits

1. **User Choice**: Users can choose the theme that works best for them
2. **Battery Saving**: Dark mode can help save battery on OLED screens
3. **Accessibility**: Better visibility in different lighting conditions
4. **System Integration**: Respects user's system-wide theme preference
5. **Persistence**: User's choice is remembered across app sessions

## Usage

### For Users
1. Open the app
2. Navigate to the Account section
3. Scroll to find the theme options
4. Tap on your preferred theme mode (Day Mode, Night Mode, or System Default)
5. The theme will change immediately and your choice will be saved

### For Developers

To programmatically set the theme:

```dart
final themeManager = getIt<ThemeManager>();

// Set to light mode
await themeManager.setThemeMode(ThemeMode.light);

// Set to dark mode
await themeManager.setThemeMode(ThemeMode.dark);

// Set to system default
await themeManager.setThemeMode(ThemeMode.system);
```

To listen to theme changes:

```dart
final themeManager = getIt<ThemeManager>();
themeManager.addListener(() {
  print('Theme changed to: ${themeManager.themeMode.value}');
});
```

## Testing

Run the theme manager tests:

```bash
flutter test test/theme_manager_test.dart
```

The test suite includes:
- Default initialization tests
- Theme mode setting tests
- Persistence tests
- Loading saved preference tests
- Backward compatibility tests
- Listener notification tests

## Future Enhancements

Possible future improvements:
- Schedule-based theme switching (e.g., dark mode at night)
- Custom theme colors
- Per-section theme overrides
- Theme transition animations
