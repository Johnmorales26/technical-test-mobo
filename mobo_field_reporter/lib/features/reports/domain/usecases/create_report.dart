import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/usecase.dart';

import '../../../../core/errors/failures.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class CreateReport implements UseCase<void, CreateReportParams> {
  final IReportRepository repository;

  CreateReport(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateReportParams params) async {
    return await repository.createReport(params.report);
  }
}

class CreateReportParams extends Equatable {
  final Report report;

  const CreateReportParams({required this.report});

  @override
  List<Object> get props => [report];
}