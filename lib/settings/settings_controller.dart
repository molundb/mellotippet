import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melodifestivalen_competition/common/repositories/authentication_repository.dart';
import 'package:melodifestivalen_competition/dependency_injection/get_it.dart';
import 'package:melodifestivalen_competition/services/mello_predix_package_info.dart';

class SettingsController extends StateNotifier<SettingsControllerState> {
  SettingsController({
    SettingsControllerState? state,
  }) : super(state ?? SettingsControllerState.withDefaults());

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  final MelloPredixPackageInfo packageInfo =
      getIt.get<MelloPredixPackageInfo>();

  static final provider =
      StateNotifierProvider<SettingsController, SettingsControllerState>(
          (ref) => SettingsController());

  Future<void> signOut() => authRepository.firebaseAuth.signOut();

  void getAppVersion() {
    state = state.copyWith(appVersion: packageInfo.version);
  }
}

@immutable
class SettingsControllerState {
  const SettingsControllerState({required this.appVersion});

  final String? appVersion;

  SettingsControllerState copyWith({
    String? appVersion,
  }) {
    return SettingsControllerState(
      appVersion: appVersion ?? this.appVersion,
    );
  }

  factory SettingsControllerState.withDefaults() =>
      const SettingsControllerState(appVersion: null);
}
