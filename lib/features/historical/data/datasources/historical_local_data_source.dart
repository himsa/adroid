// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:adroid/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/historical_model.dart';

abstract class HistoricalLocalDataSource {
  Future<HistoricalModel> getSavedHistory();

  Future<void> cahceHistory(HistoricalModel? historicaltoChache);
}

const CACHED_HISTORICAL = 'CACHED_HISTORICAL';

class HistoricalLocalDataSourceImpl implements HistoricalLocalDataSource {
  final SharedPreferences sharedPreferences;

  HistoricalLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<HistoricalModel> getSavedHistory() {
    final jsonString = sharedPreferences.getString(CACHED_HISTORICAL);
    if (jsonString != null) {
      return Future.value(HistoricalModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cahceHistory(HistoricalModel? historicaltoChache) {
    return sharedPreferences.setString(
      CACHED_HISTORICAL,
      json.encode(historicaltoChache?.toJson()),
    );
  }
}
