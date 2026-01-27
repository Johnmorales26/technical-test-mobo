import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:mobo_field_reporter/core/di/injection.dart';
import 'package:workmanager/workmanager.dart';

import 'core/worker/background_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  Logger logger = Logger();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
      "1", syncTaskName, frequency: const Duration(seconds: 15),
      constraints: Constraints(networkType: NetworkType.connected));

  logger.d('Init worker');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();

    return MaterialApp.router(
      routerConfig: router,
      title: 'Mobo Field Reporter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0056d2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
