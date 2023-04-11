part of 'historical_bloc.dart';

abstract class HistoricalState extends Equatable {
  const HistoricalState();

  @override
  List<Object> get props => [];
}

class HistoricalInitial extends HistoricalState {}

class HistoricalLoading extends HistoricalState {}

class HistoricalLoaded extends HistoricalState {
  final Historical historical;

  const HistoricalLoaded({required this.historical});
}

class HistoricalError extends HistoricalState {
  final String message;

  const HistoricalError({required this.message});
}
