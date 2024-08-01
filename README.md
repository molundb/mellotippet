# Mellotippet

**Mellotippet** is a Flutter app for competing in predicting the results of [Melodifestivalen](https://sv.wikipedia.org/wiki/Melodifestivalen) with friends and family.

## Features 
With **Mellotippet** users can currently do the following:

- Create an account
- Make a prediction on the next competition in Melodifestivalen (there are 4-6 competitions per year/season based on the year's format)
- See their score of previous predictions

**Mellotippet** is a work in progress and more features will be implemented.

## Architecture
The app uses a layered architecture with Riverpod for state management and GetIt as a service locator.

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

## Build
Create a run configuration with the following settings:
- Dart entrypoint: lib/main_stage.dart
- Build flavor: stage

## Testing
### Frontend: 
`flutter test` runs all widget tests.

### Backend
To run the backend tests
1. Create a Firebase project
2. In that Firebase project, go to Project Settings -> Service Accounts
3. Generate a new private key for Node.js
4. Download the file and move it to `functions/.firebase/serice-account-test.json`
5. Go to the functions folder in the project
6. Run all backend tests with - `npm test`

## Backend
The backend consists of a Firestore database and an Express.js application hosted as a Firebase Cloud Function.

