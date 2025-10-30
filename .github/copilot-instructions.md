# Copilot Guidelines for Athan (Athan/Adhan) App

## Project Overview

This is a Flutter-based Islamic prayer application (Athan/Adhan app) that helps users track daily prayers, find nearby mosques, and access Salah (prayer) guidance. Built with Flutter 3.6+ and Riverpod for state management.

**Current Status**: Work in progress - frontend development phase only (no backend integration yet).

**Initial App Flow**: The `PrayerTrackerScreen` is the entry point (home screen). All screens/routes before it (e.g., app navigation screen, future login pages, onboarding flows) are subject to change and should not be relied upon for core functionality.

**Planned Evolution**:

- Original scope: Quran + Azkhar → New scope: Prayer tracking + Mosque locations + Salah guide
- Folder/route names (e.g., `quran_main_screen`, `azkhar_categories_screen`) will be refactored to reflect new features
- `quran_main_screen` → will become mosque locations/nearby mosques feature
- `azkhar_categories_screen` → will remain Salah guide

## Critical Rules (DO NOT VIOLATE)

### NEW_SCREENS Directory (Code Staging Area)

- **Purpose**: `NEW_SCREENS/` directory contains ready-to-integrate screen implementations that are staged for gradual migration into the main app
- **Status**: These screens are complete and functional but not yet integrated into the app's navigation/routing system
- **Integration Workflow**:
  - When user requests a specific screen integration, move it from `NEW_SCREENS/` to appropriate `lib/presentation/` location
  - Update routing in `lib/routes/app_routes.dart` to include the new screen
  - Connect with existing navigation flows (e.g., `CustomBottomBar` tabs, screen transitions)
  - Update any dependencies, imports, or state management integration as needed
- **Cleanup**: Once all screens are migrated and integrated, the `NEW_SCREENS/` directory will be deleted
- **DO NOT** modify or refactor screens in `NEW_SCREENS/` unless explicitly requested - they are source code backups
- **DO NOT** reference `NEW_SCREENS/` paths in production code - always move/integrate first

### Refactoring & Code Quality (MANDATORY)

- Whenever generating or editing code in `lib/`, produce refactored, modular, and maintainable code by default. This means:

  - Extract UI pieces into small, focused widgets under the feature's `widgets/` folder.
  - Prefer compositional APIs (small functions and widgets) over long, monolithic build methods.
  - Keep visual output identical unless the user explicitly asks for visual changes; refactor for readability and testability.
  - Add minimal unit or widget tests for any non-trivial logic you introduce or change when practical.

- Do not modify files under `NEW_SCREENS/` unless the user asks for migration; instead prepare refactored code in `lib/` and follow the integration workflow.

### Commenting Policy

- Comments must be logical, informative, and explain intent, contracts, data shapes, and edge cases. They should not merely repeat the user's prompt or restate trivial details.
- Prefer doc comments (`///`) on public classes, methods, and complex logic describing:
  - Inputs and outputs (data shapes/types)
  - Side-effects and error modes
  - Success criteria and important invariants
- Inline comments inside functions should explain non-obvious decisions, algorithms, or trade-offs. Avoid comments that only paraphrase code.

### Asset Management

- **Asset Directory Structure**: Use only these existing subdirectories:
  - `assets/` - General assets
  - `assets/images/` - General images
  - `assets/images/home/` - Prayer tracker (home screen) specific assets (prayer icons, Qibla button, navigation arrows, etc.)
  - `assets/images/notifications/` - Notification bell icons (bell_adhan.svg, bell_pling.svg, bell_mute.svg)
- **NEVER** add new asset directories (e.g., `assets/svg/`, `assets/icons/`, etc.)
- **NEVER** add new local fonts - only use existing fonts: Poppins (weights: 300, 400, 600, 700) and Noto Kufi Arabic (weight: 500)
- All images must be referenced through `ImageConstant` class in `lib/core/utils/image_constant.dart`
- Use `_homePath` for home screen assets, `_basePath` for general assets
- **PLANNED**: JSON data files will be added to support static content display (prayer guides, mosque info templates, etc.)

### Core Application Configuration

- **NEVER** remove the portrait-only orientation lock in `main.dart`:
  ```dart
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ```
- **NEVER** modify the `textScaler: TextScaler.linear(1.0)` wrapper in `MaterialApp.builder` - it prevents user font scaling overrides

### Naming Conventions

- **Use logical, semantic naming** for files, classes, and widgets based on their purpose and functionality
- **DO NOT** name files based on user requests (e.g., "modern_cards", "new_feature") - instead use descriptive names that reflect what the component does
- **Examples**:
  - ✅ `salah_guide_card.dart` (describes purpose)
  - ❌ `modern_salah_card.dart` (describes style/request)
  - ✅ `prayer_time_widget.dart` (describes function)
  - ❌ `new_prayer_widget.dart` (describes when it was added)
- Widget class names should match file names in PascalCase (e.g., `SalahGuideCard` in `salah_guide_card.dart`)

### Dependencies

- **NEVER** remove `flutter:`, `flutter_localizations:`, or `flutter_test:` from `pubspec.yaml` (marked with 🚨 CRITICAL)
- **NEVER** remove `uses-material-design: true` from `pubspec.yaml`

## Architecture Patterns

### Feature Organization (Feature-First Structure)

Each screen follows this structure under `lib/presentation/<feature_name>/`:

```
<feature_name>/
├── models/              # Data models for the feature
├── notifier/            # Riverpod StateNotifier + State classes
│   ├── <feature>_notifier.dart
│   └── <feature>_state.dart
├── widgets/             # Feature-specific reusable widgets
├── <feature>_screen.dart  # Main screen entry point
```

Example: `prayer_tracker_screen/` contains models, notifier (with state), widgets, and the main screen file.

### State Management (Riverpod 3.x + Notifier)

- Uses `flutter_riverpod` ^3.0.3 with `NotifierProvider.autoDispose`
- **Single Source of Truth**: Riverpod notifiers manage ALL state - avoid mixing frontend state with Riverpod state
- Pattern for all features:

  ```dart
  // Provider definition (Riverpod 3.x)
  final featureNotifierProvider = NotifierProvider.autoDispose<
      FeatureNotifier, FeatureState>(() => FeatureNotifier());

  // Notifier class (Riverpod 3.x)
  class FeatureNotifier extends Notifier<FeatureState> {
    @override
    FeatureState build() {
      final initialState = FeatureState(...);
      Future.microtask(() => initialize());
      return initialState;
    }

    void initialize() {
      // Initialize state here
    }
  }
  ```

- Widgets consume state with `ref.watch(featureNotifierProvider)` and call methods via `ref.read(featureNotifierProvider.notifier)`
- All screens extend `ConsumerStatefulWidget` or `ConsumerWidget`
- **IMPORTANT**: In Riverpod 3.x, `StateNotifier` and `StateNotifierProvider` have been removed - use `Notifier` and `NotifierProvider` instead
- **PLANNED**: Extensive refactoring to ensure notifiers are the single source of truth, eliminating duplicate state

### Navigation System

- **Multi-Navigator Bottom Bar**: `PrayerTrackerScreen` implements persistent bottom navigation with independent Navigator stacks per tab (preserves per-tab history)
- Each tab has its own `GlobalKey<NavigatorState>` to maintain separate navigation stacks
- Zero-duration page transitions within tabs using `PageRouteBuilder(transitionDuration: Duration.zero)`
- Global navigation via `NavigatorService` with `navigatorKey` for cross-app navigation
- Route definitions in `lib/routes/app_routes.dart` as static string constants

### Responsive Design System

- Based on Figma design dimensions: 375×932px (defined in `lib/core/utils/size_utils.dart`)
- Use `.h` extension for responsive sizing: `width: 50.h` scales proportionally to device width
- Use `.fSize` for responsive font sizes
- All measurements automatically adapt via `Sizer` widget wrapper in `main.dart`
- Device type detected automatically (mobile/tablet/desktop)

## Development Workflows

### Running the App

- **Windows/PowerShell**: Use `.\run_flutter.ps1` - automates clean, pub get, emulator launch (30s wait), then run
- Default emulator ID configured: "Medium Phone API 36.0" (customize in script)
- Standard commands:
  ```powershell
  flutter pub get
  flutter run
  flutter build apk --release  # Android release
  flutter build ios --release  # iOS release
  ```

### Common Tasks

1. **Adding a new route**: Update `lib/routes/app_routes.dart` with route constant and mapping
2. **Adding a new screen**: Create folder structure under `lib/presentation/`, include models/, notifier/, widgets/, and main screen
3. **State management**: Always use autoDispose providers to prevent memory leaks
4. **Images**: Add SVG/PNG to `assets/images/`, register in `pubspec.yaml` assets section, add constant to `ImageConstant`

## Component Library

### Custom Widgets (lib/widgets/)

- `CustomBottomBar`: Multi-tab persistent navigation with center icon notch
- `CustomImageView`: Unified image loader supporting SVG, PNG, network images, file paths with caching
- `CustomIconButton`, `CustomSearchView`, `CustomTextFieldWithIcon`: Themed form components

### Image Loading

- Extension method `String.imageType` auto-detects image format (SVG, PNG, network, file)
- Fallback to `ImageConstant.imgImageNotFound` for missing images
- SVG rendering via `flutter_svg`, caching via `cached_network_image`

## Theme System

- Access via global getters: `theme` (ThemeData), `appTheme` (LightCodeColors)
- Defined in `lib/theme/theme_helper.dart` and `lib/theme/text_style_helper.dart`
- **Current**: Dark theme implemented as 'lightCode' variant (naming is legacy, will be refactored)
- **PLANNED**: Light theme implementation with theme switching support
- Use `theme.colorScheme.primary` for colors, not hard-coded values
- Prepare for theme-aware color references that adapt to light/dark modes

## Localization & Internationalization

- **Current**: English only (`supportedLocales: [Locale('en', '')]`)
- **PLANNED**: Full Arabic + English support with RTL layout handling
- Uses `flutter_localizations` package (already configured)
- Will require l10n/i18n setup with `.arb` files for translation management
- UI components must support bidirectional text layout

## Environment & API Configuration

- `env.json` at project root contains API keys (Supabase, OpenAI, Gemini, Anthropic, Perplexity)
- Currently populated with placeholder values - replace with real credentials before production
- Prayer times API integration pending (see TODOs in `prayer_tracker_notifier.dart`)

## Testing

- Test files in `test/` directory
- Run with `flutter test`
- Widget test boilerplate in `test/widget_test.dart`
- **PLANNED**: Comprehensive test coverage including:
  - Unit tests for all Riverpod notifiers and business logic
  - Widget tests for all screens and custom components
  - Integration tests for multi-screen flows
  - Golden tests for UI consistency verification

## Documentation

- **PLANNED**: Extensive inline documentation for all public APIs
- Doc comments (`///`) for classes, methods, and complex logic
- Architecture decision records (ADRs) for major structural choices
- Component library documentation with usage examples

## TODOs & Known Gaps

- Prayer times API integration not implemented (placeholder "00:00" times in `fetchDailyTimes`)
- Current prayer detection logic pending real-time calculations
- Light theme not yet implemented (currently using dark theme despite 'lightCode' naming)
- Qibla compass and purification selection screens referenced but not fully implemented
- Arabic language support and RTL layout not yet configured
- SVG assets need reorganization into categorized folders
- JSON data files for static content not yet added
- Comprehensive test suite not yet written
- Extensive refactoring needed to eliminate state duplication between frontend and Riverpod

## Code Style Notes

- Uses standard Flutter lints (`package:flutter_lints/flutter.yaml`)
- Critical sections marked with `🚨 CRITICAL:` comments - never remove
- Inline documentation uses doc comments for complex widgets (see `CustomBottomBar`)
- Equatable used for model equality comparisons
