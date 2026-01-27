import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/evidence_model.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_model.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/local/database_helper.dart';

@LazySingleton(as: IReportRepository)
class ReportRepositoryImpl implements IReportRepository {
  final DatabaseHelper _dbHelper;

  ReportRepositoryImpl(this._dbHelper);

  @override
  Future<Either<Failure, void>> createReport(Report report) async {
    try {
      final db = await _dbHelper.database;
      final reportModel = ReportModel.fromEntity(report);

      await db.transaction((txn) async {
        await txn.insert(
            'reports',
            reportModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace
        );

        for (var evidence in report.evidences) {
          final evidenceModel = EvidenceModel.fromEntity(evidence);
          await txn.insert(
              'evidences',
              evidenceModel.toMap(report.id),
              conflictAlgorithm: ConflictAlgorithm.replace
          );
        }
      });

      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getReports() async {
    try {
      final db = await _dbHelper.database;

      final reportMaps = await db.query('reports', orderBy: 'date DESC');

      List<Report> reports = [];

      for (var reportMap in reportMaps) {
        final reportId = reportMap['id'] as String;
        final evidenceMaps = await db.query(
          'evidences',
          where: 'report_id = ?',
          whereArgs: [reportId],
        );

        final evidences = evidenceMaps
            .map((e) => EvidenceModel.fromMap(e))
            .toList();

        reports.add(ReportModel.fromMap(reportMap, evidences: evidences));
      }

      return Right(reports);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReport(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('reports', where: 'id = ?', whereArgs: [id]);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Report>> getReportById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateReport(Report report) async {
    return createReport(report);
  }
}