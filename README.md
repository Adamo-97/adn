# Athan & Prayer Times App

A modern, cross-platform mobile application built with Flutter to provide essential tools and information for Muslims.

## 🌟 Features

This application is designed to be a comprehensive daily companion for Muslims, helping users practice their faith with the aid of modern technology.

- **Prayer Times & Athan Notifications:**
  The app provides highly accurate prayer timings based on the user's geographical location. It offers customizable notifications for each of the five daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha) and Sunrise, ensuring users are reminded of prayer times throughout the day. Users can select from various calculation methods to match their local conventions.

- **Detailed Salah Guide:**
  A step-by-step guide to performing Salah correctly. This feature is designed for both beginners and those looking to refine their prayer. It breaks down the components of Salah, including positions, recitations, and their meanings, potentially using illustrations and text to guide the user.

- **Interactive Prayer Tracker:**
  To encourage consistency in prayer, the app includes a tracker. Users can log their daily prayers, monitor their progress over time, and view their prayer history. This feature aims to help users build and maintain their habit of praying five times a day, with analytics to visualize their commitment.

- **Nearby Mosque Finder:**
  Using the device's location services, this feature displays a map with the locations of nearby mosques. Users can get directions, view mosque names, and potentially see information like prayer and Jumu'ah times.

- **Qibla Direction (Coming Soon):**
  An easy-to-use digital compass that will point users towards the Qibla (the direction of the Kaaba in Mecca), an essential tool for praying from any location worldwide.

- **Digital Quran & Dhikr (Coming Soon):**
  Direct access to the Holy Quran within the app, allowing users to read and search verses. This will be complemented by a Dhikr (remembrance) section, providing a collection of important supplications and a digital counter to aid in their recitation.

## 📁 Project Structure

The project follows a clean architecture to separate concerns:

- `lib/presentation/`: Contains all UI-related code, including screens, widgets, and visual elements.
- `lib/data/`: Contains the business logic, data models, and repositories for fetching data from external APIs.
- `lib/core/`: Holds shared utilities, constants, and core application setup.
- `lib/routes/`: Defines the application's navigation routes.
- `assets/`: Stores all static assets like images, fonts, and mock data.

## ⚖️ License & Usage

### For Educational Use Only

This project is made publicly available for educational purposes. You are free to clone, study, and modify the code to learn about Flutter development and application architecture.

**Distribution of this application, in part or in whole, is strictly prohibited.**

Please refer to the [LICENSE](LICENSE) file for more details.

© 2025 Adam Abdullah — All Rights Reserved

## Coverage (tests)

This project can generate test coverage reports locally and in CI. The coverage artifacts are generated into the `coverage/` folder and are intentionally ignored in git (see `.gitignore`).

Quick local steps:

- Run all tests and generate an lcov report:

  ```powershell
  flutter test --coverage
  ```

- This produces `coverage/lcov.info`. To view an HTML report locally you can use `lcov`/`genhtml` or a small tool like `lcov_to_html`:

  ```powershell
  # convert lcov to HTML (example, requires lcov tools installed)
  genhtml coverage/lcov.info -o coverage/html
  # then open coverage/html/index.html in your browser
  ```

Publishing coverage in CI:

- Codecov (example): upload `coverage/lcov.info` using their bash uploader or CI integration. On GitHub Actions you can use the `codecov/codecov-action`.

- Coveralls: use the appropriate uploader for your CI and language. Many CI providers have first-class Coveralls or Codecov actions.

Example (GitHub Actions snippet):

```yaml
# ... run tests step that runs `flutter test --coverage` ...
- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v4
  with:
    files: coverage/lcov.info
    fail_ci_if_error: true
```

Notes:

- The `coverage/` folder is generated output and is excluded from version control to avoid repository churn.
- Keep CI tokens (Codecov/Coveralls) secret — store them in your repo's CI secrets.