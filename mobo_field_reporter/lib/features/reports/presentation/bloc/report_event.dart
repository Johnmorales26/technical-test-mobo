import 'package:equatable/equatable.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadReports extends ReportEvent {}

class AddReport extends ReportEvent {
  final Report report;

  const AddReport(this.report);

  @override
  List<Object?> get props => [report];
}

class DeleteReport extends ReportEvent {
  final String reportId;

  const DeleteReport(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
