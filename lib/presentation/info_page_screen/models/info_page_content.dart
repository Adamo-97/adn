import '../../../core/app_export.dart';
import 'info_page_section.dart';

/// Model representing the complete content of an info page
/// Loaded from JSON files in lib/data/info_pages/en/
class InfoPageContent extends Equatable {
  final String title;
  final List<InfoPageSection> sections;

  const InfoPageContent({
    required this.title,
    required this.sections,
  });

  /// Factory constructor to create InfoPageContent from JSON
  factory InfoPageContent.fromJson(Map<String, dynamic> json) {
    return InfoPageContent(
      title: json['title'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((section) =>
              InfoPageSection.fromJson(section as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert InfoPageContent to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }

  InfoPageContent copyWith({
    String? title,
    List<InfoPageSection>? sections,
  }) {
    return InfoPageContent(
      title: title ?? this.title,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [title, sections];
}
