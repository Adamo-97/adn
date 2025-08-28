import '../../../core/app_export.dart';
import '../models/purification_item_model.dart';
import '../models/purification_selection_model.dart';

part 'purification_selection_state.dart';

final purificationSelectionNotifier = StateNotifierProvider<
    PurificationSelectionNotifier, PurificationSelectionState>(
  (ref) => PurificationSelectionNotifier(
    PurificationSelectionState(
      purificationSelectionModel: PurificationSelectionModel(),
    ),
  ),
);

class PurificationSelectionNotifier
    extends StateNotifier<PurificationSelectionState> {
  PurificationSelectionNotifier(PurificationSelectionState state)
      : super(state) {
    initialize();
  }

  void initialize() {
    final purificationItems = [
      PurificationItemModel(
        id: '1',
        iconPath: ImageConstant.imgWuduIcon,
        primaryTitle: 'Minor Ablution',
        secondaryTitle: 'Wuduʾ',
        isMainCard: true,
      ),
      PurificationItemModel(
        id: '2',
        iconPath: ImageConstant.imgTayammumIcon,
        primaryTitle: 'Dry Ablution',
        secondaryTitle: 'Tayammum',
        isMainCard: false,
      ),
      PurificationItemModel(
        id: '3',
        iconPath: ImageConstant.imgGhuslIcon,
        primaryTitle: 'Full Ritual Bath',
        secondaryTitle: 'Ghusl',
        isMainCard: false,
      ),
    ];

    state = state.copyWith(
      purificationItems: purificationItems,
      isLoading: false,
    );
  }

  void selectPurificationItem(PurificationItemModel item) {
    // Handle selection logic here
    state = state.copyWith(
      selectedItemId: item.id,
    );
  }
}
