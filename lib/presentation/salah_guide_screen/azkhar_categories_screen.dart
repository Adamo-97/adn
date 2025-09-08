import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/purification_item_model.dart';
import 'widgets/purification_item_widget.dart';
import 'widgets/salah_header.dart';

class AzkharCategoriesScreen extends ConsumerStatefulWidget {
  const AzkharCategoriesScreen({Key? key}) : super(key: key);

  @override
  AzkharCategoriesScreenState createState() => AzkharCategoriesScreenState();
}

class AzkharCategoriesScreenState extends ConsumerState<AzkharCategoriesScreen> {
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
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.h,
                // slightly taller cells to avoid minor overflows
                childAspectRatio: 0.9,
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

