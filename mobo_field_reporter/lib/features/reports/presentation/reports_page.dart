import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobo_field_reporter/core/di/injection.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_bloc.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_event.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportBloc>()..add(LoadReports()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reportes de campo'),
          actions: [
            IconButton(
              onPressed: () => context.read<ReportBloc>().add(LoadReports()),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/create-report');
          },
          label: const Text('Nuevo Reporte'),
          icon: const Icon(Icons.add_a_photo),
        ),
        body: const _ReportsView(),
      ),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state.status == ReportStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error desconocido'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ReportStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.folder_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No hay reportes locales'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: state.reports.length,
          itemBuilder: (context, index) {
            final report = state.reports[index];
            final hasEvidence = report.evidences.isNotEmpty;

            final isSynced = report.isSynchronized;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Hero(
                  tag: 'report_${report.id}',
                  child: CircleAvatar(
                    backgroundColor: isSynced
                        ? Colors.green[100]
                        : Colors.orange[100],
                    child: Icon(
                      hasEvidence ? Icons.image : Icons.note,
                      color: isSynced ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                title: Text(
                  report.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Tooltip(
                  message: isSynced ? 'Sincronizado' : 'Pendiente de subir',
                  child: Icon(
                    isSynced ? Icons.cloud_done : Icons.cloud_off,
                    color: isSynced ? Colors.green : Colors.grey,
                  ),
                ),onTap: () {
                  
                },
              ),
            );
          },
        );
      },
    );
  }
}
