import 'package:mobo_field_reporter/features/reports/domain/entities/report_enums.dart';

import 'evidence.dart';

class EvidenceModel extends Evidence {
  const EvidenceModel({
    required super.id,
    required super.localPath,
    super.remoteUrl,
    required super.type,
    super.status,
  });

  factory EvidenceModel.fromMap(Map<String, dynamic> map) {
    return EvidenceModel(
      id: map['id'],
      localPath: map['local_path'],
      remoteUrl: map['remote_url'],
      type: EvidenceType.values.firstWhere((e) => e.name == map['type']),
      status: SyncStatus.values.firstWhere((e) => e.name == map['status']),
    );
  }

  factory EvidenceModel.fromEntity(Evidence evidence) {
    return EvidenceModel(
      id: evidence.id,
      localPath: evidence.localPath,
      remoteUrl: evidence.remoteUrl,
      type: evidence.type,
      status: evidence.status,
    );
  }

  Map<String, dynamic> toMap(String reportId) {
    return {
      'id': id,
      'report_id': reportId,
      'local_path': localPath,
      'remote_url': remoteUrl,
      'type': type.name,
      'status': status.name,
    };
  }
}