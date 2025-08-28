import '../../../core/app_export.dart';

/// This class defines the purification item model used in the purification selection screen.

// ignore_for_file: must_be_immutable
class PurificationItemModel extends Equatable {
  PurificationItemModel({
    this.id,
    this.iconPath,
    this.primaryTitle,
    this.secondaryTitle,
    this.isMainCard,
  }) {
    id = id ?? '';
    iconPath = iconPath ?? '';
    primaryTitle = primaryTitle ?? '';
    secondaryTitle = secondaryTitle ?? '';
    isMainCard = isMainCard ?? false;
  }

  String? id;
  String? iconPath;
  String? primaryTitle;
  String? secondaryTitle;
  bool? isMainCard;

  PurificationItemModel copyWith({
    String? id,
    String? iconPath,
    String? primaryTitle,
    String? secondaryTitle,
    bool? isMainCard,
  }) {
    return PurificationItemModel(
      id: id ?? this.id,
      iconPath: iconPath ?? this.iconPath,
      primaryTitle: primaryTitle ?? this.primaryTitle,
      secondaryTitle: secondaryTitle ?? this.secondaryTitle,
      isMainCard: isMainCard ?? this.isMainCard,
    );
  }

  @override
  List<Object?> get props =>
      [id, iconPath, primaryTitle, secondaryTitle, isMainCard];
}
