import 'package:equatable/equatable.dart';

class Historical extends Equatable {
  final String? symbol;
  final List<HistoricalData>? historicalData;

  const Historical({required this.symbol, required this.historicalData});

  @override
  List<Object?> get props => [symbol, historicalData];
}

class HistoricalData extends Equatable {
  final String? date;
  final double? open;
  final double? high;
  final double? low;
  final double? close;
  final double? adjClose;
  final int? volume;
  final int? unadjustedVolume;
  final double? change;
  final double? changePercent;
  final double? vwap;
  final String? label;
  final double? changeOverTime;

  const HistoricalData(
      {required this.date,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.adjClose,
      required this.volume,
      required this.unadjustedVolume,
      required this.change,
      required this.changePercent,
      required this.vwap,
      required this.label,
      required this.changeOverTime});

  @override
  List<Object?> get props => [
        date,
        open,
        high,
        low,
        close,
        adjClose,
        volume,
        unadjustedVolume,
        change,
        changePercent,
        vwap,
        label,
        changeOverTime
      ];
}
