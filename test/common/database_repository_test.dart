import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melodifestivalen_competition/common/models/models.dart';
import 'package:melodifestivalen_competition/common/repositories/database_repository.dart';
import 'package:melodifestivalen_competition/common/repositories/firebase_authentication.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'database_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  AuthenticationRepository,
])
Future<void> main() async {
  late MockAuthenticationRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthenticationRepository();
  });

  test(
      'given user is not logged in, when uploading semifinal prediction, then nothing is uploaded',
      () async {
    // Given
    final mockDb = FakeFirebaseFirestore();

    final databaseRepo = DatabaseRepository(
      db: mockDb,
      authRepository: mockAuthRepo,
    );
    const competitionId = 'competitionId';
    final prediction = SemifinalPredictionModel(
      finalist1: 1,
      finalist2: 2,
      finalist3: 3,
      finalist4: 4,
    );

    // When
    final success =
        await databaseRepo.uploadSemifinalPrediction(competitionId, prediction);

    // Then
    expect(success, false);
    expect(mockDb.dump(), '{}');
  });

  test(
      'given user is logged in, when uploading semifinal prediction, then database contains predictions',
      () async {
    // Given
    final mockDb = FakeFirebaseFirestore();

    final databaseRepo = DatabaseRepository(
      db: mockDb,
      authRepository: mockAuthRepo,
    );

    const competitionId = 'competitionId';
    final prediction = SemifinalPredictionModel(
      finalist1: 1,
      finalist2: 2,
      finalist3: 3,
      finalist4: 4,
    );

    final mockUser = MockUser(
      isAnonymous: false,
      uid: 'mockuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    when(mockAuthRepo.currentUser).thenReturn(mockUser);

    // When
    final success =
        await databaseRepo.uploadSemifinalPrediction(competitionId, prediction);

    // Then
    expect(success, true);
    Map<String, dynamic> expected = {
      'competitions': {
        'competitionId': {
          'predictions': {
            'mockuid': {
              'finalist1': 1,
              'finalist2': 2,
              'finalist3': 3,
              'finalist4': 4
            }
          }
        }
      }
    };
    expect(jsonDecode(mockDb.dump()), expected);
  });
}
