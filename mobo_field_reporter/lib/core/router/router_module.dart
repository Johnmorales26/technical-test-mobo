import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mobo_field_reporter/features/reports/presentation/pages/create_report_page.dart';
import 'package:mobo_field_reporter/features/reports/presentation/reports_page.dart';

@module
abstract class RouterModule {
  @singleton
  GoRouter get router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const ReportsPage(),
        routes: [
          GoRoute(
            path: 'create-report',
            name: 'create_report',
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true, 
              child: CreateReportPage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ReportsPage(), 
  );
}