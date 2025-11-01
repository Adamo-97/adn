import '../../../core/app_export.dart';

/// Enum representing the type of content in an info page section
enum SectionType {
  sectionTitle,
  paragraph,
  list,
}

extension SectionTypeExtension on SectionType {
  /// Convert from JSON string to SectionType enum
  static SectionType fromString(String value) {
    switch (value) {
      case 'section_title':
        return SectionType.sectionTitle;
      case 'paragraph':
        return SectionType.paragraph;
      case 'list':
        return SectionType.list;
      default:
        throw ArgumentError('Unknown section type: $value');
    }
  }

  /// Convert SectionType enum to JSON string
  String toJsonString() {
    switch (this) {
      case SectionType.sectionTitle:
        return 'section_title';
      case SectionType.paragraph:
        return 'paragraph';
      case SectionType.list:
        return 'list';
    }
  }
}

/// Model representing a section in an info page (paragraph, list, section title, etc.)
/// Supports illustration paths for visual content
class InfoPageSection extends Equatable {
  final SectionType type;
  final String? text;
  final String? illustration;
  final List<String>? items;

  const InfoPageSection({
    required this.type,
    this.text,
    this.illustration,
    this.items,
  });

  /// Factory constructor to create InfoPageSection from JSON
  factory InfoPageSection.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = SectionTypeExtension.fromString(typeStr);

    return InfoPageSection(
      type: type,
      text: json['text'] as String?,
      illustration: json['illustration'] as String?,
      items: type == SectionType.list
          ? (json['items'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList()
          : null,
    );
  }

  /// Convert InfoPageSection to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.toJsonString(),
      if (text != null) 'text': text,
      if (illustration != null) 'illustration': illustration,
      if (items != null) 'items': items,
    };
  }

  InfoPageSection copyWith({
    SectionType? type,
    String? text,
    String? illustration,
    List<String>? items,
  }) {
    return InfoPageSection(
      type: type ?? this.type,
      text: text ?? this.text,
      illustration: illustration ?? this.illustration,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [type, text, illustration, items];
}
