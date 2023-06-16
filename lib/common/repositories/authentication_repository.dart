import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/firebase_options.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required this.firebaseAuth,
  });

  final auth.FirebaseAuth firebaseAuth;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      name: 'melodifestivalen-comp-stage',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  auth.User? get currentUser => firebaseAuth.currentUser;

  Future<UserScoreEntity> signInAnonymously() async {
    try {
      await firebaseAuth.signInAnonymously();

      return _mapFirebaseUser(currentUser!);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  Future<UserScoreEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _mapFirebaseUser(currentUser!);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  Future<UserScoreEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _mapFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  UserScoreEntity _mapFirebaseUser(auth.User? user) {
    if (user == null) {
      return UserScoreEntity.empty();
    }

    final map = <String, dynamic>{
      'id': user.uid,
      'username': '',
      'score': 0,
      'email': user.email ?? '',
      'emailVerified': user.emailVerified,
      'isAnonymous': user.isAnonymous,
    };
    return UserScoreEntity.fromJson(map);
  }

  AuthError _determineError(auth.FirebaseAuthException exception) {
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
}
