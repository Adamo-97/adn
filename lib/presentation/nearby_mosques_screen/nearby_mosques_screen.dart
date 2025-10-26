import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'notifier/nearby_mosques_notifier.dart';
import 'notifier/nearby_mosques_state.dart';
import 'widgets/mosque_card.dart';

class NearbyMosquesScreen extends ConsumerStatefulWidget {
  const NearbyMosquesScreen({super.key});

  @override
  NearbyMosquesScreenState createState() => NearbyMosquesScreenState();
}

class NearbyMosquesScreenState extends ConsumerState<NearbyMosquesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  final ScrollController _scrollController = ScrollController();
  bool _isResetting = false; // Flag to prevent circular updates

  @override
  void initState() {
    super.initState();
    // Don't track scroll position - we only need to reset it
  }

  @override
  void dispose() {
    _searchController.dispose();
    _draggableController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nearbyMosquesNotifierProvider);
    final notifier = ref.read(nearbyMosquesNotifierProvider.notifier);

    // Listen to reset state changes from notifier
    ref.listen<NearbyMosquesState>(nearbyMosquesNotifierProvider,
        (previous, next) {
      if (_isResetting) return;

      // Check if resetTimestamp changed (indicates reset was called)
      if (previous != null && next.resetTimestamp != previous.resetTimestamp) {
        _isResetting = true;

        // Reset draggable sheet position
        if (_draggableController.isAttached &&
            _draggableController.size != 0.5) {
          _draggableController.animateTo(
            0.5,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }

        // Reset list scroll position
        if (_scrollController.hasClients && _scrollController.offset != 0.0) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }

        // Clear search text
        if (_searchController.text.isNotEmpty) {
          _searchController.clear();
        }

        // Reset flag after animations complete
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) {
            _isResetting = false;
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: appTheme.gray_900,
      body: Stack(
        children: [
          // Map section - full screen
          _buildMapSection(),

          // Draggable mosque list sheet
          DraggableScrollableSheet(
            controller: _draggableController,
            initialChildSize: 0.5, // Start at 50% of screen
            minChildSize: 0.15, // Minimum 15% (just the handle visible)
            maxChildSize: 0.85, // Maximum 85% to not cover search bar
            snap: true,
            snapSizes: const [0.15, 0.5, 0.85],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: appTheme.gray_900, // Same grey as navbar hole #212121
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13.h),
                    topRight: Radius.circular(13.h),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Container(
                        width: 45.h,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray_700, // Darker grey for handle
                          borderRadius: BorderRadius.circular(10.h),
                        ),
                      ),
                    ),

                    // Mosque list with gradient shadow at bottom
                    Expanded(
                      child: Stack(
                        children: [
                          // List content
                          state.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: appTheme.orange_200,
                                  ),
                                )
                              : state.filteredMosques.isEmpty
                                  ? _buildEmptyState()
                                  : _buildMosqueListView(
                                      state, notifier, scrollController),

                          // Bottom gradient shadow (like salah guide)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: IgnorePointer(
                              child: Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.0, 0.4, 0.7, 1.0],
                                    colors: [
                                      appTheme.gray_900.withOpacity(0.0),
                                      appTheme.gray_900.withOpacity(0.3),
                                      appTheme.gray_900.withOpacity(0.7),
                                      appTheme.gray_900,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Floating search bar and location button at the top
          Positioned(
            top: 54.h,
            left: 34.h,
            right: 34.h,
            child: _buildSearchBar(notifier),
          ),
        ],
      ),
    );
  }

  /// Map section with placeholder
  Widget _buildMapSection() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Map placeholder
          CustomImageView(
            imagePath: ImageConstant.imgMapPlaceholder,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 107.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    appTheme.gray_900.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Search bar with location and search buttons OUTSIDE the bar
  Widget _buildSearchBar(notifier) {
    return Row(
      children: [
        // Location button - SVG already has circular bg
        GestureDetector(
          onTap: () {
            // TODO: Implement location selection
            print('Location button tapped');
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgLocationButton,
            height: 44.h,
            width: 44.h,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(width: 10.h),

        // Search input bar
        Expanded(
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: BoxDecoration(
              color: appTheme.gray_900, // Same grey as navbar hole #212121
              borderRadius: BorderRadius.circular(64.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: TextField(
                controller: _searchController,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.white_A700,
                  fontSize: 14.fSize,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.white_A700.withOpacity(0.5),
                    fontSize: 14.fSize,
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => notifier.updateSearchQuery(value),
              ),
            ),
          ),
        ),

        SizedBox(width: 10.h),

        // Search button - SVG already has circular bg
        GestureDetector(
          onTap: () {
            // Trigger search
            notifier.updateSearchQuery(_searchController.text);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgSearchButton,
            height: 44.h,
            width: 44.h,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  /// Empty state when no mosques found
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgMosqueNavIcon,
            height: 64.h,
            width: 64.h,
            color: appTheme.gray_500.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No mosques found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: appTheme.white_A700.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or location',
            style: theme.textTheme.bodySmall?.copyWith(
              color: appTheme.white_A700.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// Mosque list view
  Widget _buildMosqueListView(
      state, notifier, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: state.filteredMosques.length,
      padding: EdgeInsets.only(
        left: 15.h,
        right: 15.h,
        top: 0,
        bottom: 76.h + 20.h, // Bottom padding: navbar height + extra clearance
      ),
      itemBuilder: (context, index) {
        final mosque = state.filteredMosques[index];
        final isExpanded = state.expandedMosqueId == mosque.id;

        return MosqueCard(
          mosque: mosque,
          isExpanded: isExpanded,
          onTap: () => notifier.toggleMosqueExpansion(mosque.id),
          onMapTap: () => notifier.openMosqueInMap(mosque),
          onSearchGoogle: () => notifier.searchGoogleForMosque(mosque),
        );
      },
    );
  }
}
