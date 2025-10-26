import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mosque_model.dart';
import 'nearby_mosques_state.dart';

/// Provider for Nearby Mosques Screen (Riverpod 3.x)
final nearbyMosquesNotifierProvider =
    NotifierProvider.autoDispose<NearbyMosquesNotifier, NearbyMosquesState>(
  NearbyMosquesNotifier.new,
);

/// Notifier for managing Nearby Mosques Screen state
class NearbyMosquesNotifier extends Notifier<NearbyMosquesState> {
  @override
  NearbyMosquesState build() {
    final initialState = NearbyMosquesState.initial();
    // Initialize with mock data after microtask
    Future.microtask(() => _loadMockData());
    return initialState;
  }

  /// Load mock mosque data
  /// TODO: Replace with real API integration
  void _loadMockData() {
    state = state.copyWith(isLoading: true);

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final mockMosques = [
        const MosqueModel(
          id: '1',
          name: 'Grand Mosque',
          address: '123 Main Street, Downtown',
          distance: 1.2,
          latitude: 40.7128,
          longitude: -74.0060,
        ),
        const MosqueModel(
          id: '2',
          name: 'Central Islamic Center',
          address: '456 Oak Avenue, City Center',
          distance: 2.5,
          latitude: 40.7580,
          longitude: -73.9855,
        ),
        const MosqueModel(
          id: '3',
          name: 'Community Masjid',
          address: '789 Elm Street, Westside',
          distance: 3.7,
          latitude: 40.7489,
          longitude: -73.9680,
        ),
        const MosqueModel(
          id: '4',
          name: 'Peace Mosque',
          address: '321 Pine Road, East District',
          distance: 5.1,
          latitude: 40.7306,
          longitude: -73.9352,
        ),
        const MosqueModel(
          id: '5',
          name: 'Unity Islamic Center',
          address: '654 Maple Drive, North End',
          distance: 7.8,
          latitude: 40.7829,
          longitude: -73.9654,
        ),
        const MosqueModel(
          id: '6',
          name: 'Al-Noor Masjid',
          address: '987 Cedar Lane, South Side',
          distance: 9.3,
          latitude: 40.7028,
          longitude: -74.0134,
        ),
        const MosqueModel(
          id: '7',
          name: 'Al-Iman Mosque',
          address: '147 Birch Street, Old Town',
          distance: 13.9,
          latitude: 40.7589,
          longitude: -73.9851,
        ),
      ];

      state = state.copyWith(
        mosques: mockMosques,
        isLoading: false,
      );
    });
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Toggle map expansion
  void toggleMapExpansion() {
    state = state.copyWith(isMapExpanded: !state.isMapExpanded);
  }

  /// Toggle mosque card expansion
  void toggleMosqueExpansion(String mosqueId) {
    if (state.expandedMosqueId == mosqueId) {
      // Collapse if already expanded
      state = state.copyWith(expandedMosqueId: null);
    } else {
      // Expand this mosque, collapse others
      state = state.copyWith(expandedMosqueId: mosqueId);
    }
  }

  /// Refresh mosque list
  void refresh() {
    _loadMockData();
  }

  /// Open mosque in map (navigation to external map app)
  void openMosqueInMap(MosqueModel mosque) {
    // TODO: Implement navigation to external map app
    // using url_launcher or similar package
    print('Opening ${mosque.name} in map...');
  }

  /// Search for mosque on Google
  void searchGoogleForMosque(MosqueModel mosque) {
    // TODO: Implement Google search
    // using url_launcher to open google.com/search?q=mosque.name
    print('Searching Google for ${mosque.name}...');
  }

  /// Reset state to initial when navigating away
  void resetState() {
    state = state.copyWith(
      searchQuery: '',
      expandedMosqueId: null,
      isMapExpanded: false,
      draggableSheetPosition: 0.5,
      listScrollPosition: 0.0,
      resetTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
