import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/service_location/get_it.dart';
import 'package:mellotippet/services/mello_tippet_package_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.freezed.dart';
part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  SettingsControllerState build() =>
      const SettingsControllerState(appVersion: null);

  final AuthenticationRepository authRepository =
      getIt.get<AuthenticationRepository>();

  final MellotippetPackageInfo packageInfo =
      getIt.get<MellotippetPackageInfo>();

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
