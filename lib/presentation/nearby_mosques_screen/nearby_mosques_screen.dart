import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'notifier/nearby_mosques_notifier.dart';
import 'notifier/nearby_mosques_state.dart';
import 'widgets/map_section.dart';
import 'widgets/nearby_search_bar.dart';
import 'widgets/mosque_list_sheet.dart';

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
      backgroundColor: appColors.gray_900,
      body: Stack(
        children: [
          const MapSection(),

          MosqueListSheet(
            state: state,
            notifier: notifier,
            draggableController: _draggableController,
          ),

          // Floating search bar and location button at the top
          Positioned(
            top: 54.h,
            left: 34.h,
            right: 34.h,
            child: NearbySearchBar(
                notifier: notifier, searchController: _searchController),
          ),
        ],
      ),
    );
  }
}
