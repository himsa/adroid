import 'dart:convert';

import 'package:adroid/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/historical_model.dart';

abstract class HistoricalRemoteDataSource {
  Future<HistoricalModel>? getHistory();
}

class HistoricalRemoteDataSourceImpl implements HistoricalRemoteDataSource {
  final http.Client client;

  HistoricalRemoteDataSourceImpl({required this.client});

  @override
  Future<HistoricalModel>? getHistory() async {
    final uri = Uri.https(
      'financialmodelingprep.com',
      'api/v3/historical-price-full/AAPL',
      {'apikey': '972a40ec3fd15d05e91131e1feb80be2'},
    );
    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return HistoricalModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
