import 'package:mellotippet/common/repositories/repositories.dart';
import 'package:mellotippet/service_location/get_it.dart';

class SignUpController {
  final databaseRepository = getIt.get<DatabaseRepository>();

  late String username;
  late String email;
  late String password;

  void updateUsername(String? username) {
    if (username == null) return;

    this.username = username;
  }

  void updateEmail(String? email) {
    if (email == null) return;

    this.email = email;
  }

  void updatePassword(String? password) {
    if (password == null) return;

    this.password = password;
  }

  Future<bool> isUsernameAlreadyTaken() async {
    final query = await databaseRepository.users
        .where('username', isEqualTo: username)
        .get();

    return query.docs.isNotEmpty;
  }
}
