import '../../domain/entities/historical.dart';

class HistoricalDataModel extends HistoricalData {
  const HistoricalDataModel({
    required String? date,
    required double? open,
    required double? high,
    required double? low,
    required double? close,
    required double? adjClose,
    required int? volume,
    required int? unadjustedVolume,
    required double? change,
    required double? changePercent,
    required double? vwap,
    required String? label,
    required double? changeOverTime,
  }) : super(
          date: date,
          open: open,
          high: high,
          low: low,
          close: close,
          adjClose: adjClose,
          volume: volume,
          unadjustedVolume: unadjustedVolume,
          change: change,
          changePercent: changePercent,
          vwap: vwap,
          label: label,
          changeOverTime: changeOverTime,
        );

  factory HistoricalDataModel.fromJson(Map<String, dynamic> json) {
    return HistoricalDataModel(
      date: json['date'],
      open: json['open'].toDouble(),
      high: json['high'].toDouble(),
      low: json['low'].toDouble(),
      close: json['close'].toDouble(),
      adjClose: json['adjClose'].toDouble(),
      volume: json['volume'],
      unadjustedVolume: json['unadjustedVolume'],
      change: json['change'].toDouble(),
      changePercent: json['changePercent'].toDouble(),
      vwap: json['vwap'].toDouble(),
      label: json['label'],
      changeOverTime: json['changeOverTime'].toDouble(),
    );
  }

  factory HistoricalDataModel.fromEntity(HistoricalData entity) {
    return HistoricalDataModel(
      date: entity.date,
      open: entity.open,
      high: entity.high,
      low: entity.low,
      close: entity.close,
      adjClose: entity.adjClose,
      volume: entity.volume,
      unadjustedVolume: entity.unadjustedVolume,
      change: entity.change,
      changePercent: entity.changePercent,
      vwap: entity.vwap,
      label: entity.label,
      changeOverTime: entity.changeOverTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'adjClose': adjClose,
      'volume': volume,
      'unadjustedVolume': unadjustedVolume,
      'change': change,
      'changePercent': changePercent,
      'vwap': vwap,
      'label': label,
      'changeOverTime': changeOverTime,
    };
  }
}
