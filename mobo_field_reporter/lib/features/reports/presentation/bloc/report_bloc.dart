import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/create_report.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/get_reports.dart';
import 'package:mobo_field_reporter/features/reports/domain/usecases/usecase.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_state.dart';
import 'package:mobo_field_reporter/features/reports/presentation/report_event.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReports getReports;
  final CreateReport createReport;

  ReportBloc({
    required this.getReports,
    required this.createReport,
  }) : super(const ReportState()) {
    
    // Registrar los handlers de eventos
    on<LoadReports>(_onLoadReports);
    on<AddReport>(_onAddReport);
    // on<DeleteReport>(_onDeleteReport); // Tarea para implementar después
  }

  Future<void> _onLoadReports(
    LoadReports event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(status: ReportStatus.loading));

    final result = await getReports(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: ReportStatus.failure,
        errorMessage: failure.message,
      )),
      (reports) => emit(state.copyWith(
        status: ReportStatus.success,
        reports: reports,
      )),
    );
  }

  Future<void> _onAddReport(
    AddReport event,
    Emitter<ReportState> emit,
  ) async {
    // Nota: Podríamos tener un estado loading específico para el formulario
    // para no bloquear la lista, pero por simplicidad usamos loading general.
    emit(state.copyWith(status: ReportStatus.loading));

    final result = await createReport(CreateReportParams(report: event.report));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ReportStatus.failure,
        errorMessage: failure.message,
      )),
      (success) {
        // ¡Importante! Después de crear, recargamos la lista automáticamente
        // para que la UI refleje el nuevo ítem inmediatamente.
        add(LoadReports()); 
        
        // Opcional: Emitir un estado fugaz para mostrar un Toast de éxito
        // emit(state.copyWith(status: ReportStatus.actionSuccess));
      },
    );
  }
}