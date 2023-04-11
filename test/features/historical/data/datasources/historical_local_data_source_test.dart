// ignore_for_file: prefer_const_declarations

import 'dart:convert';

import 'package:adroid/core/error/exceptions.dart';
import 'package:adroid/features/historical/data/datasources/historical_local_data_source.dart';
import 'package:adroid/features/historical/data/models/historical_data_model.dart';
import 'package:adroid/features/historical/data/models/historical_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'historical_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late HistoricalLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = HistoricalLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });
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

  group('getSavedHistory', () {
    final tHistoricalModel = HistoricalModel.fromJson(
        json.decode(fixture('historical_cached.json')));
    test(
      'should return Historical from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('historical_cached.json'));
        // act
        final result = await dataSource.getSavedHistory();
        // assert
        verify(mockSharedPreferences.getString(CACHED_HISTORICAL));
        expect(result, equals(tHistoricalModel));
      },
    );

    test(
      'should throw CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // assert
        expect(
          () => dataSource.getSavedHistory(),
          throwsA(isA<CacheException>()),
        );
      },
    );
  });

  group('cacheHistory', () {
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        // act
        dataSource.cahceHistory(tHistoricalModel);
        // assert
        final expectedJsonString = json.encode(tHistoricalModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_HISTORICAL,
          expectedJsonString,
        ));
      },
    );
  });
}
