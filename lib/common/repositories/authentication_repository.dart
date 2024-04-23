import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mellotippet/common/models/all_models.dart';
import 'package:mellotippet/firebase_options.dart';

abstract class AuthenticationRepository {
  FirebaseAuth get firebaseAuth;

  fireAuth.User? get currentUser;

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> deleteUserAccount();
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.auth,
  });

  final FirebaseAuth auth;

  @override
  FirebaseAuth get firebaseAuth => auth;

  @override
  fireAuth.User? get currentUser => auth.currentUser;

  static Future<void> initialize({required String name}) async {
    await Firebase.initializeApp(
      name: name,
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  AuthError _determineError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'user-disabled':
        return AuthError.userDisabled;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError.emailAlreadyInUse;
      case 'invalid-credential':
        return AuthError.invalidCredential;
      case 'operation-not-allowed':
        return AuthError.operationNotAllowed;
      case 'weak-password':
        return AuthError.weakPassword;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError.error;
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        //TODO: Figure out how to communicate between auth repo and reusable app bar.
        // Handle other Firebase exceptions
      }
    } catch (e) {
      // Handle general exception
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = firebaseAuth.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await firebaseAuth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }
}
