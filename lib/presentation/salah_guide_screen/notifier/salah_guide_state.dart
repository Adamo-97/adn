part of 'salah_guide_notifier.dart';

class SalahGuideState extends Equatable {
  final List<SalahGuideCardModel>? cards;
  final Map<SalahCategory, List<SalahGuideCardModel>> categorizedCards;
  final SalahGuideCardModel? selectedCard;
  final bool isLoading;
  final SalahGuideModel? salahGuideModel;

  const SalahGuideState({
    this.cards,
    this.categorizedCards = const {},
    this.selectedCard,
    this.isLoading = false,
    this.salahGuideModel,
  });

  @override
  List<Object?> get props => [
        cards,
        categorizedCards,
        selectedCard,
        isLoading,
        salahGuideModel,
      ];

  SalahGuideState copyWith({
    List<SalahGuideCardModel>? cards,
    Map<SalahCategory, List<SalahGuideCardModel>>? categorizedCards,
    SalahGuideCardModel? selectedCard,
    bool? isLoading,
    SalahGuideModel? salahGuideModel,
  }) {
    return SalahGuideState(
      cards: cards ?? this.cards,
      categorizedCards: categorizedCards ?? this.categorizedCards,
      selectedCard: selectedCard ?? this.selectedCard,
      isLoading: isLoading ?? this.isLoading,
      salahGuideModel: salahGuideModel ?? this.salahGuideModel,
    );
  }
}
