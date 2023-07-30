extension NullableString on String? {
  bool get isNullOrBlank => this?.isBlank ?? true;
}

extension NotNullString on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;
}
