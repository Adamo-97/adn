part of 'info_page_notifier.dart';

/// State class for InfoPage screen
/// Manages content, loading state, and category-specific theming
class InfoPageState extends Equatable {
  final String cardTitle;
  final SalahCategory category;
  final Color accentColor;
  final InfoPageContent? content;
  final bool isLoading;
  final String? error;

  const InfoPageState({
    required this.cardTitle,
    required this.category,
    required this.accentColor,
    this.content,
    this.isLoading = true,
    this.error,
  });

  InfoPageState copyWith({
    String? cardTitle,
    SalahCategory? category,
    Color? accentColor,
    InfoPageContent? content,
    bool? isLoading,
    String? error,
  }) {
    return InfoPageState(
      cardTitle: cardTitle ?? this.cardTitle,
      category: category ?? this.category,
      accentColor: accentColor ?? this.accentColor,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        cardTitle,
        category,
        accentColor,
        content,
        isLoading,
        error,
      ];
}
