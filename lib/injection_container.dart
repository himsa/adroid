import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/historical/data/datasources/historical_local_data_source.dart';
import 'features/historical/data/datasources/historical_remote_data_source.dart';
import 'features/historical/data/repositories/historical_repository_impl.dart';
import 'features/historical/domain/repositories/historical_repository.dart';
import 'features/historical/domain/usecases/get_history.dart';
import 'features/historical/presentation/bloc/historical_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // data sources
  sl.registerLazySingleton<HistoricalRemoteDataSource>(
    () => HistoricalRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<HistoricalLocalDataSource>(
    () => HistoricalLocalDataSourceImpl(sharedPreferences: sl()),
  );
  // core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // repository
  sl.registerLazySingleton<HistoricalRepository>(
    () => HistoricalRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => GetHistory(sl()));

  // features - historical
  // bloc
  sl.registerFactory(() => HistoricalBloc(getHistory: sl()));
}
