import 'package:equatable/equatable.dart';

import 'evidence.dart';

class Report extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final List<Evidence> evidences;
  final bool isSynchronized;

  const Report({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.evidences = const [],
    this.isSynchronized = false,
  });

  bool get checkGlobalSyncStatus {
    if (evidences.isEmpty) return true;
    return evidences.every((e) => e.isUploaded);
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    evidences,
    isSynchronized,
  ];
}
