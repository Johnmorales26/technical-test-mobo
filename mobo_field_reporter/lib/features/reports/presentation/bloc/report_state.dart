import 'package:equatable/equatable.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report.dart';

enum ReportStatus { initial, loading, success, failure, actionSuccess }

class ReportState extends Equatable {
  final ReportStatus status;
  final List<Report> reports;
  final String? errorMessage;

  const ReportState({
    this.status = ReportStatus.initial,
    this.reports = const [],
    this.errorMessage,
  });

  ReportState copyWith({
    ReportStatus? status,
    List<Report>? reports,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage];
}