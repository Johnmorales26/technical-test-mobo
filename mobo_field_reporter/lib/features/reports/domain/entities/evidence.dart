import 'package:equatable/equatable.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report_enums.dart';

class Evidence extends Equatable {
  final String id;
  final String localPath;
  final String? remoteUrl;
  final EvidenceType type;
  final SyncStatus status;

  const Evidence({
    required this.id,
    required this.localPath,
    this.remoteUrl,
    required this.type,
    this.status = SyncStatus.pending,
  });

  bool get isUploaded => status == SyncStatus.synced && remoteUrl != null;

  @override
  List<Object?> get props => [id, localPath, remoteUrl, type, status];
}
