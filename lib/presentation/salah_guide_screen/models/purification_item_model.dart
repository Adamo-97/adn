import '../../../core/app_export.dart';

class PurificationItemModel {
  final String? iconPath;
  final String? primaryTitle;
  final String? secondaryTitle;
  final bool? isMainCard;

  const PurificationItemModel({
    this.iconPath,
    this.primaryTitle,
    this.secondaryTitle,
    this.isMainCard,
  });

  /// Exactly the 3 cards you used before, with ImageConstant icons.
  /// If your icon constant names differ, adjust just these three lines.
  static List<PurificationItemModel> forSalahGuide() {
    return [
      PurificationItemModel(
        iconPath: ImageConstant.imgWuduIcon,      // <-- adjust if your constant differs
        primaryTitle: '',
        secondaryTitle: 'Wudu',
        isMainCard: true,
      ),
      PurificationItemModel(
        iconPath: ImageConstant.imgTayammumIcon,  // <-- adjust if your constant differs
        primaryTitle: '',
        secondaryTitle: 'Tayammum',
        isMainCard: false,
      ),
      PurificationItemModel(
        iconPath: ImageConstant.imgGhuslIcon,     // <-- adjust if your constant differs
        primaryTitle: '',
        secondaryTitle: 'Ghusl',
        isMainCard: false,
      ),
    ];
  }
}
