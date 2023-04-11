// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'package:adroid/core/error/failures.dart';
import 'package:adroid/features/historical/domain/entities/historical.dart';
import 'package:adroid/features/historical/domain/usecases/get_history.dart';
import 'package:adroid/features/historical/presentation/bloc/historical_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'historical_bloc_test.mocks.dart';

@GenerateMocks([GetHistory])
void main() {
  late HistoricalBloc bloc;
  late MockGetHistory mockGetHistory;

  setUp(() {
    mockGetHistory = MockGetHistory();
    bloc = HistoricalBloc(getHistory: mockGetHistory);
  });

  final tSymbol = 'AAPL';
  final tHistory = Historical(
    symbol: tSymbol,
    historicalData: const [],
  );

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(HistoricalInitial()));
  });

  group('GetHistory', () {
    test(
      'should get data from the gethistory use case',
      () async {
        // arrange
        when(mockGetHistory(any)).thenAnswer((_) async => Right(tHistory));
        // act
        bloc.add(GetHistoricalEvent());
        await untilCalled(mockGetHistory(any));
        // assert
        verify(mockGetHistory(any));
      },
    );

    blocTest<HistoricalBloc, HistoricalState>(
      'should emit [HistoricalLoading, HistoricalLoaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () =>
          when(mockGetHistory(any)).thenAnswer((_) async => Right(tHistory)),
      act: (bloc) => bloc.add(GetHistoricalEvent()),
      expect: () => [
        HistoricalLoading(),
        HistoricalLoaded(historical: tHistory),
      ],
    );

    blocTest<HistoricalBloc, HistoricalState>(
      'should emit [HistoricalLoading, HistoricalError] when getting data fails',
      build: () => bloc,
      setUp: () => when(mockGetHistory(any))
          .thenAnswer((_) async => Left(ServerFailure())),
      act: (bloc) => bloc.add(GetHistoricalEvent()),
      expect: () => [
        HistoricalLoading(),
        HistoricalError(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<HistoricalBloc, HistoricalState>(
      'should emit [HistoricalLoading, HistoricalError] with propper message for the error when getting data fails',
      build: () => bloc,
      setUp: () => when(mockGetHistory(any))
          .thenAnswer((_) async => Left(CacheFailure())),
      act: (bloc) => bloc.add(GetHistoricalEvent()),
      expect: () => [
        HistoricalLoading(),
        HistoricalError(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
