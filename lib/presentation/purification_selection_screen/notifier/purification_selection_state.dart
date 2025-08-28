part of 'purification_selection_notifier.dart';

class PurificationSelectionState extends Equatable {
  final PurificationSelectionModel? purificationSelectionModel;
  final List<PurificationItemModel> purificationItems;
  final bool isLoading;
  final String? selectedItemId;

  const PurificationSelectionState({
    this.purificationSelectionModel,
    this.purificationItems = const [],
    this.isLoading = true,
    this.selectedItemId,
  });

  @override
  List<Object?> get props => [
        purificationSelectionModel,
        purificationItems,
        isLoading,
        selectedItemId,
      ];

  PurificationSelectionState copyWith({
    PurificationSelectionModel? purificationSelectionModel,
    List<PurificationItemModel>? purificationItems,
    bool? isLoading,
    String? selectedItemId,
  }) {
    return PurificationSelectionState(
      purificationSelectionModel:
          purificationSelectionModel ?? this.purificationSelectionModel,
      purificationItems: purificationItems ?? this.purificationItems,
      isLoading: isLoading ?? this.isLoading,
      selectedItemId: selectedItemId ?? this.selectedItemId,
    );
  }
}
