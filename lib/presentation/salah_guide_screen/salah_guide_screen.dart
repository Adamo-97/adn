import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/purification_item_model.dart';
import 'widgets/purification_item_widget.dart';
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
    // Exactly 3 boxes (Wudu, Tayammum, Ghusl) using ImageConstant
    final items = PurificationItemModel.forSalahGuide();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h), // space below header content
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.h,
                mainAxisSpacing: 8.h,
                // precise, compact height per tile
                mainAxisExtent: 60.h,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => PurificationItemWidget(
                purificationItem: items[i],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
