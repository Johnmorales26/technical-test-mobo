import 'package:mobo_field_reporter/features/reports/domain/entities/report.dart';

import 'evidence_model.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    super.evidences,
    super.isSynchronized,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map, {List<EvidenceModel>? evidences}) {
    return ReportModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      evidences: evidences ?? [],
      isSynchronized: map['is_synchronized'] == 1,
    );
  }

  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
        id: report.id,
        title: report.title,
        description: report.description,
        date: report.date,
        evidences: report.evidences,
        isSynchronized: report.isSynchronized
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'is_synchronized': isSynchronized ? 1 : 0,
    };
  }
}