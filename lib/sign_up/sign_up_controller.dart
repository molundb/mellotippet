class SignUpController {
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
}