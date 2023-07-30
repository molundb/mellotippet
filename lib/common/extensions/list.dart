extension ListExt<T> on List<T?> {
  List<T> filterNulls() => where((item) => item != null).cast<T>().toList();
}
