# Account Screen - Theme Section Mockup

## Visual Representation

```
╔════════════════════════════════════════════════════════╗
║                    Account                             ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  ┌─────────────────────────────────────────────────┐  ║
║  │  👤   My Profile                                │  ║
║  │       John Doe                                  │  ║
║  └─────────────────────────────────────────────────┘  ║
║                                                        ║
║  ┌─────────────────────────────────────────────────┐  ║
║  │  ⚙️   Account Settings                          │  ║
║  └─────────────────────────────────────────────────┘  ║
║                                                        ║
║  ┌─────────────────────────────────────────────────┐  ║
║  │  📄   Terms and Conditions                      │  ║
║  └─────────────────────────────────────────────────┘  ║
║                                                        ║
║  ┌─────────────────────────────────────────────────┐  ║
║  │  ℹ️   Description                               │  ║
║  └─────────────────────────────────────────────────┘  ║
║                                                        ║
║  ┌─────────────────────────────────────────────────┐  ║
║  │  ☀️  Theme                                      │  ║
║  │                                                  │  ║
║  │  ┌──────────────────────────────────────────┐  │  ║
║  │  │  ○  Light                                 │  │  ║
║  │  └──────────────────────────────────────────┘  │  ║
║  │                                                  │  ║
║  │  ┌──────────────────────────────────────────┐  │  ║
║  │  │  ◉  Dark                                  │  │  ║  ← SELECTED
║  │  └──────────────────────────────────────────┘  │  ║    (highlighted)
║  │                                                  │  ║
║  │  ┌──────────────────────────────────────────┐  │  ║
║  │  │  ○  Device Preferences                    │  │  ║
║  │  └──────────────────────────────────────────┘  │  ║
║  │                                                  │  ║
║  └─────────────────────────────────────────────────┘  ║
║                                                        ║
║                                                        ║
║  ┌─────────────────────────────────────────────────┐  ║
║  │                   Logout                        │  ║
║  └─────────────────────────────────────────────────┘  ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

## States

### State 1: Light Mode Selected (Light Theme Active)
```
┌──────────────────────────────────────────┐
│  ☀️  Theme                              │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  ◉  Light                         │  │  ← Selected & Highlighted
│  └──────────────────────────────────┘  │
│                                         │
│  │  ○  Dark                           │  │
│                                         │
│  │  ○  Device Preferences             │  │
│                                         │
└──────────────────────────────────────────┘

Background: White/Light colors
Text: Dark colors
Status bar: Light with dark icons
```

### State 2: Dark Mode Selected (Dark Theme Active)
```
┌──────────────────────────────────────────┐
│  ☀️  Theme                              │
│                                         │
│  │  ○  Light                           │  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  ◉  Dark                          │  │  ← Selected & Highlighted
│  └──────────────────────────────────┘  │
│                                         │
│  │  ○  Device Preferences             │  │
│                                         │
└──────────────────────────────────────────┘

Background: Dark/Black colors
Text: Light colors
Status bar: Dark with light icons
```

### State 3: Device Preferences Selected (Follows System)
```
┌──────────────────────────────────────────┐
│  ☀️  Theme                              │
│                                         │
│  │  ○  Light                           │  │
│                                         │
│  │  ○  Dark                            │  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  ◉  Device Preferences            │  │  ← Selected & Highlighted
│  └──────────────────────────────────┘  │
│                                         │
└──────────────────────────────────────────┘

Theme: Matches device settings
- If device is in Dark Mode → Dark theme shown
- If device is in Light Mode → Light theme shown
- Updates automatically when device theme changes
```

## Interaction Flow

### Tap on "Light"
```
Before:           After:
○ Light    →      ◉ Light
◉ Dark            ○ Dark
○ Device          ○ Device

Action: App switches to light theme immediately
Result: Theme saved as 'light' in SharedPreferences
```

### Tap on "Dark"
```
Before:           After:
◉ Light           ○ Light
○ Dark     →      ◉ Dark
○ Device          ○ Device

Action: App switches to dark theme immediately
Result: Theme saved as 'dark' in SharedPreferences
```

### Tap on "Device Preferences"
```
Before:           After:
○ Light           ○ Light
◉ Dark     →      ○ Dark
○ Device          ◉ Device

Action: App switches to system theme mode
Result: Theme saved as 'system' in SharedPreferences
Effect: App now follows device theme settings
```

## Technical Details

### Widget Structure
```
PrimaryContainer
└── ListenableBuilder (listens to ThemeManager)
    └── Column
        ├── Header Row (Icon + "Theme" text)
        └── Options (3x _ThemeOption widgets)
            ├── _ThemeOption(Light)
            ├── _ThemeOption(Dark)
            └── _ThemeOption(Device Preferences)

_ThemeOption Widget:
└── GestureDetector (onTap: setThemePreference)
    └── Container (background color if selected)
        └── Row
            ├── Icon (radio_button_checked or unchecked)
            └── Text (title, bold if selected)
```

### Color Scheme

#### Light Theme (Selected option)
- Background: primaryContainer with 0.3 opacity
- Radio button: Filled circle (Icons.radio_button_checked)
- Text: FontWeight.w600 (semi-bold)

#### Dark Theme (Selected option)
- Background: primaryContainer with 0.3 opacity (adapts to dark)
- Radio button: Filled circle (Icons.radio_button_checked)
- Text: FontWeight.w600 (semi-bold)

#### Unselected options
- Background: Transparent
- Radio button: Empty circle (Icons.radio_button_unchecked)
- Text: FontWeight.w400 (regular)

## Behavior Examples

### Example 1: User has iPhone in Auto Dark Mode
1. Morning (6 AM): Phone switches to Light Mode
   - If "Device Preferences" is selected: App shows Light theme ☀️
2. Evening (8 PM): Phone switches to Dark Mode
   - If "Device Preferences" is selected: App shows Dark theme 🌙
3. User can override by selecting "Light" or "Dark" explicitly

### Example 2: User prefers always Dark
1. User selects "Dark" option
2. App stays in Dark mode all day
3. Even if phone is in Light mode, app remains Dark
4. User enjoys consistent experience

### Example 3: First Time User
1. Opens app for first time
2. No saved preference exists
3. App defaults to "Device Preferences"
4. App matches phone's current theme
5. User can change if desired

## Accessibility

- Radio buttons are standard Material icons (clearly visible)
- Selected option has higher font weight for visual distinction
- Highlighted background provides additional visual cue
- Tap targets are large enough (full option container is tappable)
- Works with screen readers (labeled appropriately)
- Respects system text scaling preferences

## Edge Cases Handled

1. **SharedPreferences fails**: Falls back to system theme
2. **Invalid saved value**: Defaults to system theme
3. **First app launch**: Defaults to system theme
4. **Device doesn't support dark mode**: Light mode used
5. **App update from old version**: Existing toggle state migrated
