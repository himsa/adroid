// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:adroid/core/error/failures.dart';
import 'package:adroid/core/usecases/usecase.dart';
import 'package:adroid/features/historical/domain/entities/historical.dart';
import 'package:adroid/features/historical/domain/usecases/get_history.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'historical_event.dart';
part 'historical_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class HistoricalBloc extends Bloc<HistoricalEvent, HistoricalState> {
  final GetHistory getHistory;
  HistoricalBloc({required this.getHistory}) : super(HistoricalInitial()) {
    on<HistoricalEvent>((event, emit) async {
      if (event is GetHistoricalEvent) {
        emit(HistoricalLoading());
        final failureOrHistory = await getHistory.call(NoParam());
        emit(
          failureOrHistory!.fold(
            (failure) =>
                HistoricalError(message: _mapFailureToMessage(failure)),
            (historical) => HistoricalLoaded(historical: historical!),
          ),
        );
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
