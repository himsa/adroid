import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/historical.dart';
import '../repositories/historical_repository.dart';

class GetHistory implements UseCase<Historical, NoParam> {
  final HistoricalRepository repository;

  GetHistory(this.repository);

  @override
  Future<Either<Failure, Historical?>?>? call(NoParam param) async {
    return await repository.getHistory();
  }
}
