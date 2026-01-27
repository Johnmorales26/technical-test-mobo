import 'package:workmanager/workmanager.dart';

import '../../features/reports/domain/usecases/sync_pending_data.dart';
import '../../features/reports/domain/usecases/usecase.dart';
import '../di/injection.dart';

const syncTaskName = "syncPendingEvidenceTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await configureDependencies();

      final syncUseCase = getIt<SyncPendingData>();

      print("WORKER: Iniciando sincronización...");
      await syncUseCase(NoParams());
      print("WORKER: Sincronización finalizada.");

      return Future.value(true);
    } catch (e) {
      print("WORKER ERROR: $e");
      return Future.value(false);
    }
  });
}