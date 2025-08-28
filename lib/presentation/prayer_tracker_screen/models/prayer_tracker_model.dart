import '../../../core/app_export.dart';

class PrayerTrackerModel extends Equatable {
  List<PrayerActionModel>? prayerActions;
  List<String>? weekDays;
  List<PrayerRowModel>? prayerRows;
  String? nextPrayer;
  String? prayerTime;
  String? location;

  PrayerTrackerModel({
    this.prayerActions,
    this.weekDays,
    this.prayerRows,
    this.nextPrayer,
    this.prayerTime,
    this.location,
  }) {
    prayerActions = prayerActions ?? [];
    weekDays = weekDays ?? [];
    prayerRows = prayerRows ?? [];
    nextPrayer = nextPrayer ?? 'Next Prayer is Fajr';
    prayerTime = prayerTime ?? '00:00 AM';
    location = location ?? 'Ronneby, SE';
  }

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
  String? icon;
  String? label;
  String? navigateTo;
  bool? isSelected;
  String? id;

  PrayerActionModel({
    this.icon,
    this.label,
    this.navigateTo,
    this.isSelected,
    this.id,
  }) {
    icon = icon ?? '';
    label = label ?? '';
    navigateTo = navigateTo ?? '';
    isSelected = isSelected ?? false;
    id = id ?? '';
  }

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
  List<String>? values;
  bool? isFirstRow;
  bool? isLastRow;
  String? id;

  PrayerRowModel({
    this.values,
    this.isFirstRow,
    this.isLastRow,
    this.id,
  }) {
    values = values ?? [];
    isFirstRow = isFirstRow ?? false;
    isLastRow = isLastRow ?? false;
    id = id ?? '';
  }

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
