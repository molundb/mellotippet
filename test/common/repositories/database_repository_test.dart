import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mellotippet/common/repositories/authentication_repository.dart';
import 'package:mellotippet/common/repositories/database_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fakes.dart';
import 'database_repository_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepositoryImpl,
])
Future<void> main() async {
  late MockAuthenticationRepositoryImpl mockAuthRepo;
  final mockStorage = MockFirebaseStorage();

  setUp(() {
    mockAuthRepo = MockAuthenticationRepositoryImpl();
  });

  group('upload semifinal prediction', () {
    test(
        'given user is not logged in, when uploading semifinal prediction, then nothing is uploaded',
        () async {
      // Given
      final mockDb = FakeFirebaseFirestore();

      final databaseRepo = DatabaseRepositoryImpl(
        db: mockDb,
        storage: mockStorage,
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

      final databaseRepo = DatabaseRepositoryImpl(
        db: mockDb,
        storage: mockStorage,
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
            'predictionsAndScores': {
              'mockuid': {
                'finalist1': {'prediction': 1, 'score': 0},
                'finalist2': {'prediction': 2, 'score': 0}
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

      final databaseRepo = DatabaseRepositoryImpl(
        db: mockDb,
        storage: mockStorage,
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

      final databaseRepo = DatabaseRepositoryImpl(
        db: mockDb,
        storage: mockStorage,
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
            'predictionsAndScores': {
              'mockuid': {
                'placement1': {'prediction': 1, 'score': 0},
                'placement2': {'prediction': 2, 'score': 0},
                'placement3': {'prediction': 3, 'score': 0},
                'placement4': {'prediction': 4, 'score': 0},
                'placement5': {'prediction': 5, 'score': 0},
                'placement6': {'prediction': 6, 'score': 0},
                'placement7': {'prediction': 7, 'score': 0},
                'placement8': {'prediction': 8, 'score': 0},
                'placement9': {'prediction': 9, 'score': 0},
                'placement10': {'prediction': 10, 'score': 0},
                'placement11': {'prediction': 11, 'score': 0},
                'placement12': {'prediction': 12, 'score': 0}
              }
            }
          }
        }
      };
      expect(jsonDecode(mockDb.dump()), expected);
    });
  });
}
