import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/historical.dart';

abstract class HistoricalRepository {
  Future<Either<Failure, Historical?>>? getHistory();
}
