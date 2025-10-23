import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_export.dart';
import '../models/app_navigation_model.dart';
part 'app_navigation_state.dart';

final appNavigationNotifier = NotifierProvider.autoDispose<
    AppNavigationNotifier,
    AppNavigationState>(() => AppNavigationNotifier());

/// A notifier that manages the state of a AppNavigation according to the event that is dispatched to it.
class AppNavigationNotifier extends Notifier<AppNavigationState> {
  @override
  AppNavigationState build() {
    return AppNavigationState();
  }
}
