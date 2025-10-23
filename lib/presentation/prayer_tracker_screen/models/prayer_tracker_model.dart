import '../../../core/app_export.dart';

class PrayerTrackerModel extends Equatable {
  final List<PrayerActionModel> prayerActions;
  final List<String> weekDays;
  final List<PrayerRowModel> prayerRows;
  final String nextPrayer;
  final String prayerTime;
  final String location;

  PrayerTrackerModel({
    List<PrayerActionModel>? prayerActions,
    List<String>? weekDays,
    List<PrayerRowModel>? prayerRows,
    String? nextPrayer,
    String? prayerTime,
    String? location,
  })  : prayerActions = prayerActions ?? [],
        weekDays = weekDays ?? [],
        prayerRows = prayerRows ?? [],
        nextPrayer = nextPrayer ?? 'Next Prayer is Fajr',
        prayerTime = prayerTime ?? '00:00 AM',
        location = location ?? 'Ronneby, SE';

  @override
  List<Object?> get props => [
        prayerActions,
        weekDays,
        prayerRows,
        nextPrayer,
        prayerTime,
        location,
      ];

  PrayerTrackerModel copyWith({
    List<PrayerActionModel>? prayerActions,
    List<String>? weekDays,
    List<PrayerRowModel>? prayerRows,
    String? nextPrayer,
    String? prayerTime,
    String? location,
  }) {
    return PrayerTrackerModel(
      prayerActions: prayerActions ?? this.prayerActions,
      weekDays: weekDays ?? this.weekDays,
      prayerRows: prayerRows ?? this.prayerRows,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      prayerTime: prayerTime ?? this.prayerTime,
      location: location ?? this.location,
    );
  }
}

class PrayerActionModel extends Equatable {
  final String icon;
  final String label;
  final String? navigateTo;
  final bool isSelected;
  final String id;

  PrayerActionModel({
    String? icon,
    String? label,
    this.navigateTo,
    bool? isSelected,
    String? id,
  })  : icon = icon ?? '',
        label = label ?? '',
        isSelected = isSelected ?? false,
        id = id ?? '';

  @override
  List<Object?> get props => [icon, label, navigateTo, isSelected, id];

  PrayerActionModel copyWith({
    String? icon,
    String? label,
    String? navigateTo,
    bool? isSelected,
    String? id,
  }) {
    return PrayerActionModel(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      navigateTo: navigateTo ?? this.navigateTo,
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
    );
  }
}

class PrayerRowModel extends Equatable {
  final List<String?> values;
  final bool isFirstRow;
  final bool isLastRow;
  final String id;

  PrayerRowModel({
    List<String?>? values,
    bool? isFirstRow,
    bool? isLastRow,
    String? id,
  })  : values = values ?? [],
        isFirstRow = isFirstRow ?? false,
        isLastRow = isLastRow ?? false,
        id = id ?? '';

  @override
  List<Object?> get props => [values, isFirstRow, isLastRow, id];

  PrayerRowModel copyWith({
    List<String>? values,
    bool? isFirstRow,
    bool? isLastRow,
    String? id,
  }) {
    return PrayerRowModel(
      values: values ?? this.values,
      isFirstRow: isFirstRow ?? this.isFirstRow,
      isLastRow: isLastRow ?? this.isLastRow,
      id: id ?? this.id,
    );
  }
}
