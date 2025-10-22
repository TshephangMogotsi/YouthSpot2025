# Theme Mode Feature - Visual Mockup

## Before (Old Design)
The app previously had a simple toggle switch for Day/Night mode:

```
┌──────────────────────────────────────┐
│  Account                             │
│                                      │
│  [Settings Items...]                 │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  [☀️] Day Mode      [●-----]  │ │ ← Toggle Switch
│  └────────────────────────────────┘ │
│                                      │
│  [Logout Button]                     │
└──────────────────────────────────────┘
```

Issues with old design:
- Only two options (Day or Night)
- No way to follow device settings
- User has to manually change when device changes

## After (New Design)
The app now has three selectable options with clear visual indicators:

```
┌──────────────────────────────────────┐
│  Account                             │
│                                      │
│  [Settings Items...]                 │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  (☀️) Day Mode          ✓     │ │ ← Selected (Yellow highlight)
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  (🌙) Night Mode        ○     │ │ ← Not selected (Grey)
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  (⚙️) System Default    ○     │ │ ← New option!
│  └────────────────────────────────┘ │
│                                      │
│  [Logout Button]                     │
└──────────────────────────────────────┘
```

Features of new design:
✓ Three distinct options
✓ "System Default" follows device theme automatically
✓ Clear visual selection indicator
✓ Icon changes based on mode:
  - Day Mode: Bright sun icon
  - Night Mode: Moon icon
  - System Default: Auto brightness icon
✓ Selected option has yellow circular background + checkmark
✓ Tap any option to switch immediately

## Light Theme View
```
┌────────────────────────────────────────┐
│  Account                    [Light BG] │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  ┌──┐                           │ │
│  │  │🌞│ Day Mode              ●  │ │ ← Yellow + Checkmark
│  │  └──┘                           │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  ┌──┐                           │ │
│  │  │🌙│ Night Mode            ○  │ │ ← Grey + Empty
│  │  └──┘                           │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  ┌──┐                           │ │
│  │  │⚙️│ System Default        ○  │ │
│  │  └──┘                           │ │
│  └──────────────────────────────────┘ │
└────────────────────────────────────────┘
```

## Dark Theme View
```
┌────────────────────────────────────────┐
│  Account                     [Dark BG] │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  ┌──┐                           │ │
│  │  │🌞│ Day Mode              ○  │ │ ← Grey + Empty
│  │  └──┘                           │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  ┌──┐                           │ │
│  │  │🌙│ Night Mode            ●  │ │ ← Yellow + Checkmark
│  │  └──┘                           │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  ┌──┐                           │ │
│  │  │⚙️│ System Default        ○  │ │
│  │  └──┘                           │ │
│  └──────────────────────────────────┘ │
└────────────────────────────────────────┘
```

## System Default Behavior

When "System Default" is selected:

**Device in Light Mode:**
```
Phone Settings: ☀️ Light Mode
    ↓
YouthSpot App: Shows Light Theme
```

**Device in Dark Mode:**
```
Phone Settings: 🌙 Dark Mode
    ↓
YouthSpot App: Shows Dark Theme
```

**User Changes Device Theme:**
```
1. User opens phone settings
2. Changes from Light to Dark mode
3. YouthSpot app AUTOMATICALLY switches
4. No app restart needed!
```

## Interaction Flow

```
User Taps "Night Mode"
    ↓
1. Theme changes immediately to dark
    ↓
2. Yellow highlight moves to "Night Mode"
    ↓
3. Checkmark appears next to "Night Mode"
    ↓
4. Preference saved to storage
    ↓
5. On next app launch, dark theme loads automatically
```

## Color Scheme

**Selected Option:**
- Icon background: Light yellow (`Colors.yellow.withOpacity(0.2)`)
- Icon color: Dark yellow (`Colors.yellow.shade700`)
- Check circle: Yellow fill (`Colors.yellow`)
- Check icon: White (`Colors.white`)

**Unselected Option:**
- Icon background: Light grey (`Colors.grey.withOpacity(0.1)`)
- Icon color: Grey (`Colors.grey.shade600`)
- Check circle: Grey border only (`Colors.grey.shade400`)
- Check icon: None

## Icons Used

1. **Day Mode**: `Icons.wb_sunny` - Material's sunny/sun icon
2. **Night Mode**: `Icons.nightlight_round` - Material's moon/night icon
3. **System Default**: `Icons.brightness_auto` - Material's auto brightness icon
4. **Check Mark**: `Icons.check` - Standard checkmark

## Responsive Design

The layout uses:
- `PrimaryContainer` - Consistent container styling
- `BorderRadius.circular(25)` - Rounded corners
- Symmetric padding - Equal spacing
- Row with spaceBetween - Left-aligned content, right-aligned indicator
- Consistent 40x40 icon size
- 20px spacing between icon and text

## Accessibility

✓ Clear visual indicators (color + icon + text)
✓ Large tap targets (full row is tappable)
✓ High contrast in both light and dark modes
✓ Semantic structure with proper widget hierarchy
✓ Works with screen readers (Material widgets)
