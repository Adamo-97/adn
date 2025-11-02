import '../../../core/app_export.dart';

/// Enum representing the type of content in an info page section
enum SectionType {
  sectionTitle,
  subheading,
  paragraph,
  list,
}

extension SectionTypeExtension on SectionType {
  /// Convert from JSON string to SectionType enum
  static SectionType fromString(String value) {
    switch (value) {
      case 'section_title':
        return SectionType.sectionTitle;
      case 'subheading':
        return SectionType.subheading;
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
      case SectionType.subheading:
        return 'subheading';
      case SectionType.paragraph:
        return 'paragraph';
      case SectionType.list:
        return 'list';
    }
  }
}

/// Text segment for formatted text with font and type information
class TextSegment extends Equatable {
  final String type; // 'quran_verse', 'arabic_text', 'english_text'
  final String text;
  final String? font; // 'Amiri Quran', 'Noto Kufi Arabic', or null for default

  const TextSegment({
    required this.type,
    required this.text,
    this.font,
  });

  factory TextSegment.fromJson(Map<String, dynamic> json) {
    return TextSegment(
      type: json['type'] as String,
      text: json['text'] as String,
      font: json['font'] as String?,
    );
  }

  @override
  List<Object?> get props => [type, text, font];
}

/// List item that can be either a plain string or formatted text
class ListItemData extends Equatable {
  final String? plainText;
  final List<TextSegment>? formattedText;

  const ListItemData({
    this.plainText,
    this.formattedText,
  });

  factory ListItemData.fromJson(dynamic json) {
    if (json is String) {
      return ListItemData(plainText: json);
    } else if (json is Map<String, dynamic>) {
      final formattedTextJson = json['formatted_text'] as List<dynamic>?;
      return ListItemData(
        plainText: json['text'] as String?,
        formattedText: formattedTextJson
            ?.map((segment) =>
                TextSegment.fromJson(segment as Map<String, dynamic>))
            .toList(),
      );
    }
    throw ArgumentError('Invalid list item format');
  }

  @override
  List<Object?> get props => [plainText, formattedText];
}

/// Model representing a section in an info page (paragraph, list, section title, etc.)
/// Supports illustration paths for visual content and formatted text with Arabic fonts
class InfoPageSection extends Equatable {
  final SectionType type;
  final String? text;
  final String? illustration;
  final List<dynamic>? items; // Can be String or Map for formatted items
  final List<TextSegment>? formattedText; // For formatted paragraphs

  const InfoPageSection({
    required this.type,
    this.text,
    this.illustration,
    this.items,
    this.formattedText,
  });

  /// Factory constructor to create InfoPageSection from JSON
  factory InfoPageSection.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = SectionTypeExtension.fromString(typeStr);

    // Parse formatted_text if available
    List<TextSegment>? formattedText;
    if (json.containsKey('formatted_text')) {
      final formattedTextJson = json['formatted_text'] as List<dynamic>?;
      formattedText = formattedTextJson
          ?.map((segment) =>
              TextSegment.fromJson(segment as Map<String, dynamic>))
          .toList();
    }

    return InfoPageSection(
      type: type,
      text: json['text'] as String?,
      illustration: json['illustration'] as String?,
      items:
          type == SectionType.list ? (json['items'] as List<dynamic>?) : null,
      formattedText: formattedText,
    );
  }

  /// Convert InfoPageSection to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.toJsonString(),
      if (text != null) 'text': text,
      if (illustration != null) 'illustration': illustration,
      if (items != null) 'items': items,
      if (formattedText != null) 'formatted_text': formattedText,
    };
  }

  InfoPageSection copyWith({
    SectionType? type,
    String? text,
    String? illustration,
    List<dynamic>? items,
    List<TextSegment>? formattedText,
  }) {
    return InfoPageSection(
      type: type ?? this.type,
      text: text ?? this.text,
      illustration: illustration ?? this.illustration,
      items: items ?? this.items,
      formattedText: formattedText ?? this.formattedText,
    );
  }

  @override
  List<Object?> get props => [type, text, illustration, items, formattedText];
}
