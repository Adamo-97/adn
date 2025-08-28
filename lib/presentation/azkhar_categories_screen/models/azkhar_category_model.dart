import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

/// This class represents an individual Azkhar category item.

// ignore_for_file: must_be_immutable
class AzkharCategoryModel extends Equatable {
  AzkharCategoryModel({
    this.title,
    this.iconPath,
    this.backgroundColor,
    this.borderColor,
    this.isSelected,
  }) {
    title = title ?? "";
    iconPath = iconPath ?? "";
    backgroundColor = backgroundColor ?? Color(0xFF5C6248);
    borderColor = borderColor ?? Color(0xFF8F9B87);
    isSelected = isSelected ?? false;
  }

  String? title;
  String? iconPath;
  Color? backgroundColor;
  Color? borderColor;
  bool? isSelected;

  AzkharCategoryModel copyWith({
    String? title,
    String? iconPath,
    Color? backgroundColor,
    Color? borderColor,
    bool? isSelected,
  }) {
    return AzkharCategoryModel(
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props =>
      [title, iconPath, backgroundColor, borderColor, isSelected];
}
