import 'package:mellotippet/config/flavor.dart';

class Config {
  final Flavor flavor;

  Config(this.flavor);

  String get name => flavor.name;

  bool get isProd => flavor == Flavor.prod;

  String get title {
    switch (flavor) {
      case Flavor.prod:
        return 'Mellotippet';
      case Flavor.stage:
        return 'Mellotippet Stage';
    }
  }
}
