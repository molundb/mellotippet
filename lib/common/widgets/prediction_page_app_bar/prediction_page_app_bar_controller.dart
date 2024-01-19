import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mellotippet/common/repositories/feature_flag_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';

part 'prediction_page_app_bar_controller.freezed.dart';

class PredictionPageAppBarController
    extends StateNotifier<PredictionPageAppBarControllerState> {
  PredictionPageAppBarController({
    required this.databaseRepository,
    required this.featureFlagRepository,
    required PredictionPageAppBarControllerState state,
  }) : super(state);

  final DatabaseRepository databaseRepository;
  final FeatureFlagRepository featureFlagRepository;

  static final provider = StateNotifierProvider<PredictionPageAppBarController,
      PredictionPageAppBarControllerState>(
    (ref) => PredictionPageAppBarController(
      databaseRepository: getIt.get<DatabaseRepository>(),
      featureFlagRepository: getIt.get<FeatureFlagRepository>(),
      state: const PredictionPageAppBarControllerState(),
    ),
  );

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
