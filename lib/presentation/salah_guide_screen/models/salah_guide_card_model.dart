import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

/// Category enum for organizing salah guide cards
enum SalahCategory {
  essentials,
  optionalPrayers,
  specialSituations,
  purification,
  rituals,
}

extension SalahCategoryExtension on SalahCategory {
  String get title {
    switch (this) {
      case SalahCategory.essentials:
        return 'Prayer Essentials';
      case SalahCategory.optionalPrayers:
        return 'Optional Prayers';
      case SalahCategory.specialSituations:
        return 'Special Situations';
      case SalahCategory.purification:
        return 'Purification';
      case SalahCategory.rituals:
        return 'Hajj & Umrah';
    }
  }

  Color get accentColor {
    switch (this) {
      case SalahCategory.essentials:
        return appColors.salahEssentials;
      case SalahCategory.optionalPrayers:
        return appColors.salahOptionalPrayers;
      case SalahCategory.specialSituations:
        return appColors.salahSpecialSituations;
      case SalahCategory.purification:
        return appColors.salahPurification;
      case SalahCategory.rituals:
        return appColors.salahRituals;
    }
  }
}

/// This class represents an individual Salah guide card item (e.g., Wudu, Ghusl, How to Pray).

// ignore_for_file: must_be_immutable
class SalahGuideCardModel extends Equatable {
  SalahGuideCardModel({
    this.title,
    this.iconPath,
    this.backgroundColor,
    this.borderColor,
    this.isSelected,
    this.category,
  }) {
    title = title ?? "";
    iconPath = iconPath ?? "";
    backgroundColor = backgroundColor ?? appColors.gray_700;
    borderColor = borderColor ?? appColors.gray_500;
    isSelected = isSelected ?? false;
    category = category;
  }

  String? title;
  String? iconPath;
  Color? backgroundColor;
  Color? borderColor;
  bool? isSelected;
  SalahCategory? category;

  SalahGuideCardModel copyWith({
    String? title,
    String? iconPath,
    Color? backgroundColor,
    Color? borderColor,
    bool? isSelected,
    SalahCategory? category,
  }) {
    return SalahGuideCardModel(
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      isSelected: isSelected ?? this.isSelected,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props =>
      [title, iconPath, backgroundColor, borderColor, isSelected, category];
}
