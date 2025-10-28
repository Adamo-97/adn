# UI Documentation

This document provides an overview of the User Interface (UI) components, screens, and general structure of the Athan application.

## Screens

The primary UI screens of the application are located in the `lib/presentation/` directory. Each folder corresponds to a major feature or view.

### 1. App Navigation Screen
- **Directory:** `app_navigation_screen/`
- **Purpose:** This screen is likely a developer utility. It provides a quick way to navigate to and preview all other screens in the application, which is useful for testing and development.

### 2. Full Analytics Screen
- **Directory:** `full_analytics_screen/`
- **Purpose:** This screen is intended to display detailed analytics. Based on the app's context, it probably shows visualizations and statistics related to the user's prayer history from the Prayer Tracker.

### 3. Nearby Mosques Screen
- **Directory:** `nearby_mosques_screen/`
- **Purpose:** This screen provides a map-based feature to help users locate mosques in their immediate vicinity. It will likely use the device's GPS to show the user's location and markers for nearby mosques.

### 4. Prayer Tracker Screen
- **Directory:** `prayer_tracker_screen/`
- **Purpose:** This is a core feature where users can log their daily prayers. It likely presents a checklist or a calendar view for users to mark which of the five daily prayers they have completed.

### 5. Profile Settings Screen
- **Directory:** `profile_settings_screen/`
- **Purpose:** This screen allows users to manage their profile information and configure application settings. This could include changing location settings for prayer times, notification preferences, or theme settings.

### 6. Salah Guide Screen
- **Directory:** `salah_guide_screen/`
- **Purpose:** This screen serves as an educational guide on how to perform Salah (prayer). It may contain step-by-step instructions, images, and descriptions for each part of the prayer.

## Reusable Widgets

The application uses several custom-built, reusable widgets to maintain a consistent look and feel. These are located in the `lib/widgets/` directory.

- **`custom_bottom_bar.dart`**: Defines the main navigation bar at the bottom of the screen, likely containing icons for Home, Prayer Times, Quran, etc.
- **`custom_icon_button.dart`**: A standardized, reusable icon button widget.
- **`custom_image_view.dart`**: A wrapper around the standard `Image` widget, possibly with added features like placeholder images or caching.
- **`custom_search_view.dart`**: A standardized search bar widget used across different screens.
- **`custom_text_field_with_icon.dart`**: A text input field that includes an icon, used for forms like login or search.
