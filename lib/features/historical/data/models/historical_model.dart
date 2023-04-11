import '../../domain/entities/historical.dart';
import 'historical_data_model.dart';

class HistoricalModel extends Historical {
  const HistoricalModel({
    required String symbol,
    required List<HistoricalDataModel> historicalData,
  }) : super(symbol: symbol, historicalData: historicalData);

  factory HistoricalModel.fromJson(Map<String, dynamic> json) {
    return HistoricalModel(
        symbol: json['symbol'],
        historicalData: json['historical'] == null
            ? []
            : (json["historical"] as List)
                .map((e) => HistoricalDataModel.fromJson(e))
                .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'historical': historicalData == null
          ? []
          : historicalData
              ?.map((e) => HistoricalDataModel.fromEntity(e).toJson())
              .toList(),
    };
  }
}
