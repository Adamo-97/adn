part of 'salah_guide_notifier.dart';

class SalahGuideState extends Equatable {
  final List<SalahGuideCardModel>? cards;
  final Map<SalahCategory, List<SalahGuideCardModel>> categorizedCards;
  final SalahGuideCardModel? selectedCard;
  final bool isLoading;
  final SalahGuideModel? salahGuideModel;
  final double scrollPosition; // Track scroll position for reset
  final int resetTimestamp; // Forces state change on reset

  const SalahGuideState({
    this.cards,
    this.categorizedCards = const {},
    this.selectedCard,
    this.isLoading = false,
    this.salahGuideModel,
    this.scrollPosition = 0.0,
    this.resetTimestamp = 0,
  });

  @override
  List<Object?> get props => [
        cards,
        categorizedCards,
        selectedCard,
        isLoading,
        salahGuideModel,
        scrollPosition,
        resetTimestamp,
      ];

  SalahGuideState copyWith({
    List<SalahGuideCardModel>? cards,
    Map<SalahCategory, List<SalahGuideCardModel>>? categorizedCards,
    SalahGuideCardModel? selectedCard,
    bool? isLoading,
    SalahGuideModel? salahGuideModel,
    double? scrollPosition,
    int? resetTimestamp,
  }) {
    return SalahGuideState(
      cards: cards ?? this.cards,
      categorizedCards: categorizedCards ?? this.categorizedCards,
      selectedCard: selectedCard ?? this.selectedCard,
      isLoading: isLoading ?? this.isLoading,
      salahGuideModel: salahGuideModel ?? this.salahGuideModel,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      resetTimestamp: resetTimestamp ?? this.resetTimestamp,
    );
  }
}
