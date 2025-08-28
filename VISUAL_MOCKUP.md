# Visual Mockup: Before and After Shimmer Implementation

## BEFORE Implementation (Issue):
```
┌─────────────────────────────────────────────────────────────┐
│ YouthSpot App - Homepage                                    │
├─────────────────────────────────────────────────────────────┤
│ 📱 App Icon                                                 │
│                                                             │
│ Articles                                     Read All       │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │                                                         │ │
│ │               EMPTY SPACE                               │ │
│ │            (articles loading)                           │ │
│ │                                                         │ │
│ │            ❌ Strange, unprofessional                   │ │
│ │               appearance                                │ │
│ │                                                         │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ MySpot                                                      │
│ ...                                                         │
└─────────────────────────────────────────────────────────────┘
```

## AFTER Implementation (Solution):
```
┌─────────────────────────────────────────────────────────────┐
│ YouthSpot App - Homepage                                    │
├─────────────────────────────────────────────────────────────┤
│ 📱 App Icon                                                 │
│                                                             │
│ Articles                                     Read All       │
│                                                             │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │ ← Shimmer Cards        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │   (animated)           │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │                        │
│ │         │ │         │ │         │                        │
│ │ ░░░░░░░ │ │ ░░░░░░░ │ │ ░░░░░░░ │ ← Title placeholder    │
│ │ ░░░░░   │ │ ░░░░░   │ │ ░░░░░   │ ← (2 lines)           │
│ │         │ │         │ │         │                        │
│ │ ░░░ ░░░ │ │ ░░░ ░░░ │ │ ░░░ ░░░ │ ← Author & Duration    │
│ └─────────┘ └─────────┘ └─────────┘                        │
│                                                             │
│ ✅ Professional loading appearance                          │
│ ✅ User knows content is coming                             │
│ ✅ Matches actual article structure                         │
│                                                             │
│ MySpot                                                      │
│ ...                                                         │
└─────────────────────────────────────────────────────────────┘
```

## Detailed Shimmer Structure (per card):

```
┌─────────────────────────────────────────┐ ← Container with rounded corners
│ ┌─────────────────────────────────────┐ │ ← (margin: top:10, bottom:30, left:20)
│ │                                     │ │
│ │        Image Placeholder            │ │ ← 320x220px, rounded corners
│ │         (animated shimmer)          │ │   (matches CachedNetworkImage size)
│ │                                     │ │
│ │                                     │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │ ← 15px spacing
│ ┌─────────────────────────────────────┐ │
│ │ ████████████████████████████████    │ │ ← Title line 1 (full width)
│ │                                     │ │ ← 8px spacing  
│ │ ████████████████                    │ │ ← Title line 2 (200px width)
│ │                                     │ │ ← 12px spacing
│ │ ████████              ██████        │ │ ← Author (80px) + Duration (60px)
│ │                                     │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Animation Effect:
The `░` symbols represent the shimmer animation that moves from left to right across each placeholder element, creating a wave-like loading effect. The shimmer uses:

- **Light Theme**: Base color `Colors.grey[300]`, Highlight `Colors.grey[100]`
- **Dark Theme**: Base color `Colors.grey[900]`, Highlight `Colors.grey[800]`

## Transition Sequence:
1. **App Launch** → Show 3 shimmer cards immediately
2. **API Loading** → Shimmer continues for minimum 800ms
3. **Data Received** → Smooth transition to real article cards
4. **User Sees** → Professional loading experience instead of blank space

The shimmer perfectly mimics the structure of actual article cards, making the transition seamless and providing users with a clear indication of what's loading.