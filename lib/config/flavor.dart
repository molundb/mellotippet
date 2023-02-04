enum Flavor {
  prod,
  stage,
}

extension FlavorName on Flavor {
  String get name => toString().split('.').last;
}
