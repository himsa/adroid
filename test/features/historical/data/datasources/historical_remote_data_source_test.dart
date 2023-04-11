// ignore_for_file: prefer_const_declarations

import 'dart:convert';

import 'package:adroid/core/error/exceptions.dart';
import 'package:adroid/features/historical/data/datasources/historical_remote_data_source.dart';
import 'package:adroid/features/historical/data/models/historical_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'historical_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late HistoricalRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  setUp(() {
    mockClient = MockClient();
    dataSource = HistoricalRemoteDataSourceImpl(client: mockClient);
  });

  final tHistoricalModel =
      HistoricalModel.fromJson(json.decode(fixture('historical.json')));

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('historical.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getHistory', () {
    test(
      'should perform GET request on a URL with appliacation/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getHistory();
        // assert
        final uri = Uri.https(
          'financialmodelingprep.com',
          'api/v3/historical-price-full/AAPL',
          {'apikey': '972a40ec3fd15d05e91131e1feb80be2'},
        );
        verify(mockClient.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Historical when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getHistory();
        // assert
        expect(result, equals(tHistoricalModel));
      },
    );

    test(
      'should throw ServerException when the response is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // assert
        expect(
          () => dataSource.getHistory(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
