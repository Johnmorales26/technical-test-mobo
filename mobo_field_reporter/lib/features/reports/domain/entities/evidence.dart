import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mobo_field_reporter/core/utils/upload_queue_optimizer.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report_enums.dart';

class Evidence extends Equatable implements Uploadable {
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

  @override
  UploadPriority get priority {
    return type == EvidenceType.image
        ? UploadPriority.high
        : UploadPriority.low;
  }

  @override
  double get sizeInMB {
    final file = File(localPath);
    if (file.existsSync()) {
      final bytes = file.lengthSync();
      return bytes / (1024 * 1024);
    }
    return 0.0;
  }

  bool get isUploaded => status == SyncStatus.synced && remoteUrl != null;

  @override
  List<Object?> get props => [id, localPath, remoteUrl, type, status];
}
