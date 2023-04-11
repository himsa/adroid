part of 'historical_bloc.dart';

abstract class HistoricalEvent extends Equatable {
  const HistoricalEvent();

  @override
  List<Object> get props => [];
}

class GetHistoricalEvent extends HistoricalEvent {}
