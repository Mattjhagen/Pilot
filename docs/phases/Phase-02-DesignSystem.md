Phase 02 – Design System

Status: Not Started

Dependencies:

* Phase 01 – Foundation

Architectural Impact:
High

⸻

Objective

Define and implement the core design system that will underpin every UI element in Pilot. The goal of this phase is to create a cohesive visual language—colors, typography, spacing, motion, and base components—so that all future screens feel like they belong together. A robust design system makes the app feel calm, intelligent and premium even before any business logic is added.

This phase focuses exclusively on visual and interaction scaffolding. No networking, no financial functionality, and no AI logic should be introduced here. Build the design system in a way that it can be applied consistently throughout the application and expanded as needed in later phases.

⸻

Read First

Review the Foundation code from Phase 01. Understand how the theming and navigation infrastructure work. Familiarize yourself with Apple’s Human Interface Guidelines for typography, color, motion, accessibility and SF Symbols. Consider how other polished Apple apps structure their design layers.

⸻

Success Criteria

By the end of Phase 02:

• A centralized theming system exists and is easy to extend.

• Color tokens are defined for light and dark modes, with primary, secondary, tertiary, success, warning, error, background and surface colors.

• A comprehensive type scale (headers, subheaders, body, caption, footnote) is defined using native Apple fonts.

• A consistent spacing scale is implemented for margins, padding and layout gaps.

• Base UI components exist: buttons (primary, secondary, ghost), card views, list rows, text fields, toggles, segmented controls, sliders, icons, chips/badges, modal sheets, bottom navigation bar.

• Components respond to environment changes (e.g. dark mode, dynamic type).

• An animation guideline exists with named durations (e.g. fast, medium, slow), curves (ease in, ease out), and transitions (fade, slide, spring). Haptic feedback rules are defined.

• All visual elements pass accessibility contrast checks and support dynamic type, VoiceOver and reduced motion.

• Preview Providers and snapshot tests demonstrate how components look across light and dark modes, with different dynamic type sizes.

• No placeholder banking data, API calls or financial logic is present.

⸻

Required Architecture

The design system should live in its own module or namespace (e.g. DesignSystem/). Use Swift package or separate folder as appropriate. The theming system should use SwiftUI environment objects or view modifiers to inject colors, fonts, spacing and other tokens. Components should be built as reusable SwiftUI views and rely on the central theme instead of hard‑coding values.

Create a Theme object that exposes color, font and spacing definitions. Use SwiftUI’s @Environment or @EnvironmentObject to access the current theme within views. Provide default themes for light and dark modes. Consider using Observable protocols or custom property wrappers to swap themes at runtime if needed.

⸻

Build

Create the following:

• Color palette: Define a set of semantic color tokens (e.g. primary, secondary, background, surface, accent, error, warning, success). Provide separate values for light and dark appearances. Use asset catalogs with color sets or define them in code.

• Typography: Define text styles (e.g. headline, title, subtitle, body, caption, footnote) using SwiftUI’s Font. Align with Apple’s San Francisco family. Support dynamic type by using relative fonts such as .title, .body, .callout, but wrap them in custom type definitions for consistency.

• Spacing system: Create a set of spacing constants (e.g. xs, sm, md, lg, xl) representing points (4, 8, 12, 16, 24…). Use these constants throughout the layout.

• Icons: Use SF Symbols wherever possible. Create a centralized wrapper for icons so that sizes and weights are consistent. Support variable symbolic fonts for dynamic weight adjustments.

• Buttons: Implement primary, secondary, ghost (borderless) and destructive button styles. Each style should handle disabled, pressed and focused states. Use appropriate haptic feedback when buttons are pressed.

• Cards: Implement a CardView with configurable corner radius, elevation/shadow, and optional glassmorphism background. Support content insets and theming.

• List Rows: Create generic row components with optional leading icon, title, subtitle and trailing chevron or toggle. Make sure row heights are consistent and adapt to dynamic type.

• Inputs: Design text fields, secure fields, toggles, sliders and segmented controls with consistent styling. Provide error and focus states. Support keyboard avoidance.

• Bottom Navigation: Design a bottom tab bar with icons and labels. Support dynamic island / top safe area considerations.

• Modals and Sheets: Build reusable sheet components with translucent backgrounds, drag indicators and configurable heights. Use glassmorphism for backgrounds where appropriate.

• Animation system: Define named animations such as fastSpring, mediumSpring, slowFade with predetermined durations and damping. Wrap calls to withAnimation to ensure consistency. Create a HapticsManager that provides short, light or heavy feedback patterns for common interactions.

• Utility views: Create loading indicators, skeleton loaders and empty state placeholders that match the design language.

• Preview infrastructure: Add preview support to each component that showcases different states (e.g. light/dark, large/small sizes, disabled/enabled). Use PreviewProvider to display multiple configurations.

• Documentation: Write accompanying documentation in /docs/architecture/DesignSystem.md describing the design tokens, components and usage guidelines.

⸻

Design Requirements

The design system must feel:

• Native to Apple: Leverage SwiftUI and adhere to Apple’s Human Interface Guidelines.

• Minimal and Premium: Use generous whitespace, soft shadows and subtle gradients. Avoid unnecessary decoration and clutter. Glassmorphism should be applied sparingly to create depth without distraction.

• Calm and Friendly: Use smooth spring animations, subtle motion and soft tones. Haptic feedback should enhance, not overwhelm.

• Adaptive: All components must support light and dark modes, dynamic type sizes, high contrast settings, VoiceOver and reduced motion preferences.

Use SF Symbols for icons and avoid proprietary icon libraries unless absolutely necessary. Use Apple’s dynamic colors and fonts for accessibility. Support Live Activities and Dynamic Island guidelines by ensuring the design system is compatible with platform features.

⸻

Performance

Components should be lightweight and avoid unnecessary view hierarchy. Use LazyVStack and LazyHStack when creating lists. Avoid complex overlays that hinder scrolling performance. Prefer value types (struct) and avoid storing heavy state in views. Offload heavy computations to background queues if needed. Ensure custom animations do not block the main thread.

⸻

Accessibility

Accessibility considerations must be integral to the design system:

• Dynamic Type: All text must scale with the user’s preferred content size category.

• VoiceOver: Provide descriptive labels, hints and values for interactive elements. Avoid decorative text that confuses screen readers.

• High Contrast: Ensure sufficient color contrast for text and icons against backgrounds. Test in high contrast mode.

• Reduce Motion: Respect the user’s “Reduce Motion” setting by minimizing animations and transitions when enabled.

• Keyboard and Pointer Support: Ensure all controls are focusable with external keyboards and pointer devices. Provide visible focus indicators.

⸻

Testing

Configure:

• Snapshot Tests: Use snapshot testing to capture how components render across light/dark modes and dynamic type sizes. Detect unintended visual regressions.

• Unit Tests: Validate that the theme injects correct values. Test that disabled states and error states behave correctly.

• Accessibility Tests: Use XCTest to verify that interactive controls have accessibility labels and that color contrast meets WCAG 2.1 AA standards.

• Preview Providers: Use SwiftUI previews extensively. Provide multiple states within a single preview.

⸻

Documentation

Document the design system in /docs/architecture/DesignSystem.md:

• Explain the purpose and philosophy of the design system.

• List all tokens (colors, typography, spacing) with examples.

• Describe each component, its variants, and when to use it.

• Provide example code snippets for using the components.

• Include guidelines on animation and haptic feedback usage.

Update DECISIONS.md to record any major choices, such as how themes are injected or why certain component patterns were selected.

⸻

Completion

When this phase is complete:

• Run the app in light and dark modes, at various dynamic type sizes, and ensure all components render correctly.

• Summarize the design system architecture, tokens and components created.

• Identify any gaps or improvements that should be addressed later (e.g. if a certain component needs refactoring).

• Add ADR entries to DECISIONS.md explaining major design choices (e.g. theme injection strategy).

After summarizing and documenting, do not proceed to Phase 03. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
