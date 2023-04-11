// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:adroid/core/error/exceptions.dart';
import 'package:adroid/core/error/failures.dart';
import 'package:adroid/core/network/network_info.dart';
import 'package:adroid/features/historical/data/datasources/historical_local_data_source.dart';
import 'package:adroid/features/historical/data/datasources/historical_remote_data_source.dart';
import 'package:adroid/features/historical/data/models/historical_data_model.dart';
import 'package:adroid/features/historical/data/models/historical_model.dart';
import 'package:adroid/features/historical/data/repositories/historical_repository_impl.dart';
import 'package:adroid/features/historical/domain/entities/historical.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'historical_repository_impl_test.mocks.dart';

@GenerateMocks([
  HistoricalRemoteDataSource,
  HistoricalLocalDataSource,
  NetworkInfo,
])
void main() {
  late HistoricalRepositoryImpl repository;
  late MockHistoricalRemoteDataSource mockRemoteDataSource;
  late MockHistoricalLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  final tSymbol = 'AAPL';
  final tHistoricalModel = HistoricalModel(
    symbol: tSymbol,
    historicalData: const [
      HistoricalDataModel(
          date: "2023-01-20",
          open: 135.28,
          high: 135.28,
          low: 135.28,
          close: 135.28,
          adjClose: 135.28,
          volume: 74853563,
          unadjustedVolume: 74853563,
          change: 135.28,
          changePercent: 135.28,
          vwap: 135.28,
          label: "January 20, 23",
          changeOverTime: 135.28)
    ],
  );
  final Historical tHistorical = tHistoricalModel;
  setUp(() {
    mockRemoteDataSource = MockHistoricalRemoteDataSource();
    mockLocalDataSource = MockHistoricalLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = HistoricalRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group(
    'getHistory',
    () {
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(mockRemoteDataSource.getHistory())
              .thenAnswer((_) async => tHistoricalModel);
          // act
          repository.getHistory();
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      runTestOnline(
        () {
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getHistory())
                  .thenAnswer((_) async => tHistoricalModel);
              // act
              final result = await repository.getHistory();
              // assert
              verify(mockRemoteDataSource.getHistory());
              expect(result, equals(Right(tHistorical)));
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getHistory())
                  .thenAnswer((_) async => tHistoricalModel);
              // act
              await repository.getHistory();
              // assert
              verify(mockRemoteDataSource.getHistory());
              verify(mockLocalDataSource.cahceHistory(tHistoricalModel));
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(mockRemoteDataSource.getHistory())
                  .thenThrow(ServerException());
              // act
              final result = await repository.getHistory();
              // assert
              verify(mockRemoteDataSource.getHistory());
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );

      runTestOffline(
        () {
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              // arrange
              when(mockLocalDataSource.getSavedHistory())
                  .thenAnswer((_) async => tHistoricalModel);
              // act
              final result = await repository.getHistory();
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getSavedHistory());
              expect(result, equals(Right(tHistorical)));
            },
          );

          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              // arrange
              when(mockLocalDataSource.getSavedHistory())
                  .thenThrow(CacheException());
              // act
              final result = await repository.getHistory();
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getSavedHistory());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
}
