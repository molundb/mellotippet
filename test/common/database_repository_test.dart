import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melodifestivalen_competition/common/repositories/database_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'database_repository_test.mocks.dart';
import 'fakes.dart';

@GenerateMocks([
  AuthenticationRepository,
])
Future<void> main() async {
  late MockAuthenticationRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthenticationRepository();
  });

  group('upload semifinal prediction', () {
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
      final prediction = fakeSemifinalPrediction;

      // When
      final success = await databaseRepo.uploadSemifinalPrediction(
          competitionId, prediction);

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
      final prediction = fakeSemifinalPrediction;

      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'mockuid',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
      );

      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      // When
      final success = await databaseRepo.uploadSemifinalPrediction(
          competitionId, prediction);

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
  });

  group('upload final prediction', () {
    test(
        'given user is not logged in, when uploading final prediction, then nothing is uploaded',
        () async {
      // Given
      final mockDb = FakeFirebaseFirestore();

      final databaseRepo = DatabaseRepository(
        db: mockDb,
        authRepository: mockAuthRepo,
      );
      const competitionId = 'competitionId';
      final prediction = fakeFinalPrediction;

      // When
      final success =
          await databaseRepo.uploadFinalPrediction(competitionId, prediction);

      // Then
      expect(success, false);
      expect(mockDb.dump(), '{}');
    });

    test(
        'given user is logged in, when uploading final prediction, then database contains predictions',
        () async {
      // Given
      final mockDb = FakeFirebaseFirestore();

      final databaseRepo = DatabaseRepository(
        db: mockDb,
        authRepository: mockAuthRepo,
      );

      const competitionId = 'competitionId';
      final prediction = fakeFinalPrediction;

      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'mockuid',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
      );

      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      // When
      final success =
          await databaseRepo.uploadFinalPrediction(competitionId, prediction);

      // Then
      expect(success, true);
      Map<String, dynamic> expected = {
        'competitions': {
          'competitionId': {
            'predictions': {
              'mockuid': {
                'position1': 1,
                'position2': 2,
                'position3': 3,
                'position4': 4,
                'position5': 5,
                'position6': 6,
                'position7': 7,
                'position8': 8,
                'position9': 9,
                'position10': 10,
                'position11': 11,
                'position12': 12,
              }
            }
          }
        }
      };
      expect(jsonDecode(mockDb.dump()), expected);
    });
  });
}
