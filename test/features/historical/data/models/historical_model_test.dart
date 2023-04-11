// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:adroid/features/historical/data/models/historical_data_model.dart';
import 'package:adroid/features/historical/data/models/historical_model.dart';
import 'package:adroid/features/historical/domain/entities/historical.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tHistoricalEmptyModel =
      HistoricalModel(symbol: 'AAPL', historicalData: []);
  final tHistoricalModel = HistoricalModel(
    symbol: 'AAPL',
    historicalData: [
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

  test(
    'should be a subclass of Historical entity',
    () async {
      // assert
      expect(tHistoricalModel, isA<Historical>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON is Empty',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('historical_empty.json'));
          // act
          final result = HistoricalModel.fromJson(jsonMap);
          // assert
          expect(result, tHistoricalEmptyModel);
        },
      );
      test(
        'should return a valid model when the JSON is Not Empty',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('historical.json'));
          // act
          final result = HistoricalModel.fromJson(jsonMap);
          // assert
          expect(result, tHistoricalModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing the propper data',
        () async {
          // act
          final result = tHistoricalModel.toJson();
          // assert
          final expectedMap = {
            "symbol": "AAPL",
            "historical": [
              {
                "date": "2023-01-20",
                "open": 135.28,
                "high": 135.28,
                "low": 135.28,
                "close": 135.28,
                "adjClose": 135.28,
                "volume": 74853563,
                "unadjustedVolume": 74853563,
                "change": 135.28,
                "changePercent": 135.28,
                "vwap": 135.28,
                "label": "January 20, 23",
                "changeOverTime": 135.28
              }
            ]
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
