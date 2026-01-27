import 'package:dartz/dartz.dart';
import 'package:mobo_field_reporter/core/errors/failures.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report.dart';

abstract class IReportRepository {

  Future<Either<Failure, List<Report>>> getReports();


  Future<Either<Failure, Report>> getReportById(String id);


  Future<Either<Failure, void>> createReport(Report report);


  Future<Either<Failure, void>> updateReport(Report report);

  
  Future<Either<Failure, void>> deleteReport(String id);
}