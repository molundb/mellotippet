import 'package:melodifestivalen_competition/config/flavor.dart';

class Config {
  final Flavor flavor;

  Config(this.flavor);

  String get name => flavor.name;

  bool get isProd => flavor == Flavor.prod;

  String get title {
    switch (flavor) {
      case Flavor.prod:
        return 'Mello Predix';
      case Flavor.stage:
        return 'Mello Predix Stage';
    }
  }
}
