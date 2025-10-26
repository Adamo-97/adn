import 'package:equatable/equatable.dart';
import '../models/mosque_model.dart';

/// State for Nearby Mosques Screen
class NearbyMosquesState extends Equatable {
  final List<MosqueModel> mosques;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final bool isMapExpanded;
  final String? expandedMosqueId; // Track which mosque card is expanded
  final double draggableSheetPosition; // Track draggable sheet position
  final double listScrollPosition; // Track list scroll position
  final int resetTimestamp; // Forces state change on reset

  const NearbyMosquesState({
    required this.mosques,
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.isMapExpanded = false,
    this.expandedMosqueId,
    this.draggableSheetPosition = 0.5,
    this.listScrollPosition = 0.0,
    this.resetTimestamp = 0,
  });

  /// Initial state with empty mosque list
  factory NearbyMosquesState.initial() {
    return const NearbyMosquesState(
      mosques: [],
      isLoading: true,
    );
  }

  @override
  List<Object?> get props => [
        mosques,
        isLoading,
        errorMessage,
        searchQuery,
        isMapExpanded,
        expandedMosqueId,
        draggableSheetPosition,
        listScrollPosition,
        resetTimestamp,
      ];

  NearbyMosquesState copyWith({
    List<MosqueModel>? mosques,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    bool? isMapExpanded,
    String? expandedMosqueId,
    double? draggableSheetPosition,
    double? listScrollPosition,
    int? resetTimestamp,
  }) {
    return NearbyMosquesState(
      mosques: mosques ?? this.mosques,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isMapExpanded: isMapExpanded ?? this.isMapExpanded,
      expandedMosqueId: expandedMosqueId,
      draggableSheetPosition:
          draggableSheetPosition ?? this.draggableSheetPosition,
      listScrollPosition: listScrollPosition ?? this.listScrollPosition,
      resetTimestamp: resetTimestamp ?? this.resetTimestamp,
    );
  }

  /// Get filtered mosques based on search query
  List<MosqueModel> get filteredMosques {
    if (searchQuery.isEmpty) return mosques;

    final query = searchQuery.toLowerCase();
    return mosques.where((mosque) {
      return mosque.name.toLowerCase().contains(query) ||
          mosque.address.toLowerCase().contains(query);
    }).toList();
  }
}
