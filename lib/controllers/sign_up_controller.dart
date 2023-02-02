class SignUpController {
  late String email;
  late String password;

  void updateEmail(String? email) {
    if (email == null) return;

    this.email = email;
  }

  void updatePassword(String? password) {
    if (password == null) return;

    this.password = password;
  }
}