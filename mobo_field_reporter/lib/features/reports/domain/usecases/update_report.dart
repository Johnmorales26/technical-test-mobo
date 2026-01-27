import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/usecase.dart';

import '../../../../core/errors/failures.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class UpdateReport implements UseCase<void, UpdateReportParams> {
  final IReportRepository repository;

  UpdateReport(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateReportParams params) async {
    return await repository.updateReport(params.report);
  }
}

class UpdateReportParams extends Equatable {
  final Report report;

  const UpdateReportParams({required this.report});

  @override
  List<Object> get props => [report];
}