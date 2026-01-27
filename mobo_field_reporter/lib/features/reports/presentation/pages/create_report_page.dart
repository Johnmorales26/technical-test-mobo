import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobo_field_reporter/core/di/injection.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/evidence.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report.dart';
import 'package:mobo_field_reporter/features/reports/domain/entities/report_enums.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_bloc.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_event.dart';
import 'package:mobo_field_reporter/features/reports/presentation/bloc/report_state.dart';
import 'package:uuid/uuid.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submitReport(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final reportId = const Uuid().v4();
      
      final evidences = <Evidence>[];
      if (_selectedImage != null) {
        evidences.add(Evidence(
          id: const Uuid().v4(),
          localPath: _selectedImage!.path,
          type: EvidenceType.image,
        ));
      }

      final newReport = Report(
        id: reportId,
        title: _titleController.text,
        description: _descController.text,
        date: DateTime.now(),
        evidences: evidences,
        isSynchronized: false,
      );

      context.read<ReportBloc>().add(AddReport(newReport));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportBloc>(), 
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state.status == ReportStatus.success || state.reports.isNotEmpty) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Reporte guardado localmente')),
             );
             context.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Nuevo Reporte')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 24),
                  
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                                Text('Tocar para tomar foto'),
                              ],
                            )
                          : Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Builder(
                    builder: (ctx) {
                      return ElevatedButton.icon(
                        onPressed: () => _submitReport(ctx),
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar Reporte (Offline)'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}