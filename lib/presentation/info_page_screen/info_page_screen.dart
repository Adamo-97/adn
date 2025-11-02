import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../salah_guide_screen/models/salah_guide_card_model.dart';
import 'models/info_page_section.dart';
import 'notifier/info_page_notifier.dart';
import 'widgets/info_page_app_bar.dart';
import 'widgets/list_item_widget.dart';
import 'widgets/paragraph_widget.dart';
import 'widgets/section_title_widget.dart';

/// Info Page Screen
/// Displays detailed content for each Salah guide card
/// Content loaded from JSON files with illustrations
/// Theme adapts to category accent color
class InfoPageScreen extends ConsumerStatefulWidget {
  final String cardTitle;
  final SalahCategory category;
  final int? initialSectionIndex; // Optional: scroll to this section index

  const InfoPageScreen({
    super.key,
    required this.cardTitle,
    required this.category,
    this.initialSectionIndex,
  });

  @override
  ConsumerState<InfoPageScreen> createState() => _InfoPageScreenState();
}

class _InfoPageScreenState extends ConsumerState<InfoPageScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {}; // Keys for each section
  int? _highlightedSectionIndex; // Track which section to highlight
  late AnimationController _highlightController;
  late Animation<double> _highlightAnimation;
  bool _hasScrolledToSection = false; // Prevent multiple scrolls

  @override
  void initState() {
    super.initState();

    // Initialize highlight animation
    _highlightController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _highlightAnimation = Tween<double>(begin: 0.15, end: 0.0).animate(
      CurvedAnimation(parent: _highlightController, curve: Curves.easeOut),
    );

    // Set highlighted section if provided
    if (widget.initialSectionIndex != null) {
      _highlightedSectionIndex = widget.initialSectionIndex;
    }

    // Initialize notifier with card title and category
    Future.microtask(() {
      ref
          .read(infoPageNotifierProvider.notifier)
          .initialize(widget.cardTitle, widget.category);
    });
  }

  @override
  void dispose() {
    _highlightController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(infoPageNotifierProvider);

    // Scroll to target section when content is loaded (only once)
    if (!state.isLoading &&
        state.content != null &&
        widget.initialSectionIndex != null &&
        !_hasScrolledToSection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection(widget.initialSectionIndex!);
        _hasScrolledToSection = true;

        // Start highlight animation after scroll
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _highlightController.forward();
          }
        });
      });
    }

    return Scaffold(
      backgroundColor: appColors.gray_900,
      appBar: InfoPageAppBar(
        title: state.content?.title ?? widget.cardTitle,
        accentColor: state.accentColor,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: _buildBody(state),
    );
  }

  /// Build the main body content
  /// Shows loading indicator, error message, or scrollable content
  Widget _buildBody(InfoPageState state) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: state.accentColor,
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48.h,
                color: state.accentColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'Failed to Load Content',
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  color: appColors.whiteA700,
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                state.error!,
                style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
                  color: appColors.whiteA700.withValues(alpha: 0.7),
                  fontSize: 14.fSize,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.content == null) {
      return Center(
        child: Text(
          'No content available',
          style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
            color: appColors.whiteA700.withValues(alpha: 0.7),
            fontSize: 14.fSize,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // Render all sections from JSON
            ...state.content!.sections.asMap().entries.map((entry) {
              final index = entry.key;
              final section = entry.value;
              final isLastSection =
                  entry.key == state.content!.sections.length - 1;

              // Create a key for this section if needed for scrolling
              final sectionKey =
                  _sectionKeys.putIfAbsent(index, () => GlobalKey());

              // Check if this section should be highlighted
              final isHighlighted = _highlightedSectionIndex == index;

              return AnimatedBuilder(
                key: sectionKey,
                animation: _highlightAnimation,
                builder: (context, child) {
                  final highlightOpacity =
                      isHighlighted ? _highlightAnimation.value : 0.0;

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: isLastSection
                          ? 80.h
                          : 20.h, // Extra padding for last section (navbar)
                    ),
                    padding: isHighlighted
                        ? EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h)
                        : EdgeInsets.zero,
                    decoration: highlightOpacity > 0.01
                        ? BoxDecoration(
                            color: state.accentColor
                                .withAlpha((highlightOpacity * 255).round()),
                            borderRadius: BorderRadius.circular(8.h),
                          )
                        : null,
                    child: _buildSection(section, state.accentColor),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Scroll to a specific section by index
  void _scrollToSection(int sectionIndex) {
    final key = _sectionKeys[sectionIndex];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1, // Position near top of viewport
      );
    }
  }

  /// Build individual section based on type
  /// Handles section titles, subheadings, paragraphs, and lists
  Widget _buildSection(InfoPageSection section, Color accentColor) {
    switch (section.type) {
      case SectionType.sectionTitle:
        return SectionTitleWidget(
          text: section.text ?? '',
          accentColor: accentColor,
        );

      case SectionType.subheading:
        // Render subheading as a smaller section title
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Text(
            section.text ?? '',
            style: TextStyleHelper.instance.body15RegularPoppins.copyWith(
              color: appColors.whiteA700,
              fontSize: 14.fSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

      case SectionType.paragraph:
        return ParagraphWidget(
          text: section.text ?? '',
          illustrationPath: section.illustration,
          formattedText: section.formattedText,
        );

      case SectionType.list:
        return ListItemWidget(
          items: section.items ?? [],
        );
    }
  }
}
