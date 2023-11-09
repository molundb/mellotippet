import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/feature_flag_repository.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/services/mello_tippet_package_info.dart';

class ForceUpgradeController
    extends StateNotifier<ForceUpgradeControllerState> {
  ForceUpgradeController({ForceUpgradeControllerState? state})
      : super(state ?? ForceUpgradeControllerState.withDefaults());

  final packageInfo = getIt.get<MellotippetPackageInfo>();
  final featureFlagRepository = getIt.get<FeatureFlagRepository>();

  static final provider = StateNotifierProvider<ForceUpgradeController,
      ForceUpgradeControllerState>((ref) => ForceUpgradeController());

  Future<void> checkIfUpdateRequiredOrRecommended() async {
    state = state.copyWith(loading: true);
    var appVersion = _getExtendedVersionNumber(packageInfo.version);
    var requiredMinVersion = _getExtendedVersionNumber(
        featureFlagRepository.getRequiredMinimumVersion());
    var recommendedMinVersion = _getExtendedVersionNumber(
        featureFlagRepository.getRecommendedMinimumVersion());

    state = state.copyWith(
      loading: false,
      updateRequired: appVersion < requiredMinVersion,
      updateRecommended: appVersion < recommendedMinVersion,
    );
  }
}

@immutable
class ForceUpgradeControllerState {
  final bool loading;
  final bool updateRequired;
  final bool updateRecommended;

  const ForceUpgradeControllerState({
    this.loading = true,
    required this.updateRequired,
    required this.updateRecommended,
  });

  ForceUpgradeControllerState copyWith({
    bool? loading,
    bool? updateRequired,
    bool? updateRecommended,
  }) {
    return ForceUpgradeControllerState(
      loading: loading ?? this.loading,
      updateRequired: updateRequired ?? this.updateRequired,
      updateRecommended: updateRecommended ?? this.updateRecommended,
    );
  }

  factory ForceUpgradeControllerState.withDefaults() =>
      const ForceUpgradeControllerState(
          updateRequired: false, updateRecommended: false);
}

int _getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}
