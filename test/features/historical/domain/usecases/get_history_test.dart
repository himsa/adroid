// ignore_for_file: prefer_const_declarations, prefer_const_literals_to_create_immutables

import 'package:adroid/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:adroid/features/historical/domain/entities/historical.dart';
import 'package:adroid/features/historical/domain/repositories/historical_repository.dart';
import 'package:adroid/features/historical/domain/usecases/get_history.dart';

import 'get_history_test.mocks.dart';

@GenerateMocks([HistoricalRepository])
void main() {
  late GetHistory usecase;
  late MockHistoricalRepository mockHistoricalRepository;
  setUp(() {
    mockHistoricalRepository = MockHistoricalRepository();
    usecase = GetHistory(mockHistoricalRepository);
  });
  final tSymbol = 'AAPL';
  final tHistory = Historical(
    symbol: tSymbol,
    historicalData: [],
  );
  test(
    'should get history from the repository',
    () async {
      // arrange
      when(mockHistoricalRepository.getHistory())
          .thenAnswer((_) async => Right(tHistory));
      // act
      final result = await usecase(NoParam());
      // assert
      expect(result, Right(tHistory));
      verify(mockHistoricalRepository.getHistory());
      verifyNoMoreInteractions(mockHistoricalRepository);
    },
  );
}
