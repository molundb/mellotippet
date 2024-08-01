import 'package:firebase_core/firebase_core.dart';
import 'package:mellotippet/config/flavor.dart';

abstract class FirebaseEnvironment {
  FirebaseOptions getAndroidOptions(Flavor flavor);

  FirebaseOptions getIosOptions(Flavor flavor);
}
