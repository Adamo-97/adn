import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Service for detecting user location via GPS and reverse geocoding
///
/// Provides methods to:
/// - Request location permissions
/// - Get current GPS coordinates
/// - Reverse geocode coordinates to city/country
/// - Handle permission denials and errors gracefully
///
/// Returns location in format: "City, Country" (e.g., "Stockholm, Sweden")
class LocationService {
  /// Check if location services are enabled on device
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission from user
  ///
  /// Returns the permission status after request.
  /// May return denied, deniedForever, whileInUse, or always.
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current GPS position
  ///
  /// Throws exception if:
  /// - Location services disabled
  /// - Permission denied
  /// - Timeout (30 seconds)
  ///
  /// Use [getCurrentLocation] for a safer high-level API.
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 30),
      ),
    );
  }

  /// Reverse geocode coordinates to city and country
  ///
  /// Returns location string in format: "City, Country"
  /// Throws exception if geocoding fails or no results found.
  Future<String> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) {
      throw Exception('No location found for coordinates');
    }

    final placemark = placemarks.first;
    final city =
        placemark.locality ?? placemark.subAdministrativeArea ?? 'Unknown';
    final country = placemark.country ?? 'Unknown';

    return '$city, $country';
  }

  /// High-level API: Get current location as "City, Country" string
  ///
  /// Handles all permission checks, service checks, and error cases.
  /// Returns LocationResult with success/failure status and data/error message.
  ///
  /// Usage:
  /// ```dart
  /// final result = await locationService.getCurrentLocation();
  /// if (result.success) {
  ///   print('Location: ${result.location}');
  /// } else {
  ///   print('Error: ${result.errorMessage}');
  /// }
  /// ```
  Future<LocationResult> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.failure(
          'Location services are disabled. Please enable them in device settings.',
        );
      }

      // Check permission status
      LocationPermission permission = await checkPermission();

      // Request permission if denied
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.failure(
            'Location permission denied. Please grant permission in app settings.',
          );
        }
      }

      // Check if permission is permanently denied
      if (permission == LocationPermission.deniedForever) {
        return LocationResult.failure(
          'Location permission permanently denied. Please enable it in device settings.',
        );
      }

      // Get current position
      final position = await getCurrentPosition();

      // Reverse geocode to city/country
      final location = await getLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return LocationResult.success(location);
    } catch (e) {
      return LocationResult.failure(
        'Failed to detect location: ${e.toString()}',
      );
    }
  }

  /// Open device location settings
  ///
  /// Useful when user needs to enable location services or grant permissions.
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app-specific settings
  ///
  /// Useful when permission is permanently denied and user needs to manually enable it.
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}

/// Result wrapper for location detection operations
///
/// Contains either:
/// - success=true with location string ("City, Country")
/// - success=false with error message describing what went wrong
class LocationResult {
  final bool success;
  final String? location;
  final String? errorMessage;

  LocationResult._({
    required this.success,
    this.location,
    this.errorMessage,
  });

  factory LocationResult.success(String location) {
    return LocationResult._(
      success: true,
      location: location,
    );
  }

  factory LocationResult.failure(String errorMessage) {
    return LocationResult._(
      success: false,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    if (success) {
      return 'LocationResult(success: true, location: $location)';
    } else {
      return 'LocationResult(success: false, error: $errorMessage)';
    }
  }
}
