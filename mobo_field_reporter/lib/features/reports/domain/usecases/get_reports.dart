import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/usecase.dart';

import '../../../../core/errors/failures.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class GetReports implements UseCase<List<Report>, NoParams> {
  final IReportRepository repository;

  GetReports(this.repository);

  @override
  Future<Either<Failure, List<Report>>> call(NoParams params) async {
    return await repository.getReports();
  }
}