import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../info_page_screen/info_page_screen.dart';
import 'models/salah_guide_card_model.dart';
import 'models/search_result.dart';
import 'notifier/salah_guide_notifier.dart';
import 'widgets/salah_guide_card.dart';
import 'widgets/salah_header.dart';

class SalahGuideScreen extends ConsumerStatefulWidget {
  const SalahGuideScreen({super.key});

  @override
  SalahGuideScreenState createState() => SalahGuideScreenState();
}

class SalahGuideScreenState extends ConsumerState<SalahGuideScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // Controllers for each horizontal category list
  final Map<SalahCategory, ScrollController> _horizontalControllers = {};
  bool _isResetting = false; // Flag to prevent circular updates

  @override
  void initState() {
    super.initState();
    // Listen to search input with debouncing
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Debounce search to avoid excessive searches while typing
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _searchCtrl.text == _searchCtrl.text) {
        ref.read(salahGuideNotifier.notifier).search(_searchCtrl.text);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollController.dispose();
    // Dispose horizontal controllers
    for (final c in _horizontalControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    // Listen to scroll position reset from notifier
    ref.listen<SalahGuideState>(salahGuideNotifier, (previous, next) {
      // Check if resetTimestamp changed (indicates reset was called)
      if (previous != null && next.resetTimestamp != previous.resetTimestamp) {
        if (!_isResetting) {
          _isResetting = true;

          // Reset scroll position
          if (_scrollController.hasClients && _scrollController.offset > 0.0) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }

          // Reset all horizontal category lists to start
          for (final controller in _horizontalControllers.values) {
            if (controller.hasClients && controller.offset > 0.0) {
              controller.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }

          // Clear search text
          if (_searchCtrl.text.isNotEmpty) {
            _searchCtrl.clear();
          }

          // Reset flag after animations complete
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted) {
              _isResetting = false;
            }
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: appColors.gray_900,
      body: Column(
        children: [
          SalahHeaderWithSearch(
            topInset: topInset,
            searchController: _searchCtrl,
            title: 'Salah Guide',
          ),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(salahGuideNotifier);
        final categorizedCards = state.categorizedCards;

        if (categorizedCards.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: appColors.whiteA700,
            ),
          );
        }

        // Show search results if searching
        if (state.searchQuery.isNotEmpty) {
          return _buildSearchResults(context, ref, state);
        }

        // Show normal categorized view
        return Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // Build sections for each category
                  ...SalahCategory.values.map((category) {
                    final cards = categorizedCards[category] ?? [];
                    if (cards.isEmpty) return SizedBox.shrink();

                    return _buildCategorySection(
                      category: category,
                      cards: cards,
                      ref: ref,
                    );
                  }),

                  SizedBox(
                      height:
                          76.h + 24.h), // Bottom padding: navbar height + extra
                ],
              ),
            ),

            // Bottom fade effect
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
                        appColors.gray_900.withAlpha((0.0 * 255).round()),
                        appColors.gray_900.withAlpha((0.3 * 255).round()),
                        appColors.gray_900.withAlpha((0.7 * 255).round()),
                        appColors.gray_900,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection({
    required SalahCategory category,
    required List<SalahGuideCardModel> cards,
    required WidgetRef ref,
  }) {
    // Ensure a controller exists for this category
    final controller = _horizontalControllers.putIfAbsent(
      category,
      () => ScrollController(),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              children: [
                Container(
                  width: 4.h,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: category.accentColor,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
                SizedBox(width: 10.h),
                Text(
                  category.title,
                  style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                    color: appColors.whiteA700,
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Horizontal scrollable cards
          SizedBox(
            height: 145.h,
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return SalahGuideCard(
                  card: cards[index],
                  onTap: () {
                    ref
                        .read(salahGuideNotifier.notifier)
                        .selectCard(cards[index]);
                    // Navigate to InfoPageScreen with card details using root navigator
                    // This hides the bottom navigation bar
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => InfoPageScreen(
                          cardTitle: cards[index].title ?? '',
                          category: cards[index].category ?? category,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build search results view
  Widget _buildSearchResults(
    BuildContext context,
    WidgetRef ref,
    SalahGuideState state,
  ) {
    if (state.isSearching) {
      return Center(
        child: CircularProgressIndicator(
          color: appColors.whiteA700,
        ),
      );
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60.h,
              color: appColors.gray_600,
            ),
            SizedBox(height: 16.h),
            Text(
              'No results found',
              style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                color: appColors.gray_500,
                fontSize: 16.fSize,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try different keywords like "dua", "steps", or prayer names',
              style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                color: appColors.gray_600,
                fontSize: 13.fSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group search results by card
    final groupedResults = <SalahGuideCardModel, List<SearchResult>>{};
    for (final result in state.searchResults) {
      groupedResults.putIfAbsent(result.card, () => []).add(result);
    }

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(
            left: 20.h,
            right: 20.h,
            top: 24.h,
            bottom:
                100.h, // Extra padding for navbar (76.h navbar + 24.h spacing)
          ),
          itemCount: groupedResults.length,
          itemBuilder: (context, index) {
            final card = groupedResults.keys.elementAt(index);
            final results = groupedResults[card]!;
            final highestResult = results.first; // Already sorted by relevance

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildSearchResultCard(
                card: card,
                result: highestResult,
                ref: ref,
              ),
            );
          },
        ),

        // Bottom fade effect
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
                    appColors.gray_900.withAlpha((0.0 * 255).round()),
                    appColors.gray_900.withAlpha((0.3 * 255).round()),
                    appColors.gray_900.withAlpha((0.7 * 255).round()),
                    appColors.gray_900,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build individual search result card
  Widget _buildSearchResultCard({
    required SalahGuideCardModel card,
    required SearchResult result,
    required WidgetRef ref,
  }) {
    return InkWell(
      onTap: () {
        ref.read(salahGuideNotifier.notifier).selectCard(card);

        // Navigate to InfoPageScreen with optional section scrolling
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => InfoPageScreen(
              cardTitle: card.title ?? '',
              category: card.category ?? SalahCategory.essentials,
              initialSectionIndex:
                  result.sectionIndex, // Scroll to matched section
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.h),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appColors.gray_900_01,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: card.category?.accentColor.withAlpha((0.3 * 255).round()) ??
                appColors.gray_700,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                // Icon
                Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: card.category?.accentColor
                            .withAlpha((0.15 * 255).round()) ??
                        appColors.gray_700,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Center(
                    child: CustomImageView(
                      imagePath: card.iconPath,
                      height: 24.h,
                      width: 24.h,
                      color: card.category?.accentColor ?? appColors.whiteA700,
                    ),
                  ),
                ),

                SizedBox(width: 12.h),

                // Title and category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title ?? '',
                        style: TextStyleHelper.instance.body15RegularPoppins
                            .copyWith(
                          color: appColors.whiteA700,
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        card.category?.title ?? '',
                        style: TextStyleHelper.instance.body12RegularPoppins
                            .copyWith(
                          color: appColors.gray_500,
                          fontSize: 12.fSize,
                        ),
                      ),
                    ],
                  ),
                ),

                // Match type badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getMatchTypeColor(result.matchType)
                        .withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                  child: Text(
                    _getMatchTypeLabel(result.matchType),
                    style:
                        TextStyleHelper.instance.label10LightPoppins.copyWith(
                      color: _getMatchTypeColor(result.matchType),
                      fontSize: 11.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // Matched snippet
            if (result.matchedSnippet != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  color: appColors.gray_900.withAlpha((0.5 * 255).round()),
                  borderRadius: BorderRadius.circular(6.h),
                ),
                child: Text(
                  result.matchedSnippet!,
                  style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                    color: appColors.gray_500,
                    fontSize: 13.fSize,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get color for match type badge
  Color _getMatchTypeColor(SearchMatchType matchType) {
    switch (matchType) {
      case SearchMatchType.exactTitle:
      case SearchMatchType.partialTitle:
        return const Color(0xFF4CAF50); // Green
      case SearchMatchType.category:
      case SearchMatchType.synonym:
        return const Color(0xFF2196F3); // Blue
      case SearchMatchType.dua:
        return const Color(0xFF9C27B0); // Purple
      case SearchMatchType.steps:
        return const Color(0xFFFF9800); // Orange
      case SearchMatchType.content:
      case SearchMatchType.arabicText:
        return const Color(0xFF607D8B); // Gray
    }
  }

  /// Get label for match type badge
  String _getMatchTypeLabel(SearchMatchType matchType) {
    switch (matchType) {
      case SearchMatchType.exactTitle:
        return 'Exact';
      case SearchMatchType.partialTitle:
        return 'Title';
      case SearchMatchType.category:
        return 'Category';
      case SearchMatchType.synonym:
        return 'Related';
      case SearchMatchType.dua:
        return 'Du\'a';
      case SearchMatchType.steps:
        return 'Steps';
      case SearchMatchType.content:
        return 'Content';
      case SearchMatchType.arabicText:
        return 'Arabic';
    }
  }
}
