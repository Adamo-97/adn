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

  const InfoPageScreen({
    super.key,
    required this.cardTitle,
    required this.category,
  });

  @override
  ConsumerState<InfoPageScreen> createState() => _InfoPageScreenState();
}

class _InfoPageScreenState extends ConsumerState<InfoPageScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notifier with card title and category
    Future.microtask(() {
      ref
          .read(infoPageNotifierProvider.notifier)
          .initialize(widget.cardTitle, widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(infoPageNotifierProvider);

    return Scaffold(
      backgroundColor: appColors.gray_900,
      appBar: InfoPageAppBar(
        title: state.content?.title ?? widget.cardTitle,
        accentColor: state.accentColor,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: _buildBody(state),
    );
  }  /// Build the main body content
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            
            // Render all sections from JSON
            ...state.content!.sections.asMap().entries.map((entry) {
              final section = entry.value;
              final isLastSection = entry.key == state.content!.sections.length - 1;
              
              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLastSection ? 40.h : 20.h,
                ),
                child: _buildSection(section, state.accentColor),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Build individual section based on type
  /// Handles section titles, paragraphs, and lists
  Widget _buildSection(InfoPageSection section, Color accentColor) {
    switch (section.type) {
      case SectionType.sectionTitle:
        return SectionTitleWidget(
          text: section.text ?? '',
          accentColor: accentColor,
        );

      case SectionType.paragraph:
        return ParagraphWidget(
          text: section.text ?? '',
          illustrationPath: section.illustration,
        );

      case SectionType.list:
        return ListItemWidget(
          items: section.items ?? [],
        );
    }
  }
}
