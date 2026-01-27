import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobo_field_reporter/core/utils/upload_queue_optimizer.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/usecase.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class SyncPendingData implements UseCase<void, NoParams> {
  final IReportRepository repository;
  final UploadQueueOptimizer optimizer;

  SyncPendingData(this.repository) : optimizer = UploadQueueOptimizer();

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final pendingResult = await repository.getPendingEvidence();

    return pendingResult.fold(
          (failure) => Left(failure),
          (evidences) async {
        if (evidences.isEmpty) return const Right(null);

        final optimizedQueue = optimizer.optimize(evidences);

        for (var evidence in optimizedQueue) {
          if (repository is ReportRepositoryImpl) {
            final repoImpl = repository as ReportRepositoryImpl;
            final uploadResult = await repoImpl.uploadEvidenceFile(evidence);

            uploadResult.fold(
                    (fail) => print('Fallo subida ${evidence.id}: ${fail.message}'),
                    (url) async {
                  await repository.markEvidenceAsSynced(evidence.id, url);
                }
            );
          }
        }
        return const Right(null);
      },
    );
  }
}