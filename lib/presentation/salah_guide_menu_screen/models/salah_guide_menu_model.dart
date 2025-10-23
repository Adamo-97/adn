import '../../../core/app_export.dart';

class SalahGuideMenuModel extends Equatable {
  final String title;
  final List<PrayerGuideItemModel> prayerGuideItems;
  final List<PrayerTypeModel> prayerTypes;

  SalahGuideMenuModel({
    String? title,
    List<PrayerGuideItemModel>? prayerGuideItems,
    List<PrayerTypeModel>? prayerTypes,
  })  : title = title ?? 'Salah Guide',
        prayerGuideItems = prayerGuideItems ?? [],
        prayerTypes = prayerTypes ?? [];

  @override
  List<Object?> get props => [title, prayerGuideItems, prayerTypes];

  SalahGuideMenuModel copyWith({
    String? title,
    List<PrayerGuideItemModel>? prayerGuideItems,
    List<PrayerTypeModel>? prayerTypes,
  }) {
    return SalahGuideMenuModel(
      title: title ?? this.title,
      prayerGuideItems: prayerGuideItems ?? this.prayerGuideItems,
      prayerTypes: prayerTypes ?? this.prayerTypes,
    );
  }
}

class PrayerGuideItemModel extends Equatable {
  final String iconPath;
  final String title;
  final String subtitle;

  const PrayerGuideItemModel({
    String? iconPath,
    String? title,
    String? subtitle,
  })  : iconPath = iconPath ?? '',
        title = title ?? '',
        subtitle = subtitle ?? '';

  @override
  List<Object?> get props => [iconPath, title, subtitle];

  PrayerGuideItemModel copyWith({
    String? iconPath,
    String? title,
    String? subtitle,
  }) {
    return PrayerGuideItemModel(
      iconPath: iconPath ?? this.iconPath,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

class PrayerTypeModel extends Equatable {
  final String title;
  final String iconPath;

  const PrayerTypeModel({
    String? title,
    String? iconPath,
  })  : title = title ?? '',
        iconPath = iconPath ?? '';

  @override
  List<Object?> get props => [title, iconPath];

  PrayerTypeModel copyWith({
    String? title,
    String? iconPath,
  }) {
    return PrayerTypeModel(
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
