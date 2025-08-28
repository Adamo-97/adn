import '../../../core/app_export.dart';

/// This class is used in the [surah_item_widget] widget.

// ignore_for_file: must_be_immutable
class SurahItemModel extends Equatable {
  SurahItemModel({
    this.surahNumber,
    this.surahName,
    this.arabicName,
    this.isSelected,
    this.id,
  }) {
    surahNumber = surahNumber ?? '1';
    surahName = surahName ?? 'Al-Fatiha';
    arabicName = arabicName ?? '';
    isSelected = isSelected ?? false;
    id = id ?? '';
  }

  String? surahNumber;
  String? surahName;
  String? arabicName;
  bool? isSelected;
  String? id;

  SurahItemModel copyWith({
    String? surahNumber,
    String? surahName,
    String? arabicName,
    bool? isSelected,
    String? id,
  }) {
    return SurahItemModel(
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      arabicName: arabicName ?? this.arabicName,
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        surahNumber,
        surahName,
        arabicName,
        isSelected,
        id,
      ];
}
