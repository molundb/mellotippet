import 'package:mellotippet/config/flavor.dart';

abstract class FirebaseEnvironment {
  String firebaseAPIKeyAndroid(Flavor flavor);

  String firebaseAPIKeyIos(Flavor flavor);

  String firebaseAppIdAndroid(Flavor flavor);

  String firebaseAppIdIos(Flavor flavor);

  String firebaseMessagingSenderId(Flavor flavor);

  String firebaseProjectId(Flavor flavor);

  String firebaseStorageBucket(Flavor flavor);

  String firebaseIosClientId(Flavor flavor);

  String firebaseIosBundleId(Flavor flavor);
}
