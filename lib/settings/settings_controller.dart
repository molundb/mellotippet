import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/services/mello_tippet_package_info.dart';

part 'settings_controller.freezed.dart';

class SettingsController extends StateNotifier<SettingsControllerState> {
  SettingsController({
    required SettingsControllerState state,
  }) : super(state);

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  final MellotippetPackageInfo packageInfo =
      getIt.get<MellotippetPackageInfo>();

  static final provider =
      StateNotifierProvider<SettingsController, SettingsControllerState>(
    (ref) => SettingsController(
      state: const SettingsControllerState(appVersion: null),
    ),
  );

  Future<void> signOut() => authRepository.firebaseAuth.signOut();

  void getAppVersion() {
    state = state.copyWith(appVersion: packageInfo.version);
  }
}

@freezed
class SettingsControllerState with _$SettingsControllerState {
  const factory SettingsControllerState({String? appVersion}) =
      _SettingsControllerState;
}
