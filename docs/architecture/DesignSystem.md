# Pilot Design System

## Philosophy

The Pilot Design System is built to be:
- **Native to Apple**: Utilizing SwiftUI, Dynamic Type, and SF Symbols.
- **Minimal and Premium**: Leveraging whitespace, subtle gradients, and sparse glassmorphism to create depth.
- **Calm and Friendly**: Employing smooth spring animations and restrained haptics.
- **Adaptive**: Supporting Light/Dark modes, High Contrast, and VoiceOver inherently.

## Design Tokens

### Colors
Defined in `ColorSystem.swift` using code-based dynamic `UIColor` trait resolution to avoid merge conflicts in `.xcassets`.
- **Background**: Almost black in dark mode, off-white in light mode.
- **Surface**: Slightly elevated gray in dark mode, pure white in light mode.
- **Accent**: Vibrant Blue for primary interactions.
- **Semantic**: Success (Green), Warning (Yellow), Error (Red).

### Typography
Defined in `Typography.swift` leveraging Apple's San Francisco rounded and default variants with scaled Dynamic Type standard weights:
- `pilotLargeTitle`, `pilotTitle`, `pilotHeadline`, `pilotBody`, `pilotCaption`, `pilotFootnote`.

### Spacing
Defined in `Spacing.swift`:
- `xs` (4), `sm` (8), `md` (12), `lg` (16), `xl` (24), `xxl` (32).

### Animation & Haptics
Defined in `AnimationSystem.swift` and `HapticsManager.swift`:
- `fastSpring` (0.2s), `mediumSpring` (0.35s), `slowFade` (0.4s).
- Haptics utilize `UISelectionFeedbackGenerator` and `UIImpactFeedbackGenerator`.

## UI Components

### `PilotButton`
Supports variants: `.primary`, `.secondary`, `.ghost`, `.destructive`. Includes built-in scaling animations on press and loading states (`isLoading`).

### `PilotCard`
A versatile container with subtle shadows that deepen in dark mode, supporting optional `GlassView` backgrounds.

### `PilotTextField`
Text input with built-in focus styling, error message support, and optional secure text entry.

### `PilotListRow`
Consistent layout for vertical lists, supporting leading icons, titles, subtitles, and trailing accessory views.

### `PilotBottomBar`
A custom, floating-style bottom navigation bar adhering to Pilot's premium aesthetics.

### `PilotIcon`
Wrapper for `Image(systemName:)` enforcing standardized weight and sizing configurations.
