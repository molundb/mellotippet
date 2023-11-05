# melodifestivalen_competition

An app for competing in predicting the results of Melodifestivalen with your friends and family.

## Set Up

1. Create a firebase project https://firebase.google.com/
2. For Android: Put the google-service.json file in android/app/src/stage/
3. For iOS: Put the GoogleService-Info.plist file in ios/Runner/stage/GoogleService-Info.plist
4. Create a file lib/firebase_environment.dart that implements the following methods required by
   lib/firebase_options.dart:
    - String firebaseAPIKeyAndroid(Flavor flavor)
    - String firebaseAPIKeyIos(Flavor flavor)
    - String firebaseAppIdAndroid(Flavor flavor)
    - String firebaseAppIdIos(Flavor flavor)
    - String firebaseMessagingSenderId(Flavor flavor)
    - String firebaseProjectId(Flavor flavor)
    - String firebaseStorageBucket(Flavor flavor)
    - String firebaseIosClientId(Flavor flavor)
    - String firebaseIosBundleId(Flavor flavor)

## To run the app

Create a run configuration with the following settings:
- Dart entrypoint: lib/main_stage.dart
- Build flavor: stage