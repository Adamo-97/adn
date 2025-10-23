part of 'salah_guide_notifier.dart';

class SalahGuideState extends Equatable {
  final List<SalahGuideCardModel>? cards;
  final SalahGuideCardModel? selectedCard;
  final bool isLoading;
  final SalahGuideModel? salahGuideModel;

  const SalahGuideState({
    this.cards,
    this.selectedCard,
    this.isLoading = false,
    this.salahGuideModel,
  });

  @override
  List<Object?> get props => [
        cards,
        selectedCard,
        isLoading,
        salahGuideModel,
      ];

  SalahGuideState copyWith({
    List<SalahGuideCardModel>? cards,
    SalahGuideCardModel? selectedCard,
    bool? isLoading,
    SalahGuideModel? salahGuideModel,
  }) {
    return SalahGuideState(
      cards: cards ?? this.cards,
      selectedCard: selectedCard ?? this.selectedCard,
      isLoading: isLoading ?? this.isLoading,
      salahGuideModel: salahGuideModel ?? this.salahGuideModel,
    );
  }
}
