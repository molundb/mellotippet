import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/widgets/prediction_row.dart';
import 'package:mellotippet/common/widgets/prediction_row_feedback_during_drag.dart';

part 'row_with_drag_version.freezed.dart';

@freezed
class RowWithDragVersion with _$RowWithDragVersion {
  const factory RowWithDragVersion({
    required PredictionRow row,
    required PredictionRowFeedbackDuringDrag rowFeedbackDuringDrag,
  }) = _RowWithDragVersion;
}
