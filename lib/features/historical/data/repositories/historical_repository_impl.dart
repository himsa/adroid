import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/historical.dart';
import '../../domain/repositories/historical_repository.dart';
import '../datasources/historical_local_data_source.dart';
import '../datasources/historical_remote_data_source.dart';

class HistoricalRepositoryImpl implements HistoricalRepository {
  final HistoricalRemoteDataSource remoteDataSource;
  final HistoricalLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HistoricalRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, Historical?>>? getHistory() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteHistorical = await remoteDataSource.getHistory();
        localDataSource.cahceHistory(remoteHistorical);
        return Right(remoteHistorical);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localHistory = await localDataSource.getSavedHistory();
        return Right(localHistory);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
