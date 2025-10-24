import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/purification_item_model.dart';
import 'widgets/purification_item_widget.dart';
import 'notifier/salah_guide_notifier.dart';
import 'widgets/salah_guide_card_widget.dart';
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
    final purificationItems = PurificationItemModel.forSalahGuide();

    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(salahGuideNotifier);
        final prayerCards = state.cards ?? [];

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),

                // Original 3 purification cards
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.h,
                    mainAxisSpacing: 8.h,
                    mainAxisExtent: 60.h,
                  ),
                  itemCount: purificationItems.length,
                  itemBuilder: (_, i) => PurificationItemWidget(
                    purificationItem: purificationItems[i],
                  ),
                ),

                SizedBox(height: 16.h),

                // Prayer cards from salah_guide_menu
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.h,
                    mainAxisSpacing: 10.h,
                    mainAxisExtent: 70.h,
                  ),
                  itemCount: prayerCards.length,
                  itemBuilder: (_, i) => SalahGuideCardWidget(
                    card: prayerCards[i],
                    onTapCard: () {
                      ref
                          .read(salahGuideNotifier.notifier)
                          .selectCard(prayerCards[i]);
                      // TODO: Navigate to card details
                    },
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
