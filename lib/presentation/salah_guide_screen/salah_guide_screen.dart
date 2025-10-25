import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/salah_guide_card_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: appTheme.gray_900,
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
              color: appTheme.white_A700,
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
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

                  SizedBox(height: 24.h),
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
        );
      },
    );
  }

  Widget _buildCategorySection({
    required SalahCategory category,
    required List<SalahGuideCardModel> cards,
    required WidgetRef ref,
  }) {
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
                    color: appTheme.white_A700,
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
                    // TODO: Navigate to card details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
