import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prediction_page_app_bar_controller.freezed.dart';
part 'prediction_page_app_bar_controller.g.dart';

@riverpod
class PredictionPageAppBarController extends _$PredictionPageAppBarController {
  @override
  PredictionPageAppBarControllerState build() =>
      const PredictionPageAppBarControllerState();

  final DatabaseRepository databaseRepository = getIt.get<DatabaseRepository>();
  final FeatureFlagRepository featureFlagRepository =
      getIt.get<FeatureFlagRepository>();

  void getAppBarSubtitle() async {
    final currentCompetition = await databaseRepository
        .getCompetition(featureFlagRepository.getCurrentCompetition());

    state = state.copyWith(appBarSubtitle: currentCompetition.appBarSubtitle);
  }
}

@freezed
class PredictionPageAppBarControllerState
    with _$PredictionPageAppBarControllerState {
  const factory PredictionPageAppBarControllerState({
    String? appBarSubtitle,
  }) = _PredictionPageAppBarControllerState;
}
