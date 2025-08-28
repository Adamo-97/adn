import '../../../core/app_export.dart';

/// This class is used in the [purification_selection_screen] screen.

// ignore_for_file: must_be_immutable
class PurificationSelectionModel extends Equatable {
  PurificationSelectionModel({this.id}) {
    id = id ?? '';
  }

  String? id;

  PurificationSelectionModel copyWith({
    String? id,
  }) {
    return PurificationSelectionModel(
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [id];
}
