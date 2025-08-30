import '../../../core/app_export.dart';
import '../models/prayer_tracker_model.dart';

part 'prayer_tracker_state.dart';

final prayerTrackerNotifierProvider = StateNotifierProvider.autoDispose<
    PrayerTrackerNotifier, PrayerTrackerState>(
  (ref) => PrayerTrackerNotifier(
    PrayerTrackerState(
      prayerTrackerModel: PrayerTrackerModel(),
    ),
  ),
);

class PrayerTrackerNotifier extends StateNotifier<PrayerTrackerState> {
  PrayerTrackerNotifier(PrayerTrackerState state) : super(state) {
    initialize();
  }

  void initialize() {
    List<PrayerActionModel> prayerActions = [
      PrayerActionModel(
        icon: ImageConstant.imgQiblaButton,
        label: 'Qibla',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgWhuduGroup,
        label: 'Purification',
        navigateTo: '576:475',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgHowToPrayGroup,
        label: 'Salah Guide',
        navigateTo: '508:307',
      ),
      PrayerActionModel(
        icon: ImageConstant.imgAfterPrayGroup,
        label: 'Rituals',
      ),
    ];

    List<String> weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    List<PrayerRowModel> prayerRows = [
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
        isFirstRow: true,
      ),
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
      ),
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
      ),
      PrayerRowModel(
        values: ['0', '0', '0', '0', '0', '0', '0'],
        isLastRow: true,
      ),
    ];

    state = state.copyWith(
      prayerTrackerModel: PrayerTrackerModel(
        prayerActions: prayerActions,
        weekDays: weekDays,
        prayerRows: prayerRows,
      ),
    );
  }

  /// Set the selected calendar day (date-only).
  void selectDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    state = state.copyWith(selectedDate: d);
    // TODO: react to date change here:
    // - recompute daily prayer times for [d]
    // - update prayerRows / progress for that day
    // - schedule notifications if needed (per your policies)
  }
  
  void selectPrayerAction(PrayerActionModel action) {
    List<PrayerActionModel> updatedActions = state.prayerActions.map((item) {
      if (item.id == action.id) {
        return item.copyWith(isSelected: !(item.isSelected ?? false));
      }
      return item;
    }).toList();

    state = state.copyWith(
      prayerTrackerModel: state.prayerTrackerModel?.copyWith(
        prayerActions: updatedActions,
      ),
    );
  }
}
